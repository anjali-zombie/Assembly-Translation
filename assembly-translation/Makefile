program: lex.yy.c y.tab.c
	gcc lex.yy.c y.tab.c -ll
lex.yy.c: systemlex.l
	lex systemlex.l
y.tab.c: systemyacc.y
	yacc -d systemyacc.y
