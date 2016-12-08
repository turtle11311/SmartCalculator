%{
#include <cstdio>
#include "calc_parser.hpp"
%}

%option yylineno

%%
\n                                  return NL;
[[:blank:]]+                        ;
"++"                                return INC;
"--"                                return DEC;
[[:digit:]]*("."[[:digit:]]+)?      { sscanf(yytext, "%lf", &yylval.varValue); return NUMBER; }
[[:alpha:]_][[:alnum:]_]*           { sscanf(yytext, "%s", yylval.identifier); return IDENTIFIER; }
.                                   return *yytext;
%%
