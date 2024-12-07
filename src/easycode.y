%{
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include "symbol_table.h"

// Déclaration de la table des symboles
extern SymbolTable* symbolTable;

// Déclaration des fonctions sémantiques
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

%type <str> variable
%type <num> expression

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
        if (lookup_symbol($2) != NULL) {
            declaration_error($2);
        } else {
            insert_symbol($2, $1);
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
        if (lookup_symbol($1) == NULL) {
            undeclared_variable_error($1);
        } else {
            if (strcmp(lookup_symbol($1)->type, "FIXE") == 0) {
                constant_reassignment_error($1);
            } else {
                check_type_error($1, lookup_symbol($1)->type, "NUM");
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
        if (lookup_symbol($1) == NULL) {
            undeclared_variable_error($1);
        } else {
            $$ = lookup_symbol($1)->value;
        }
    }
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

// Implémentation des fonctions sémantiques

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
    yyparse();
    return 0;
}