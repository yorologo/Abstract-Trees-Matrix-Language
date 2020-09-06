#include <cstdio>
#include "node.h"

extern FILE *yyin;
extern int yyparse();

int main(){
    yyin = fopen("test.txt", "r");

	do {
        yyparse();
	} while(!feof(yyin));

    fclose(yyin);

    return 0;
}
