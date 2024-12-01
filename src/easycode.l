%{
#include <stdio.h>
int nb_ligne = 1;
%}

lettre [a-zA-Z]
chiffre [0-9]
IDF {lettre}({lettre}|{chiffre})*
cst {chiffre}+
reel {chiffre}+"."+{chiffre}+
string \"[^\"]*\"
commentaire1 "--"([^#]*"##")
commentaire2 "\\{-"([^\\-]*"\\-\\}")

%%

"DEBUT"              printf("DEBUT reconnu\n");
"FIN"                printf("FIN reconnu\n");
"EXECUTION"          printf("EXECUTION reconnu\n");
"NUM"                printf("NUM reconnu\n");
"REAL"               printf("REAL reconnu\n");
"TEXT"               printf("TEXT reconnu\n");
"FIXE"               printf("FIXE reconnu\n");
"SI"                 printf("SI reconnu\n");
"ALORS"              printf("ALORS reconnu\n");
"SINON"              printf("SINON reconnu\n");
"TANTQUE"            printf("TANTQUE reconnu\n");
"FAIRE"              printf("FAIRE reconnu\n");

{IDF}                printf("IDF reconnu %s\n", yytext);
{reel}               printf("REEL reconnu %s\n", yytext);
{cst}                printf("CST reconnu %s\n", yytext);
{string}             printf("STRING reconnu %s\n", yytext);
":"                  printf("deux-points reconnu\n");
"<-"                 printf("affectation reconnu\n");
";"                  printf("pvg reconnu\n");
{commentaire1}       printf("commentaire 1 reconnu\n");
{commentaire2}       printf("commentaire 2 reconnu\n");

[ \t]+               ; /* Ignore multiple whitespace characters */
\n                   { nb_ligne++; }
.                    { printf("erreur lexicale à la ligne %d\n", nb_ligne); }

%%

int main() {
    FILE *file;
    file = fopen("test.txt", "r");
    if (file == NULL) {
        printf("ERROR: Cannot open test.txt\n");
    } else {
        yyin = file;
        yylex();
        fclose(file);
    }
    return 0;
}
