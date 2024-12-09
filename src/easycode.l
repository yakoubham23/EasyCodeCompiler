%option yylineno
/* Importation C */
%{
  #include<ctype.h>
  #include<stdio.h>
  #include <string.h>
  int nb_ligne=1;
  int nb_colonne=1;    
%}

/* Expressions régulières */
lettre [a-zA-Z]  
lettreMaj[A-Z]
underscore _
chiffre [0-9]
IDF {lettreMaj}({lettre}|{chiffre}|{underscore}){0,9}
NUM 0|[1-9][0-9]*
SIGNEDNUM [+-]?{NUM}
REAL 0\.[0-9]+|[1-9][0-9]*\.[0-9]+
SIGNEDREAL [+-]?{REAL}
TEXT \"[^\"]*\"
commentaire_sur_ligne --[^\n]*##
commentaire_multi_lignes \{-(.|\n)*?-\}


/* Règles de production */
%%
"DEBUT" { nb_colonne += strlen(yytext); printf("\033[32m[SUCCESS]  KeyWord:DEBUT reconnu\033[0m\n");}
"FIN" { nb_colonne += strlen(yytext); printf("\033[32m[SUCCESS]  KeyWord:FIN reconnu\033[0m\n");}
"TEXT" { nb_colonne += strlen(yytext); printf("\033[32m[SUCCESS] KeyWord pour le type:TEXT reconnu\033[0m\n");}
"NUM" { nb_colonne += strlen(yytext); printf("\033[32m[SUCCESS]  KeyWord pour le type:NUM reconnu\033[0m\n");}
"REAL" { nb_colonne += strlen(yytext); printf("\033[32m[SUCCESS]  KeyWord pour le type:REAL reconnu\033[0m\n");}
"EXECUTION" {nb_colonne += strlen(yytext); printf("\033[32m[SUCCESS]  KeyWord:EXECUTION reconnu\033[0m\n");}
"SI" {nb_colonne += strlen(yytext); printf("\033[32m[SUCCESS]  KeyWord:SI reconnu\033[0m\n");}
"ALORS" {nb_colonne += strlen(yytext); printf("\033[32m[SUCCESS]  KeyWord:ALORS reconnu\033[0m\n");}
"SINON" {nb_colonne += strlen(yytext); printf("\033[32m[SUCCESS]  KeyWord:SINON reconnu\033[0m\n");}
"TANTQUE" {nb_colonne += strlen(yytext); printf("\033[32m[SUCCESS]  KeyWord:TANTQUE reconnu\033[0m\n");}
"FAIRE" {nb_colonne += strlen(yytext); printf("\033[32m[SUCCESS]  KeyWord:FAIRE reconnu\033[0m\n");}
"FIXE" {nb_colonne += strlen(yytext); printf("\033[32m[SUCCESS]  KeyWord:FIXE reconnu\033[0m\n");}
"affiche" {nb_colonne += strlen(yytext); printf("\033[32m[SUCCESS]  KeyWord:affiche reconnu\033[0m\n");}
"lire" {nb_colonne += strlen(yytext); printf("\033[32m[SUCCESS]  KeyWord:lire reconnu\033[0m\n");}
"OU" { nb_colonne += strlen(yytext); printf("\033[32m[SUCCESS] KeyWord:OU reconnu\033[0m\n"); }
"ET" { nb_colonne += strlen(yytext); printf("\033[32m[SUCCESS] KeyWord:ET reconnu\033[0m\n"); }
"NON" { nb_colonne += strlen(yytext); printf("\033[32m[SUCCESS] KeyWord:NON reconnu\033[0m\n"); }
"{" { nb_colonne += strlen(yytext); printf("\033[32m[SUCCESS] LFBRA reconnu\033[0m\n");}
"}" { nb_colonne += strlen(yytext); printf("\033[32m[SUCCESS] RTBRA reconnu\033[0m\n"); }
"[" { nb_colonne += strlen(yytext); printf("\033[32m[SUCCESS] LFSQBRA reconnu\033[0m\n"); }
"]" { nb_colonne += strlen(yytext); printf("\033[32m[SUCCESS] RTSQBRA reconnu\033[0m\n"); }
"(" { nb_colonne += strlen(yytext); printf("\033[32m[SUCCESS] LFPar reconnu\033[0m\n"); }
")" { nb_colonne += strlen(yytext);printf("\033[32m[SUCCESS] RTPar reconnu\033[0m\n"); }
"-" { nb_colonne += strlen(yytext); printf("\033[32m[SUCCESS] MINS reconnu\033[0m\n"); }
"+" { nb_colonne += strlen(yytext); printf("\033[32m[SUCCESS] PLS reconnu\033[0m\n"); }
"*" { nb_colonne += strlen(yytext); printf("\033[32m[SUCCESS] MULT reconnu\033[0m\n"); }
"/" { nb_colonne += strlen(yytext); printf("\033[32m[SUCCESS] DIV reconnu\033[0m\n"); }
"," { nb_colonne += strlen(yytext); printf("\033[32m[SUCCESS] 'vg' reconnu\033[0m\n"); }
";" { nb_colonne += strlen(yytext); printf("\033[32m[SUCCESS] 'pvg reconnu\033[0m\n"); }
"=" { nb_colonne += strlen(yytext); printf("\033[32m[SUCCESS] '=' reconnu\033[0m\n"); }
":" {nb_colonne += strlen(yytext); printf("\033[32m[SUCCESS] ':' reconnu\033[0m\n");}
"<-" {nb_colonne += strlen(yytext); printf("\033[32m[SUCCESS] '<-' affectation  reconnu\033[0m\n");}
"<" { nb_colonne += strlen(yytext); printf("\033[32m[SUCCESS] '<' reconnu\033[0m\n"); }
"<=" { nb_colonne += strlen(yytext); printf("\033[32m[SUCCESS] '<=' reconnu\033[0m\n"); }
">" { nb_colonne += strlen(yytext); printf("\033[32m[SUCCESS] '>' reconnu\033[0m\n"); }
">=" { nb_colonne += strlen(yytext); printf("\033[32m[SUCCESS] '>=' reconnu\033[0m\n"); }
"!=" { nb_colonne += strlen(yytext); printf("\033[32m[SUCCESS] '!=' reconnu\033[0m\n"); }

{IDF} {
  if (strlen(yytext) > 10) {
    printf("\033[31m[ERROR] Identifiant trop long : %s a la ligne %d, colonne %d\033[0m\n", yytext, nb_ligne, nb_colonne);
  } else {
    printf("\033[32m[SUCCESS] Identifiant valide : %s a la ligne %d, colonne %d\033[0m\n", yytext, nb_ligne, nb_colonne);
  }
  nb_colonne += strlen(yytext);
}
{commentaire_sur_ligne} { 
  nb_colonne += strlen(yytext); 
  printf("\033[34m[INFO] Commentaire sur une ligne ignore\033[0m\n"); 
}

{commentaire_multi_lignes} { 
  char *ptr = yytext; 
  while ((ptr = strchr(ptr, '\n')) != NULL) { 
    nb_ligne++; 
    ptr++; 
  } 
  nb_colonne = 1; 
  printf("\033[34m[INFO] Commentaire multi-lignes ignore\033[0m\n");
}

{TEXT} { 
  printf("\033[32m[SUCCESS] Texte reconnu: %s\033[0m\n", yytext); 
  nb_colonne += strlen(yytext); 
}

{NUM} {
  int val = atoi(yytext); 
  if (val < 0 || val > 32767) {
    printf("\033[31m[ERROR] Nombre hors plage (%s) à la ligne %d, colonne %d\033[0m\n", yytext, nb_ligne, nb_colonne); 
  } else {
    printf("\033[32m[SUCCESS] Nombre valide: %s\033[0m\n", yytext);
  }
  nb_colonne += strlen(yytext); 
}

{SIGNEDNUM} { 
  int val = atoi(yytext); 
  if (val < -32768 || val > 32767) {
    printf("\033[31m[ERROR] Nombre signe hors plage (%s) à la ligne %d, colonne %d\033[0m\n", yytext, nb_ligne, nb_colonne); 
  } else {
    printf("\033[32m[SUCCESS] Nombre signe valide: %s\033[0m\n", yytext);
  }
  nb_colonne += strlen(yytext);
}

{REAL} { 
  double val = atof(yytext); 
  if (val < 0.0 || val > 32767.0) {
    printf("\033[31m[ERROR] Reel hors plage (%s) à la ligne %d, colonne %d\033[0m\n", yytext, nb_ligne, nb_colonne); 
  } else {
    printf("\033[32m[SUCCESS] Reel valide: %s\033[0m\n", yytext); 
  }
  nb_colonne += strlen(yytext); 
}

{SIGNEDREAL} { 
  double val = atof(yytext); 
  if (val < -32768.0 || val > 32767.0) {
    printf("\033[31m[ERROR] Reel signe hors plage (%s)  a la ligne %d, colonne %d\033[0m\n", yytext, nb_ligne, nb_colonne); 
  } else {
    printf("\033[32m[SUCCESS] Reel signe valide: %s\033[0m\n", yytext); 
  }
  nb_colonne += strlen(yytext); 
}




\n { 
  nb_ligne++; 
  nb_colonne = 1; 
}

[ \t]+ { 
  nb_colonne += yyleng; 
}
%%

int main(int argc, char **argv) {
  printf("Analyse lexicale en cours...\n");
  yylex();
  printf("Analyse terminee.\n");
  return 0;
}

int yywrap(void) {
  return 1;
}


