%{
#include <string.h>
#include "y.tab.h"
%}

%%
eax|ebx|ecx|edx|esp|ebp|esi|edi	{ 
	yylval.string = strdup(yytext); 
	return reg; 
	}
ret {
	return op0;
	}
dword {
	return dword;
      }
	 
div|mul|jmp|jz|jnz|inc|dec {
	yylval.string = strdup(yytext);
	return op1;
	}
mov|add|sub|cmp|xor { 
	yylval.string = strdup(yytext); 
	return op2; 
	}
section	{
	yylval.string = strdup(yytext);
	return section;
}
db {
	return db;
	}
dd {
	return dd;
   }
dw {
	return dw;
   }
dq {
	return dq;
   }
resd {
	return resd;
     }
resb {
	return resb;
     }
resw {
	return resw;
     }
resq {
	return resq;
     }


\"[^\"]*\" {
	yylval.string = strdup(yytext);
	return str;
	}
[a-zA-Z][a-zA-Z0-9]* {
	yylval.string = strdup(yytext);
	return symbol;
	}
[0-9]+ {
	yylval.number = atoi(yytext);
	return val;
	}
.data|.bss|.text {
	yylval.string = strdup(yytext);
	return extension;
	}

\n return end;
"[" {
	return lbracket;
	}
"]" {
	return rbracket;
	}
[a-zA-Z_][a-zA-Z_0-9]+: {
	yylval.string = strdup(yytext);
	return label;
	}
[ \t\r]	{ /* ignore whitespaces */ }
	
";"[a-zA-Z]+ {
	yylval.string = strdup(yytext);
	return comment;
	}
","	{
	return comma;
	}
. ;

%%

