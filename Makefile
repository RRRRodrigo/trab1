

all: lex.yy.c y.tab.c
	gcc -omain lex.yy.c y.tab.c -ll

lex.yy.c:trab1.l y.tab.c
	flex trab1.l

y.tab.c:trab1.y
	bison -dy trab1.y

clean:
	rm y.tab.c lex.yy.c y.tab.h main
