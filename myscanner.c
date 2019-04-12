#include <stdio.h>
#include "defs.h"
#include <string.h>
#include <stdlib.h>

extern int yylex(); // gets token id
extern int yylineno; // has token line number
extern char* yytext; // has token value

int main(void) 
{	
	FILE * fp = fopen ("out.txt","w");
	int token;
	token = yylex();
	while (token){
		switch(token){
			case INTVALUE:
			fprintf(fp,"int values: %s at line %d\n",yytext,yylineno);
			break;
			case FLOATVALUE:
			fprintf(fp,"Float values: %s at line %d\n",yytext,yylineno);
			break;
			case IDENTIFIER:
			fprintf(fp,"Identifier values: %s at line %d\n",yytext,yylineno);
			break;
			case STRINGVALUE:
			fprintf(fp,"String values: %s at line %d\n",yytext,yylineno);
			break;
			case CHARVALUE:
			fprintf(fp,"String values: %s at line %d\n",yytext,yylineno);
			break;
			case IF:
			fprintf(fp,"If values: %s at line %d\n",yytext,yylineno);
			break;
			case CONSTANT:
			fprintf(fp,"Constant values: %s at line %d\n",yytext,yylineno);
			break;
			case BOOLVALUE:
			fprintf(fp,"Boolean values: %s at line %d\n",yytext,yylineno);
			break;
		}
		token = yylex();
	}
	fclose (fp);
	printf("Done!\n");
	return 0;
}