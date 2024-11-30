%{
#include "y.tab.h" // Inclure les definitions des tokens
%}

%%

DEBUT      { return DEBUT; }
FIN        { return FIN; }
EXECUTION  { return EXECUTION; }
SI         { return SI; }
ALORS      { return ALORS; }
SINON      { return SINON; }
TANTQUE    { return TANTQUE; }
FAIRE      { return FAIRE; }
FIXE       { return FIXE; }
NUM        { return NUM; }
REAL       { return REAL; }
TEXT       { return TEXT; }

[A-Za-z][A-Za-z0-9_]{0,9}   { return IDENTIFIANT; }

\+         { return PLUS; }
\-         { return MOINS; }
\*         { return MULT; }
\/         { return DIV; }

ET         { return ET; }
OU         { return OU; }
NON        { return NON; }
=          { return EGAL; }
!=         { return DIFF; }
<          { return INF; }
<=         { return INFEGAL; }
>          { return SUP; }
>=         { return SUPEGAL; }

[0-9]+     { return LITTERAL_NUM; }
[0-9]*\.[0-9]+ { return LITTERAL_REAL; }
\"[^\"]*\"  { return LITTERAL_TEXT; }

:          { return DEUX_POINTS; }
;          { return POINT_VIRGULE; }
=          { return EGAL; }
\->        { return ARROW; }
\(         { return PARENTHESIS_O; }
\)         { return PARENTHESIS_F; }
\{         { return ACCOLADE_O; }
\}         { return ACCOLADE_F; }
--         { return COMMENTAIRE_LIGNE; }
##         { return COMMENTAIRE_FIN; }
\{-        { return COMMENTAIRE_ML_DEB; }
-\}        { return COMMENTAIRE_ML_FIN; }

[ \t\n]+   { /* ignore whitespaces */ }

%%

int yywrap() {
    return 1;
}
