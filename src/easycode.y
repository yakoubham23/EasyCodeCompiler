%{
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include "symboles.h"

SymbolTable* symbolTable;

void declaration_error(const char* id);
void check_type_error(const char* id, const char* expected, const char* actual);
void undeclared_variable_error(const char* id);
void division_by_zero_error();
void constant_reassignment_error(const char* id);

%}

%union {
    int num;
    float real;
    char* str;
}

%token <num> NUM
%token <real> REAL
%token <str> TEXT
%token <str> IDENTIFIER
%token DEBUT FIN EXECUTION SI ALORS SINON TANTQUE
%token FIXE
%token ASSIGN EQ NEQ LT LE GT GE AND OR NOT
%token ADD SUB MUL DIV
%token LPAREN RPAREN LBRACE RBRACE

%type <str> type
%type <num> expression

%left ADD SUB    // Priorité de gauche pour les opérateurs ADD et SUB
%left MUL DIV    // Priorité de gauche pour les opérateurs MUL et DIV
%left AND OR     // Priorité de gauche pour les opérateurs logiques
%right EQ NEQ LT LE GT GE  // Priorité de droite pour les comparaisons

%%

program:
    DEBUT declarations EXECUTION instructions FIN
;

declarations:
    /* Rien */
    | declarations declaration
;

declaration:
    type IDENTIFIER {
        if (lookup_symbol(symbolTable, $2) != NULL) {
            declaration_error($2);
        } else {
            insert_symbol(symbolTable, $2, $1);
        }
    }
;

type:
    NUM { $$ = "NUM"; }
    | REAL { $$ = "REAL"; }
    | TEXT { $$ = "TEXT"; }
    | FIXE { $$ = "FIXE"; }
;

instructions:
    /* Rien */
    | instructions instruction
;

instruction:
    IDENTIFIER ASSIGN expression {
        Symbol* symbol = lookup_symbol(symbolTable, $1);
        if (symbol == NULL) {
            undeclared_variable_error($1);
        } else {
            if (strcmp(symbol->type, "FIXE") == 0) {
                constant_reassignment_error($1);
            } else {
                check_type_error($1, symbol->type, "NUM");
                symbol->value = $3;  // Met à jour la valeur de la variable
                printf("Affectation : %s <- %d\n", $1, $3);
            }
        }
    }
    | SI LPAREN expression RPAREN ALORS instructions SINON instructions {
        printf("Condition SI alors\n");
    }
    | TANTQUE LPAREN expression RPAREN LBRACE instructions RBRACE {
        printf("Boucle TANTQUE\n");
    }
;

expression:
    NUM { $$ = $1; }
    | REAL { $$ = $1; }
    | IDENTIFIER { 
        Symbol* symbol = lookup_symbol(symbolTable, $1);
        if (symbol == NULL) {
            undeclared_variable_error($1);
        } else {
            $$ = symbol->value;  // Récupère la valeur de la variable
        }
    }
    | LPAREN expression RPAREN { $$ = $2; } // Parenthèses pour priorités
    | expression ADD expression { $$ = $1 + $3; }
    | expression SUB expression { $$ = $1 - $3; }
    | expression MUL expression { $$ = $1 * $3; }
    | expression DIV expression {
        if ($3 == 0) {
            division_by_zero_error();
        } else {
            $$ = $1 / $3;
        }
    }
;

%%

void declaration_error(const char* id) {
    fprintf(stderr, "Erreur: Déclaration multiple de la variable '%s'.\n", id);
    exit(1);
}

void undeclared_variable_error(const char* id) {
    fprintf(stderr, "Erreur: La variable '%s' n'est pas déclarée.\n", id);
    exit(1);
}

void check_type_error(const char* id, const char* expected, const char* actual) {
    if (strcmp(expected, actual) != 0) {
        fprintf(stderr, "Erreur de type : variable '%s' attendue de type '%s' mais de type '%s'.\n", id, expected, actual);
        exit(1);
    }
}

void division_by_zero_error() {
    fprintf(stderr, "Erreur : Division par zéro.\n");
    exit(1);
}

void constant_reassignment_error(const char* id) {
    fprintf(stderr, "Erreur : Tentative de modification de la constante '%s'.\n", id);
    exit(1);
}

int main() {
    symbolTable = create_symbol_table(); // Création de la table des symboles
    yyparse();
    free_symbol_table(symbolTable);  // Libération de la mémoire de la table des symboles
    return 0;
}
