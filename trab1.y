%{
#include <stdio.h>

void yyerror(char *c);
int yylex(void);

%}

%token INT SOMA EOL MULT PAR_E PAR_D
%left SOMA 
%left MULT
%left PAR_E

%%

PROGRAMA:
        PROGRAMA EXPRESSAO EOL { printf("Resultado: %d\n", $2); }
        |
        ;



EXPRESSAO:
    INT { $$ = $1;
          }

    | EXPRESSAO SOMA PAR_E EXPRESSAO PAR_D {
      printf("encontrei exp + (exp): %d \n", $1);
    } 

    | PAR_E EXPRESSAO PAR_D  SOMA EXPRESSAO {
      printf("encontrei (exp) + exp: %d \n", $1);
    } 

    | EXPRESSAO SOMA EXPRESSAO  {
        printf("Encontrei soma: %d + %d = %d\n", $1, $3, $1+$3);
        $$ = $1 + $3;
        }

    | EXPRESSAO MULT EXPRESSAO {
      printf("Encontrei a multiplicacao: %d * %d = %d\n", $1, $3, $1*$3);
       $$ = $1 * $3;
    }

    | PAR_E EXPRESSAO PAR_D {
      printf("Encontrei a expressao entre parenteses:(%d)\n", $2);
       $$ = $2;
    }              
    ;

%%

void yyerror(char *s) {
    fprintf(stderr, "%s\n", s);
}

int main() {
  yyparse();
  return 0;

}
