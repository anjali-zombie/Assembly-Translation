%{
#include"y.tab.h"
#include<stdio.h>
#include<string.h>
#include"symboltable.h"
sll* head = NULL;
int yylex();
int yywrap();
void yyerror(char *ch);
int offset =0;
int bytes_count =0;
int temp_bytes_count = 0;
int str_size = 0;
int flag;
char buffer[2141];
unsigned char x =0;
%}
%union yylval{
	unsigned char* string;
	int number;
}
%type<string> init
%token<string> dword resq resw resd resb str db dd dq dw section extension op2 op1 op0 reg symbol lbracket rbracket label comment comma 
%token<number> val
%token end
%start s
%%
s:op2 reg comma reg 
 {
	printf("\n%08X",offset);	
     	if(strcmp($1,"mov") == 0){
		unsigned char first_reg = reg_name($2);
		unsigned char second_reg = reg_name($4);		
		printf("  89%02X\n",reg_addr(1,first_reg,second_reg));
		offset +=2;
	}
       	else if(strcmp($1,"add") == 0){	
		unsigned char first_reg = reg_name($2);
		unsigned char second_reg = reg_name($4);		
		printf("  01%02X\n",reg_addr(1,first_reg,second_reg));

		offset +=2;

	}
       	else if(strcmp($1,"sub") == 0){	
		unsigned char first_reg = reg_name($2);
		unsigned char second_reg = reg_name($4);		
		printf("  29%02X\n",reg_addr(1,first_reg,second_reg));
		offset +=2;

     	}
	else if(strcmp($1,"cmp") == 0){	
		unsigned char first_reg = reg_name($2);
		unsigned char second_reg = reg_name($4);		
		printf("  39%02X\n",reg_addr(1,first_reg,second_reg));
		offset +=2;
	}	
	else if(strcmp($1,"xor") == 0){		
		unsigned char first_reg = reg_name($2);
		unsigned char second_reg = reg_name($4);		
		printf("  31%02X\n",reg_addr(1,first_reg,second_reg));
		offset +=2;
	}
 }
 |op2 dword lbracket symbol rbracket comma reg
 {
	printf("\n%08X",offset);
        if(strcmp($1,"mov") == 0){
		unsigned char x = reg_name($7);
		x = x<<3;
		x |= 5;
		printf("  89%02X[%08X]",x,display_sym(head,$4));		
		offset +=6;
	}
        if(strcmp($1,"sub") == 0){
		unsigned char x = reg_name($7);
		x = x<<3;
		x |= 5;
		printf("  29%02X[%08X]",x,display_sym(head,$4));		
		offset +=6;
	}
        if(strcmp($1,"add") == 0){
		unsigned char x = reg_name($7);
		x = x<<3;
		x |= 5;
		printf("  01%02X[%08X]",x,display_sym(head,$4));		
		offset +=6;
	}
        if(strcmp($1,"cmp") == 0){
		unsigned char x = reg_name($7);
		x = x<<3;
		x |= 5;
		printf("  39%02X[%08X]",x,display_sym(head,$4));		
		offset +=6;
	}
        if(strcmp($1,"xor") == 0){
		unsigned char x = reg_name($7);
		x = x<<3;
		x |= 5;
		printf("  31%02X[%08X]",x,display_sym(head,$4));		
		offset +=6;
	}
 }

 |op2 reg comma dword lbracket symbol rbracket
 {
	printf("\n%08X",offset);
        if(strcmp($1,"mov") == 0){
		unsigned char x = reg_name($2);
		x = x<<3;
		x |= 5;
		printf("  8B%02X[%08X]",x,display_sym(head,$6));		
		offset +=6;
	}
        if(strcmp($1,"sub") == 0){
		unsigned char x = reg_name($2);
		x = x<<3;
		x |= 5;
		printf("  2B%02X[%08X]",x,display_sym(head,$6));		
		offset +=6;
	}
        if(strcmp($1,"add") == 0){
		unsigned char x = reg_name($2);
		x = x<<3;
		x |= 5;
		printf("  03%02X[%08X]",x,display_sym(head,$6));		
		offset +=6;
	}
        if(strcmp($1,"cmp") == 0){
		unsigned char x = reg_name($2);
		x = x<<3;
		x |= 5;
		printf("  3B%02X[%08X]",x,display_sym(head,$6));		
		offset +=6;
	}
        if(strcmp($1,"xor") == 0){
		unsigned char x = reg_name($2);
		x = x<<3;
		x |= 5;
		printf("  33%02X[%08X]",x,display_sym(head,$6));		
		offset +=6;
	}
 }
 |op2 reg comma dword lbracket reg rbracket
 {
	printf("\n%08X",offset);
        if(strcmp($1,"mov") == 0){
        //        printf("8B /r\n");
		int y =1;
		unsigned char x = y;
		x = x<<3;
		x |= reg_name($6);
		printf("  8B%02X",x);		
		offset += 2;
	}
        else if(strcmp($1,"add") == 0){
       //         printf("03 /r\n");
		int y = 1;
		unsigned char x = y;
		x = x<<3;
		x |= reg_name($6);
		printf("  03%02X",x);
		offset += 2;
        }
	else if(strcmp($1,"sub") == 0){
       //         printf("2B /r\n");
		int y = 1;
		unsigned char x = y;
		x = x<<3;
		x |= reg_name($6);
		printf("  2B%02X",x);
		offset += 2;
        }
	else if(strcmp($1,"cmp") == 0){
      //          printf("3B /r\n");	
		int y = 1;
		unsigned char x = y;
		x = x<<3;
		x |= reg_name($6);
		printf("  3B%02X",x);
		offset += 2;
        }else if(strcmp($1,"xor") == 0){
        //        printf("33 /r\n"); 		
		int y = 1;
		unsigned char x = y;
		x = x<<3;
		x |= reg_name($6);
		printf("  33%02X",x);
		offset += 2;
 	} 
 }
 |op2 reg comma val
 {
	printf("\n%08X",offset);
	if($4 < 256)
	{
       		 if(strcmp($1,"mov") == 0){
             	 //  printf("B8+ rd id\n");
			int y = 23;
			unsigned char x = y;
			x = x<<3;
			x |= reg_name($2); 
			printf("  %02X%08X\n",x,$4);
			offset += 5;
		}
       		else if(strcmp($1,"add") == 0){
            	  //  printf("81 /0 id\n");
			int y = 12;
			unsigned char x = y;
			x = x<<4;
			x |= reg_name($2);
			printf("  83%02X%08X\n",x,$4);
			offset += 3;
       		}
		else if(strcmp($1,"sub") == 0){
        	  //      printf("81 /5 id\n");
			int y = 29;
			unsigned char x = y;
			x = x<<3;
			x |= reg_name($2);
			printf("  83%02X%08X\n",x,$4);
			offset += 3;
       		}
		else if(strcmp($1,"cmp") == 0){
        	  //      printf("81 /6 id\n");
			int y = 31;
			unsigned char x = y;
			x = x<<3;
			x |= reg_name($2);
			printf("  83%02X%08X\n",x,$4);
			offset += 3;
       		}
		else if(strcmp($1,"xor") == 0){
        	  //      printf("81 /6 id\n"); 
			int y = 15;
			unsigned char x = y;
			x = x<<3;
			x |= reg_name($2);
			printf("  83%02X%08X\n",x,$4);
			offset += 3;
 		}
	}
	else{
		if(strcmp($1,"mov") == 0){
             	 //  printf("B8+ rd id\n");
			int y = 23;
			unsigned char x = y;
			x = x<<3;
			x |= reg_name($2); 
			printf("  %02X%08X\n",x,$4);
			offset += 5;
		}
       		else if(strcmp($1,"add") == 0){
            	  //  printf("81 /0 id\n");
			int y = 12;
			unsigned char x = y;
			x = x<<4;
			x |= reg_name($2);
			printf("  81%02X%08X\n",x,$4);
			offset += 6;
       		}
		else if(strcmp($1,"sub") == 0){
        	  //      printf("81 /5 id\n");
			int y = 29;
			unsigned char x = y;
			x = x<<3;
			x |= reg_name($2);
			printf("  81%02X%08X\n",x,$4);
			offset += 6;
       		}
		else if(strcmp($1,"cmp") == 0){
        	  //      printf("81 /6 id\n");
			int y = 31;
			unsigned char x = y;
			x = x<<3;
			x |= reg_name($2);
			printf("  81%02X%08X\n",x,$4);
			offset += 6;
       		}
		else if(strcmp($1,"xor") == 0){
        	  //      printf("81 /6 id\n"); 
			int y = 15;
			unsigned char x = y;
			x = x<<3;
			x |= reg_name($2);
			printf("  81%02X%08X\n",x,$4);
			offset += 6;
 		}
	}

 }
 |op2 reg comma symbol
 {
	printf("\n%08X",offset);
        if(strcmp($1,"mov") == 0){
              //  printf("B8+ rd id\n");
		int y = 23;
		unsigned char x = y;
		x = x<<3;
		x |= reg_name($2);
		printf("  %02X[%08X]",x,display_sym(head,$4));
		offset += 5;
	}
        else if(strcmp($1,"add") == 0){
		int y = 12;
		unsigned char x = y;
		x = x<<4; 
		x  |= reg_name($2); 
      //  printf("81 /0 id\n");
		printf("  81%02X[%08X]",x,display_sym(head,$4));
		offset += 6;
        }
	else if(strcmp($1,"sub") == 0){
          //      printf("81 /5 id\n");	
		int y = 29;
		unsigned char x = y;
		x = x<<3;
		x |= reg_name($2);
		printf("  81%02X[%08X]",x,display_sym(head,$4));		
		offset += 6;
        }
	else if(strcmp($1,"cmp") == 0){
          //      printf("81 /6 id\n");	
		int y = 31;
		unsigned char x = y;
		x = x<<3;
		x |= reg_name($2);
		printf("  81%02X[%08X]",x,display_sym(head,$4));
		offset += 6;
        }
	else if(strcmp($1,"xor") == 0){
          //      printf("81 /6 id\n"); 	
		int y = 15;
		unsigned char x = y;
		x = x<<4;
		x |= reg_name($2);
		printf("  81%02X[%08X]\n",x,display_sym(head,$4));
		offset += 6;
 	}
 }
 |op2 dword lbracket reg rbracket comma reg
 { 
	printf("\n%08X",offset);
        if(strcmp($1,"mov") == 0){
        	int y =3;
		unsigned char x = y;
		x = x<<3;
		x |= reg_name($4);
		printf("  89%02X",x);		
	//	printf("89 /r\n");
		offset += 2;
	} 
        else if(strcmp($1,"add") == 0){
          //    printf("01 /r\n");
		int y =3;
		unsigned char x = y;
		x = x<<3;
		x |= reg_name($4);
		printf("  01%02X",x);		
		offset += 2;
	}
        else if(strcmp($1,"sub") == 0){
       //         printf("29 /r\n");
		int y =3;
		unsigned char x = y;
		x = x<<3;
		x |= reg_name($4);
		printf("  29%02X",x);		
		offset += 2;
        }
	else if(strcmp($1,"cmp") == 0){
         //       printf("39 /r\n");
		int y =3;
		unsigned char x = y;
		x = x<<3;
		x |= reg_name($4);
		printf("  39%02X",x);		
		offset += 2;
        }
	else if(strcmp($1,"xor") == 0){
           //     printf("31 /r\n");
 		int y =3;
		unsigned char x = y;
		x = x<<3;
		x |= reg_name($4);
		printf("  31%02X",x);		
		offset += 2;	
	}
 }
 |op2 dword lbracket symbol rbracket comma val
 {
	printf("\n%08X",offset);
	if($7 < 256)
	{
		if(strcmp($1,"mov") == 0){
        	    // 	printf("89 /r\n");
			int y = 5;
			unsigned char x = y;
			printf("  C7%02X[%08X]-%08X",x,display_sym(head,$4),$7);
               		offset += 10;
       		 }
       		 else if(strcmp($1,"add") == 0){
         	  //     printf("01 /r\n");
			int y = 5;
			unsigned char x = y;
			printf("  83%02X[%08X]-%08X",x,display_sym(head,$4),$7);
	
              		offset += 7;
       		 }
       		 else if(strcmp($1,"sub") == 0){
       		 //        printf("29 /r\n");
			int y = 5;
			unsigned char x = y;
			x = x<<3;
			x |= 5;
			printf("  83%02X[%08X]-%08X",x,display_sym(head,$4),$7);
		
       		        offset += 7;
       		 }
       		 else if(strcmp($1,"cmp") == 0){
       			int y = 7;
			unsigned char x = y;
			x = x<<3;
			x |= 5;
			printf("  83%02X[%08X]-%08X",x,display_sym(head,$4),$7);
    		  //  printf("39 /r\n");
               		offset += 7;
       		 }
      		 else if(strcmp($1,"xor") == 0){
	//                printf("31 /r\n");
      			int y = 3;
			unsigned char x = y;
			x = x<<4;
			x |= 5;
			printf("  83%02X[%08X]-%08X",x,display_sym(head,$4),$7);

                	offset += 7;   
		 }
	}
	else
	{
		if(strcmp($1,"mov") == 0){
        	    // 	printf("89 /r\n");
			int y = 5;
			unsigned char x = y;
			printf("  C7%02X[%08X]-%08X",x,display_sym(head,$4),$7);
               		offset += 10;
       		 }
       		 else if(strcmp($1,"add") == 0){
         	  //     printf("01 /r\n");
			int y = 5;
			unsigned char x = y;
			printf("  81%02X[%08X]-%08X",x,display_sym(head,$4),$7);
	
              		offset += 10;
       		 }
       		 else if(strcmp($1,"sub") == 0){
       		 //        printf("29 /r\n");
			int y = 5;
			unsigned char x = y;
			x = x<<3;
			x |= 5;
			printf("  81%02X[%08X]-%08X",x,display_sym(head,$4),$7);
		
       		        offset += 10;
       		 }
       		 else if(strcmp($1,"cmp") == 0){
       			int y = 7;
			unsigned char x = y;
			x = x<<3;
			x |= 5;
			printf("  81%02X[%08X]-%08X",x,display_sym(head,$4),$7);
    		  //  printf("39 /r\n");
               		offset += 10;
       		 }
      		 else if(strcmp($1,"xor") == 0){
	//                printf("31 /r\n");
      			int y = 3;
			unsigned char x = y;
			x = x<<4;
			x |= 5;
			printf("  81%02X[%08X]-%08X",x,display_sym(head,$4),$7);

                	offset += 10;   
		 }
	}

 }
 |op2 dword lbracket symbol rbracket comma symbol
 {
	printf("\n%08X",offset);
	if(strcmp($1,"mov") == 0){
            // 	printf("89 /r\n");
		int y = 5;
		unsigned char x = y;
		printf("  C7%02X[%08X]-[%08X]",x,display_sym(head,$4),display_sym(head,$7));
                offset += 10;
        }
        else if(strcmp($1,"add") == 0){
           //     printf("01 /r\n");
		int y = 5;
		unsigned char x = y;
		printf("  81%02X[%08X]-[%08X]",x,display_sym(head,$4),display_sym(head,$7));
	
                offset += 10;
        }
        else if(strcmp($1,"sub") == 0){
        //        printf("29 /r\n");
		int y = 5;
		unsigned char x = y;
		x = x<<3;
		x |= 5;
		printf("  81%02X[%08X]-[%08X]",x,display_sym(head,$4),display_sym(head,$7));
	
                offset += 10;
        }
        else if(strcmp($1,"cmp") == 0){
       		int y = 7;
		unsigned char x = y;
		x = x<<3;
		x |= 5;
		printf("  81%02X[%08X]-[%08X]",x,display_sym(head,$4),display_sym(head,$7));
      //  printf("39 /r\n");
                offset += 10;
        }
        else if(strcmp($1,"xor") == 0){
//                printf("31 /r\n");
      		int y = 3;
		unsigned char x = y;
		x = x<<4;
		x |= 5;
		printf("  81%02X[%08X]-[%08X]",x,display_sym(head,$4),display_sym(head,$7));

                offset += 10;   
	 }	

 } 
 |op2 dword lbracket reg rbracket comma val
 {
	printf("\n%08X",offset);
	if($7 < 256)
	{
		if(strcmp($1,"mov") == 0){
        	    // 	printf("89 /r\n");
			unsigned char x;
			x |= reg_name($4);
			printf("  C7%02X%08X",x,$7);
               		offset += 6;
       		 }
       		else if(strcmp($1,"add") == 0){
          	 //     printf("01 /r\n");
			unsigned char x;
			x |= reg_name($4);
			printf("  83%02X%08X",x,$7);
	
	                offset += 3;
       		 }
   		else if(strcmp($1,"sub") == 0){
      	  //        printf("29 /r\n");
			int y = 5;
			unsigned char x = y;
			x = x<<3;
			x |= reg_name($4);
			printf("  83%02X%08X",x,$7);
	
               		offset += 3;
       		 }
    		else if(strcmp($1,"cmp") == 0){
       			int y = 7;
			unsigned char x = y;
			x = x<<3;
			x |= reg_name($4);
			printf("  83%02X%08X",x,$7);
     		 //  printf("39 /r\n");
               		offset += 3;
       		 }
   		else if(strcmp($1,"xor") == 0){
	//                printf("31 /r\n");
      			int y = 3;
			unsigned char x = y;
			x = x<<4;
			x |= reg_name($4);
			printf("  83%02X%08X",x,$7);

          		offset += 3;   
		 }
	}
	else{
		if(strcmp($1,"mov") == 0){
        	    // 	printf("89 /r\n");
			unsigned char x;
			x |= reg_name($4);
			printf("  C7%02X%08X",x,$7);
               		offset += 6;
       		 }
       		else if(strcmp($1,"add") == 0){
          	 //     printf("01 /r\n");
			unsigned char x;
			x |= reg_name($4);
			printf("  81%02X%08X",x,$7);
	
	                offset += 6;
       		 }
   		else if(strcmp($1,"sub") == 0){
      	  //        printf("29 /r\n");
			int y = 5;
			unsigned char x = y;
			x = x<<3;
			x |= reg_name($4);
			printf("  81%02X%08X",x,$7);
	
               		offset += 6;
       		 }
    		else if(strcmp($1,"cmp") == 0){
       			int y = 7;
			unsigned char x = y;
			x = x<<3;
			x |= reg_name($4);
			printf("  81%02X%08X",x,$7);
     		 //  printf("39 /r\n");
               		offset += 6;
       		 }
   		else if(strcmp($1,"xor") == 0){
	//                printf("31 /r\n");
      			int y = 3;
			unsigned char x = y;
			x = x<<4;
			x |= reg_name($4);
			printf("  81%02X%08X",x,$7);

          		offset += 6;   
		 }
	}

 } 
 |op2 dword lbracket reg rbracket comma symbol
 {
	printf("\n%08X",offset);
	if(strcmp($1,"mov") == 0){
            // 	printf("89 /r\n");
		unsigned char x;
		x |= reg_name($4);
		printf("  C7%02X[%08X]",x,display_sym(head,$7));
                offset += 6;
        }
        else if(strcmp($1,"add") == 0){
           //     printf("01 /r\n");
		unsigned char x;
		x |= reg_name($4);
		printf("  81%02X[%08X]",x,display_sym(head,$7));
	
                offset += 6;
        }
        else if(strcmp($1,"sub") == 0){
        //        printf("29 /r\n");
		int y = 5;
		unsigned char x = y;
		x = x<<3;
		x |= reg_name($4);
		printf("  81%02X[%08X]",x,display_sym(head,$7));
	
                offset += 6;
        }
        else if(strcmp($1,"cmp") == 0){
       		int y = 7;
		unsigned char x = y;
		x = x<<3;
		x |= reg_name($4);
		printf("  81%02X[%08X]",x,display_sym(head,$7));
      //  printf("39 /r\n");
                offset += 6;
        }
        else if(strcmp($1,"xor") == 0){
//                printf("31 /r\n");
      		int y = 3;
		unsigned char x = y;
		x = x<<4;
		x |= reg_name($4);
		printf("  81%02X[%08X]",x,display_sym(head,$7));

                offset += 6;   
	 }	
 }
 |op1 dword lbracket symbol rbracket
 {
	printf("\n%08X",offset);
        if(strcmp($1,"inc") == 0){
		unsigned char x;
		x |= 5;
		printf("  FF%02X[%08X]",x,display_sym(head,$4));
		offset += 6;
        }
	else if(strcmp($1,"dec") == 0){
		unsigned char x;
		x |= 13;
		printf("  FF%02X[%08X]",x,display_sym(head,$4));
		offset += 6;
        }
	else if(strcmp($1,"div") == 0){
		int y = 3;
		unsigned char x = y;
		x = x<<4;
		x |= 5;
		printf("  F7%02X[%08X]",x,display_sym(head,$4));
		offset += 6;
        }
	else if(strcmp($1,"mul") == 0){
		int y = 2;
		unsigned char x = y;
		x = x<<4;
		x |= 5;
		printf("  F7%02X[%08X]",x,display_sym(head,$4));

		offset += 6;
        }
	else if(strcmp($1,"jmp") == 0){
		printf("  E9 cd");

		offset += 2;
	} 
 }
 |op1 dword lbracket reg rbracket
 {
	printf("\n%08X",offset);
        if(strcmp($1,"inc") == 0){
		unsigned char x;
		x |= reg_name($4);
		printf("  FF%02X",x);
		offset += 2;
        }
	else if(strcmp($1,"dec") == 0){
		int y =8;
		unsigned char x = y;
		x |= reg_name($4);
		printf("  FF%02X",x);
		offset += 2;
        }
	else if(strcmp($1,"div") == 0){
		int y = 3;
		unsigned char x = y;
		x = x<<4;
		x |= reg_name($4);
		printf("  F7%02X",x);
		offset += 2;
        }
	else if(strcmp($1,"mul") == 0){
		int y = 2;
		unsigned char x = y;
		x = x<<4;
		x |= reg_name($4);
		printf("  F7%02X",x);

		offset += 2;
        }
	else if(strcmp($1,"jmp") == 0){
		printf("  FF",x);

		offset += 2;
	}
 } 
 |op1 reg
 {
	printf("\n%08X",offset);
        if(strcmp($1,"inc") == 0){
		int y = 40 + reg_name($2);
		printf("  %d\n",y);
		offset += 1;
        }
	else if(strcmp($1,"dec") == 0){	
		int y = 48 + reg_name($2);
		printf("  %d\n",y);
		offset += 1;
        }
	else if(strcmp($1,"div") == 0){	
		int y = 15;
		unsigned char x = y;
		x = x<<4;
		x |= reg_name($2);
		printf("  F7%02X\n",x);
		offset += 2;
        }
	else if(strcmp($1,"mul") == 0){	
		int y = 14;
		unsigned char x = y;
		x = x<<4;
		x |= reg_name($2);
		printf("  F7%02X\n",x);
		offset += 2;
        }	
	else if(strcmp($1,"jmp") == 0){
		printf("  FF");
		offset += 2;
	}
 }
 |op0
 {
	printf("END\n");
 }
 |section extension
 {
	printf("\n %s %s\n",$1,$2);
	bytes_count = 0;
	printf("\n %08X ",bytes_count);
	
 } 
 |symbol dd{flag = 1;
	    for(int i=0;i<strlen(buffer);i++)
	    {
	    	buffer[i]=0;
	    }
	    temp_bytes_count = bytes_count;} init 	
 {	
		head=insert(head,temp_bytes_count,'d',$1,strdup(buffer));
		printf("\n %08X ",bytes_count);			
 }
 |symbol db{flag = 0;
	    for(int i=0;i<strlen(buffer);i++)
	    {
	    	buffer[i]=0;
	    }
	    temp_bytes_count = bytes_count;} init
 {
	
	head=insert(head,temp_bytes_count,'d',$1,strdup(buffer));
	printf("\n %08X ",bytes_count);
 }
 |symbol dw{flag = 2;
	    for(int i=0;i<strlen(buffer);i++)
	    {
	    	buffer[i]=0;
	    }
	    temp_bytes_count = bytes_count;} init
 {
	head=insert(head,temp_bytes_count,'d',$1,strdup(buffer));
	printf("\n %08X ",bytes_count);
 }
 |symbol dq{flag = 3;
	    for(int i=0;i<strlen(buffer);i++)
	    {
	    	buffer[i]=0;
	    }
	    temp_bytes_count = bytes_count;} init
 {
	head=insert(head,temp_bytes_count,'d',$1,strdup(buffer));
	printf("\n %08X ",bytes_count);
 }	
 |symbol resd val
 {
		 sprintf(buffer,"%d",$3);
	         head=insert(head,bytes_count,'b',$1,strdup(buffer));
		 printf("<res %xh>\n",4*$3);
		 bytes_count += 4*$3;
		 printf(" %08X ",bytes_count);
 }
 |symbol resb val
 {
		 sprintf(buffer,"%d",$3);
		 head=insert(head,bytes_count,'b',$1,strdup(buffer));
		 printf("<res %xh>\n",1*$3);
		 bytes_count += 1*$3;
		 printf(" %08X ",bytes_count);
 }
 |symbol resw val
 {		
		 sprintf(buffer,"%d",$3);
		 head=insert(head,bytes_count,'b',$1,strdup(buffer));
		 printf("<res %xh>\n",2*$3);
		 bytes_count +=2*$3;
		 printf(" %08X ",bytes_count);
 }
 |symbol resq val
 {		
		 sprintf(buffer,"%d",$3);
		 head=insert(head,bytes_count,'b',$1,strdup(buffer));
		 printf("<res %xh>\n",8*$3);
		 bytes_count += 8*$3;
		 printf(" %08X ",bytes_count);
 }
 |
 ;
init:init comma val
    {
	if(flag == 1)
	{
		bytes_count +=4;
	}
	else if(flag == 2)
	{
		bytes_count +=2;
	}
	else if(flag == 3)
	{
		bytes_count +=8;
	}
	else if(flag == 0)
	{	
		bytes_count += 1;
	}
	printf(" %08X ",$3);
	sprintf(buffer,"%s%02X",buffer,$3);
	$$ = $3;

    }
    |init comma str
    {
	if(flag == 1)
	{
		bytes_count +=4;
	}
	else if(flag == 2)
	{
		bytes_count +=2;
	}
	else if(flag == 3)
	{
		bytes_count +=8;
	}
	else if (flag == 0)
	{

		for(int i=1;i<strlen($3)-1;i++) 
		{
        		bytes_count += 1;	
		}
	}
	for(int i=1;i<strlen($3)-1;i++)
	{		
		printf(" %02X ",$3[i]);
		sprintf(buffer,"%s%02X",buffer,$3[i]);
	}
	$$ = $3;

    }
    |val
    {
	if(flag == 1)
	{
		bytes_count +=4;
	}
	else if(flag == 2)
	{
		bytes_count +=2;
	}
	else if(flag == 3)
	{
		bytes_count +=8;
	}
	else if(flag == 0)
	{	
		bytes_count += 1;
	}
	printf(" %08X ",$1);
        sprintf(buffer,"%s%02X",buffer,$1);
	$$ = $1;

    }
    |str
    {
	if(flag == 1)
	{
		bytes_count +=4;
	}
	else if(flag == 2)
	{
		bytes_count +=2;
	}
	else if(flag == 3)
	{
		bytes_count +=8;
	}
	else if(flag == 0)
	{
		for(int i=1;i<strlen($1)-1;i++)
		{
			bytes_count +=1;
		}
	}
	for(int i=1;i<strlen($1)-1;i++)
	{
		printf(" %02X",$1[i]);
        	sprintf(buffer,"%s%02X",buffer,$1[i]);
	}
	$$ = $1;

    }
    ;
%%
void yyerror(char *ch){
	yyparse();
}
int yywrap(){
	return 1;
}	
int reg_name(char* regreg){
	if(strcmp(regreg,"eax") == 0)
	{
		return 0;
	}
	if(strcmp(regreg,"ecx") == 0)
	{
		return 1;
	}
	if(strcmp(regreg,"edx") == 0)
	{
		return 2;
	}
	if(strcmp(regreg,"ebx") == 0)
	{
		return 3;
	}
	if(strcmp(regreg,"esp") == 0)
	{
		return 4;
	}
	if(strcmp(regreg,"ebp") == 0)
	{
		return 5;
	}
	if(strcmp(regreg,"esi") == 0)
	{
		return 6;
	}
	if(strcmp(regreg,"edi") == 0)
	{
		return 7;
	}
}
int reg_addr(int i,unsigned char x,unsigned char y)  // char x = reg_name(regreg);
{

	if(i == 1)
	{
		y |= 1<<3;
		y |= 1<<4;
		y = y<<3;
		y |= x;
		return y;
	}
	else
	{
		y = y<<3;
		y |=x;
		return y;
	}		
}
sll *createnode(){
	sll* node = (sll *)malloc(sizeof(sll));
	node->next = NULL;
	return node;
}
bool search(sll* head,char* name)
{
	if(!head)
	{
		return false;
	}
	else
	{
		sll* temp = head;
		while(temp != NULL)
		{
			if(strcmp(temp->name, name) ==0)
			{
				return true;
			}
			else
			{
				temp = temp->next;
			}
		}
		return false;
	}
}
sll* insert(sll *head,int addr,char sec,char* name,char* value)
{	
	bool s = search(head,name);
	if(!s)
	{
		if(!head)
		{
			head = createnode();
			head->addr = addr;
			head->sec = sec;
			head->name = name;
			head->value = value;
			return head;
		}
		else
		{
			sll* temp = head;
			while(temp->next != NULL)
			{
				temp = temp->next;
			}
			sll *node = createnode();
			node->addr = addr;
			node->sec = sec;
			node->name = name;
			node->value = value;
			temp->next = node;
			return head;
		}
	}
	else	
	{
		printf("lable already defined or used!!!!!!!!!!!!!!!!!!\n");
		return head;
	}

}
void display(sll *head)
{
	if(!head)
	{
		return;
	}
	else
	{
		sll* temp = head;
		while(temp)
		{
			printf("%08X |  %c      | %s    | %s\n",temp->addr,temp->sec,temp->name,temp->value);
			temp = temp->next;
		}
		printf("end");
	}
}
int display_sym(sll *head,char* name)
{
	if(!head)
	{
		return;
	}
	else
	{
		sll* temp = head;
		while(temp)
		{
			if(strcmp(name,temp->name) == 0)
			{	
				return temp->addr;
				break;
			}
			else
			{
				temp = temp->next;
			}
		}
	}
}
int main(){
	yyparse();
	printf("\n------------SYMBOL TABLE-------------\n");
	printf(" address | section | name | value\n"); 
	display(head);
} 	
