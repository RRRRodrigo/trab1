
%{
#include <stdlib.h>
void yyerror(char *);

#include "y.tab.h"
%}


%%

[0-9]+  {
          yylval = atoi(yytext);
          return INT;
        }

[+]     {
          return SOMA;
        }

[*]		{
			return MULT;
		}

\n   	{
         return EOL;
       	}

[(]		{
		return PAR_E;
		} 

[)]		{
		return PAR_D;
		} 

[ \t]+ ;

.     {yyerror("Token nao reconhecido!\n");}

%%

int yywrap() {
  return 1;
}
