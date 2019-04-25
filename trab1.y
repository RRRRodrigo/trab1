%{
#include <stdio.h>

void yyerror(char *c);
int yylex(void);

int flagMUL=0;

%}

%token INT SOMA SUB EOL MULT PAR_E PAR_D
%left SOMA 
%left MULT
%left PAR_E

%%

PROGRAMA:
        PROGRAMA EXPRESSAO EOL { printf("\nLDMIA  sp!, {r0}\n");
                                if(flagMUL == 1){         // se houve alguma multiplicacao no codigo
                                   printf("\nb exit");    // pula para o final do programa para
                                                          // nao executar essa parte ao final do codigo
                            
                                   printf("\nmul");
                                   printf("\n   ADD r0, r0, r3");    // r0 <- r0 + r3
                                   printf("\n   ADD r2, r2, #1");    // r2++;
                                   printf("\n   CMP r2, r1");        
                                   printf("\n   BLT mul");           // se cnt < [r1], volta pra mul
                                   printf("\n   STMDB sp!, {r0}");    // empilha o resultado
                                   printf("\n   MOV pc, lr");        // retorna para o codigo                                   

                                   printf("\nexit");
                                 }
                              }
        |
        ;

EXPRESSAO:
    INT { //$$ = $1;
          printf("\nMOV r0, #%d", $1);
          printf("\nSTMDB sp!, {r0}");        
          }

    | EXPRESSAO SOMA EXPRESSAO  {
    
        printf("\nLDMIA  sp!, {r0}");   // desempilha em r0
        printf("\nLDMIA  sp!, {r1}");   // desempilha em r1
        printf("\nADD r0, r0, r1");     // r0 <- r0 + r1
        printf("\nSTMDB sp!, {r0}");    // empilha o resultado
   
        }

    | EXPRESSAO SUB EXPRESSAO  {
  
        printf("\nLDMIA  sp!, {r1}");   // desempilha em r1
        printf("\nLDMIA  sp!, {r0}");   // desempilha em r0
        printf("\nSUB r0, r0, r1");     // r0 <- r0 - r1
        printf("\nSTMDB sp!, {r0}");    // empilha o resultado

        }

    | EXPRESSAO MULT SUB EXPRESSAO {      //  identifica mutiplicaçao
        printf("\nLDMIA  sp!, {r1}");   // desempilha em r1
        printf("\nLDMIA  sp!, {r0}");   // desempilha em r0
        printf("\nMOV r2, #1");         // contador <- 1
        printf("\nRSBS r0, r0, #0");    // inverte o sinal de r0
        printf("\nMOV r3, r0");         // copia o valor de r0 em r3
        printf("\nBL mul");
        flagMUL = 1;
    }

    | EXPRESSAO MULT EXPRESSAO {      //  identifica mutiplicaçao
        printf("\nLDMIA  sp!, {r1}");   // desempilha em r1
        printf("\nLDMIA  sp!, {r0}");   // desempilha em r0
        printf("\nMOV r2, #1");         // contador <- 1
        printf("\nMOV r3, r0");         // copia o valor de r0 em r3
        printf("\nBL mul");
        flagMUL = 1;
    }

    | SUB INT {                 // identifica numeros negativos
        $$ = - $2;
        printf("\nMOV r0, #-%d", $2);
        printf("\nSTMDB sp!, {r0}");    
      }

    | PAR_E EXPRESSAO PAR_D {           // identifica valor entre parenteses
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
