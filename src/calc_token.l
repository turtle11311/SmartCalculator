%{
#include <cstdio>
#include "calc_parser.hpp"
%}

%option yylineno

%%
\n                                  return NL;
[[:blank:]]+                        ;
[[:digit:]]*("."[[:digit:]]+)?      { sscanf(yytext, "%lf", &yylval.varValue); return NUMBER; }
[[:alpha:]_][[:alnum:]_]*           { sscanf(yytext, "%s", yylval.identifier); return IDENTIFIER; }
"++"                                return INCREMENT;
"--"                                return DECREMENT;
.                                   return *yytext;
%%
