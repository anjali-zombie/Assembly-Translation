#include<stdio.h>
#include<stdlib.h>
#include<unistd.h>
#include<stdbool.h>
#include<string.h>

int reg_name(char* regreg);
int reg_addr(int i,unsigned char x,unsigned char y);
char* valsym(char* opcode,char* regreg);
typedef struct symbollist{
	int addr;
	char sec;
	char* name;
	char* value;
	struct symbollist *next;
}sll;
sll *createnode();
bool search(sll* head,char* name);
sll* insert(sll *head,int addr,char sec,char* name,char* value);
void display(sll* head);
int display_sym(sll* head,char* name);

