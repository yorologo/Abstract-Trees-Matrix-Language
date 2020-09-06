%{
    
//  win_flex -o scanner.cpp scanner.l

#include <stdio.h>
#include <string.h>
#include "matrix.h"
#include "node.h"
#include "parser.hpp"

int line_count = 1;
extern "C" int yywrap();

%}

trow        throw
id          _*[a-zA-Z]+([a-zA-Z]|[0-9]|_)*\'?
number      [0-9]+\.?[0-9]*
operat      [-\+\*/]
delim       [()\[\]]
puntua      [\.,;:]
white       [ \t]
newLine     \n

%%

{white}     ; // ignore all whitespace
{newLine}   line_count++;
{operat}    return *yytext;
{delim}     return *yytext;
{puntua}    return *yytext;
{trow}      return THROW;
{id}        {
                yylval.str_id = strdup(yytext);
			    return ID;
            }
{number}    {
                yylval.val = atof(yytext);
			    return NUM;
            }

.           {
                printf("Error [%i]: %c\n", line_count, *yytext);
                return -1;
            }
<<EOF>>     break;

%%

int yywrap() { return 1; }
