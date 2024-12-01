%{
#include <stdio.h>
#include "y.tab.h"
int nb_ligne = 1;

void test_file(const char *filename);
%}



lettre [a-zA-Z]
majuscule [A-Z]
chiffre [0-9]
IDF [A-Z][a-zA-Z0-9_]{0,9} /* Identificateur commençant par une lettre majuscule, longueur max 10 */
cst -?{chiffre}+
reel -?{chiffre}+"."+{chiffre}+
string \"[^\"]*\"
commentaire1 "--"[^#]*"##"
commentaire2 "\\{-"[^\\-]*"\\-\\}"
taille_tableau "\\[{cst}\\]"


/* Pour FIXE_DECL : Expression correspondant aux déclarations de constantes */
FIXE_DECL FIXE[ \t]+(NUM|REAL|TEXT)[ \t]*:[ \t]*{IDF}[ \t]*=[ \t]*{cst};


%%

"DEBUT"              { return DEBUT; }
"FIN"                { return FIN; }
"EXECUTION"          { return EXECUTION; }
"NUM"                { return NUM; }
"REAL"               { return REAL; }
"TEXT"               { return TEXT; }
"FIXE"               { return FIXE; }
"SI"                 { return SI; }
"ALORS"              { return ALORS; }
"SINON"              { return SINON; }
"TANTQUE"            { return TANTQUE; }
"FAIRE"              { return FAIRE; }
"ET"                 { return ET; }
"OU"                 { return OU; }
"NON"                { return NON; }

"="                  { return EGAL; }
"!="                 { return DIFF; }
"<"                  { return INF; }
"<="                 { return INFEGAL; }
">"                  { return SUP; }
">="                 { return SUPEGAL; }

"+"                  { return PLUS; }
"-"                  { return MOINS; }
"*"                  { return FOIS; }
"/"                  { return DIV; }

"affiche"            { return AFFICHE; }
"lire"               { return LIRE; }
":"                  { return DEUXPOINTS; }
"<-"                 { return AFFECT; }
";"                  { return PVG; }
"{"                  { return ACCOUVRANT; }
"}"                  { return ACCFERMANT; }


{reel}               { printf("Nombre réel reconnu : %s\n", yytext); }
{cst}                { printf("Constante entière reconnue : %s\n", yytext); }
{string}             { printf("Chaîne de caractères reconnue : %s\n", yytext); }
{commentaire1}       { printf("Commentaire (type 1) reconnu\n"); }
{commentaire2}       { printf("Commentaire (type 2) reconnu\n"); }



[ \t]+               ; /* Ignorer les espaces multiples */
\n                   { nb_ligne++; }
.                    { printf("Erreur lexicale à la ligne %d : caractère non reconnu '%s'\n", nb_ligne, yytext); }

%%

void test_file(const char *filename) {
    FILE *file = fopen(filename, "r");
    if (file == NULL) {
        printf("ERROR: Cannot open %s\n", filename);
        return;
    }
    yyin = file;
    printf("Testing %s\n", filename);
    nb_ligne = 1; // Réinitialiser le numéro de ligne pour chaque fichier
    yylex();
    fclose(file);
}

int main(int argc, char **argv) {
    if (argc < 2) {
        printf("Usage: %s <file1> <file2> ... <fileN>\n", argv[0]);
        return 1;
    }
    for (int i = 1; i < argc; i++) {
        test_file(argv[i]);
    }
    return 0;
}
