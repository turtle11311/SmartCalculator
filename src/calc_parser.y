%{
#include <cstdio>
#include <cstring>
#include <cmath>
#include <map>

std::map<std::string, double> variableTable;
extern int yylex(void);
extern int yylineno;
extern char* yytext;
int yyerror(const char* errmsg) {
    fprintf(stderr, "Line %d: %s with token \"%s\"\n", yylineno, errmsg, yytext);
    return 1;
}
%}

%union {
    char identifier[100];
    double varValue;
}

%left '+' '-'
%left '*' '/'
%left '^'
%right UMINUS

%token NL INC DEC
%token <varValue> NUMBER
%token <identifier> IDENTIFIER

%type <varValue> statement expression

%%

interpretor         : interpretor oneline
                    | oneline
                    ;

oneline             : /* Empty line */
                    | statement NL { printf("%.6lf\n", $1); }
                    ;

statement           : IDENTIFIER '=' expression { variableTable[$1] = $3; $$ = $3; }
                    | expression { $$ = $1; }
                    ;

expression          : NUMBER { $$ = $1; }
                    | IDENTIFIER
                    {
                        try {
                            $$ = variableTable.at($1);
                        } catch (std::out_of_range &exct) {
                            printf("Line %d: %s is undefined\n", yylineno, $1);
                            exit(EXIT_FAILURE);
                        }
                    }
                    | INC IDENTIFIER
                    {
                        try {
                            $$ = ++variableTable.at($2);
                        } catch (std::out_of_range &exct) {
                            printf("Line %d: %s is undefined\n", yylineno, $2);
                            exit(EXIT_FAILURE);
                        }
                    }
                    | IDENTIFIER INC
                    {
                        try {
                            $$ = variableTable.at($1)++;
                        } catch (std::out_of_range &exct) {
                            printf("Line %d: %s is undefined\n", yylineno, $1);
                            exit(EXIT_FAILURE);
                        }
                    }
                    | DEC IDENTIFIER
                    {
                        try {
                            $$ = --variableTable.at($2);
                        } catch (std::out_of_range &exct) {
                            printf("Line %d: %s is undefined\n", yylineno, $2);
                            exit(EXIT_FAILURE);
                        }

                    }
                    | IDENTIFIER DEC
                    {
                        try {
                            $$ = variableTable.at($1)--;
                        } catch (std::out_of_range &exct) {
                            printf("Line %d: %s is undefined\n", yylineno, $1);
                            exit(EXIT_FAILURE);
                        }

                    }
                    | IDENTIFIER '(' expression ')'
                    {
                        if (!strcmp("sin", $1)) $$ = sin($3);
                        else if (!strcmp("cos", $1)) $$ = cos($3);
                        else if (!strcmp("log", $1)) $$ = log10($3);
                        else if (!strcmp("abs", $1)) $$ = abs($3);
                        else if (!strcmp("neg", $1)) $$ = -$3;
                    }
                    | '(' expression ')' { $$ = $2; }
                    | '-' expression %prec UMINUS { $$ = -$2; }
                    | expression '+' expression { $$ = $1 + $3; }
                    | expression '-' expression { $$ = $1 - $3; }
                    | expression '*' expression { $$ = $1 * $3; }
                    | expression '/' expression { $$ = $1 / $3; }
                    | expression '%' expression { $$ = $1 - floor($1 / $3) * $3; }
                    | expression '^' expression { $$ = pow($1, $3); }
                    ;
%%
int main () {
    yyparse();
}
