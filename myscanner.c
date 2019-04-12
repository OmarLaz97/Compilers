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
			fprintf(fp,"Char values: %s at line %d\n",yytext,yylineno);
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
			case ERROR:
			fprintf(fp,"Error values: %s at line %d\n",yytext,yylineno);
			break;
			case AND:
			fprintf(fp,"And values: %s at line %d\n",yytext,yylineno);
			break;
			case SEMI_COLON:
			fprintf(fp,"Semi colon: %s at line %d\n",yytext,yylineno);
			break;
			case OPENED_BRACE:
			fprintf(fp,"Open brace: %s at line %d\n",yytext,yylineno);
			break;
			case OPENED_BRACKET:
			fprintf(fp,"open bracket: %s at line %d\n",yytext,yylineno);
			break;
			case CLOSED_BRACKET:
			fprintf(fp,"closed bracket: %s at line %d\n",yytext,yylineno);
			break;
			case CLOSED_BRACE:
			fprintf(fp,"closed brace: %s at line %d\n",yytext,yylineno);
			break;
			case OPENED_SQ_BRACKET:
			fprintf(fp,"open sq bracket: %s at line %d\n",yytext,yylineno);
			break;
			case CLOSED_SQ_BRACKET:
			fprintf(fp,"closed sq bracket: %s at line %d\n",yytext,yylineno);
			break;
			case PLUS:
			fprintf(fp,"plus: %s at line %d\n",yytext,yylineno);
			break;
			case MINUS:
			fprintf(fp,"minus: %s at line %d\n",yytext,yylineno);
			break;
			case MULTIPLY:
			fprintf(fp,"multiply: %s at line %d\n",yytext,yylineno);
			break;
			case DIVIDE:
			fprintf(fp,"divide: %s at line %d\n",yytext,yylineno);
			break;
			case REMAINDER:
			fprintf(fp,"remainder: %s at line %d\n",yytext,yylineno);
			break;
			case PLUS_EQUAL:
			fprintf(fp,"plus equal: %s at line %d\n",yytext,yylineno);
			break;
			case MINUS_EQUAL:
			fprintf(fp,"minus equal: %s at line %d\n",yytext,yylineno);
			break;
			case MULTIPLY_EQUAL:
			fprintf(fp,"multiply equal: %s at line %d\n",yytext,yylineno);
			break;
			case DIVIDE_EQUAL:
			fprintf(fp,"divide equal: %s at line %d\n",yytext,yylineno);
			break;
			case PLUS_PLUS:
			fprintf(fp,"plus plus: %s at line %d\n",yytext,yylineno);
			break;
			case MINUS_MINUS:
			fprintf(fp,"minus minus: %s at line %d\n",yytext,yylineno);
			break;
			case EQUAL:
			fprintf(fp,"equal: %s at line %d\n",yytext,yylineno);
			break;
			case COMMA:
			fprintf(fp,"comma: %s at line %d\n",yytext,yylineno);
			break;
		}
		token = yylex();
	}
	fclose (fp);
	printf("Done!\n");
	return 0;
}