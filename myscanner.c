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
			case ERROR:
			fprintf(fp,"Error values: %s at line %d\n",yytext,yylineno);
			break;
			case CONSTANT:
			fprintf(fp,"Constant key word: %s at line %d\n",yytext,yylineno);
			break;
			case INT:
			fprintf(fp,"Int key word: %s at line %d\n",yytext,yylineno);
			break;
			case FLOAT:
			fprintf(fp,"Float key word: %s at line %d\n",yytext,yylineno);
			break;
			case STRING:
			fprintf(fp,"String key word: %s at line %d\n",yytext,yylineno);
			break;
			case CHAR:
			fprintf(fp,"Char key word: %s at line %d\n",yytext,yylineno);
			break;
			case BOOL:
			fprintf(fp,"Boolean key word: %s at line %d\n",yytext,yylineno);
			break;
			case IF:
			fprintf(fp,"If key word: %s at line %d\n",yytext,yylineno);
			break;
			case THEN:
			fprintf(fp,"Then key word: %s at line %d\n",yytext,yylineno);
			break;
			case ELSE:
			fprintf(fp,"Else key word: %s at line %d\n",yytext,yylineno);
			break;
			case WHILE:
			fprintf(fp,"While key word: %s at line %d\n",yytext,yylineno);
			break;
			case DO:
			fprintf(fp,"Do key word: %s at line %d\n",yytext,yylineno);
			break;
			case SWITCH:
			fprintf(fp,"Switch key word: %s at line %d\n",yytext,yylineno);
			break;
			case CASE:
			fprintf(fp,"Case key word: %s at line %d\n",yytext,yylineno);
			break;
			case DEFAULT:
			fprintf(fp,"Default key word: %s at line %d\n",yytext,yylineno);
			break;
			case FOR:
			fprintf(fp,"For key word: %s at line %d\n",yytext,yylineno);
			break;
			case AND:
			fprintf(fp,"And key word: %s at line %d\n",yytext,yylineno);
			break;
			case OR:
			fprintf(fp,"Or key word: %s at line %d\n",yytext,yylineno);
			break;
			case EQUALEQUAL:
			fprintf(fp,"EQUALEQUAL values: %s at line %d\n",yytext,yylineno);
			break;
			case GREATERTHAN:
			fprintf(fp,"GREATERTHAN values: %s at line %d\n",yytext,yylineno);
			break;
			case SMALLERTHAN:
			fprintf(fp,"SMALLERTHAN values: %s at line %d\n",yytext,yylineno);
			break;
			case GREATERTHANOREQUAL:
			fprintf(fp,"GREATERTHANOREQUAL values: %s at line %d\n",yytext,yylineno);
			break;
			case SMALLERTHANOREQUAL:
			fprintf(fp,"SMALLERTHANOREQUAL values: %s at line %d\n",yytext,yylineno);
			break;
			case INTVALUE:
			fprintf(fp,"int values: %s at line %d\n",yytext,yylineno);
			break;
			case FLOATVALUE:
			fprintf(fp,"Float values: %s at line %d\n",yytext,yylineno);
			break;
			case STRINGVALUE:
			fprintf(fp,"String values: %s at line %d\n",yytext,yylineno);
			break;
			case CHARVALUE:
			fprintf(fp,"Char values: %s at line %d\n",yytext,yylineno);
			break;
			case BOOLVALUE:
			fprintf(fp,"Boolean values: %s at line %d\n",yytext,yylineno);
			break;
			case IDENTIFIER:
			fprintf(fp,"Identifier values: %s at line %d\n",yytext,yylineno);
			break;
			case OPENED_BRACKET:
			fprintf(fp,"Opened bracket: %s at line %d\n",yytext,yylineno);
			break;
			case SEMI_COLON:
			fprintf(fp,"Semi colon: %s at line %d\n",yytext,yylineno);
			break;
			case CLOSED_BRACKET:
			fprintf(fp,"Closed bracket: %s at line %d\n",yytext,yylineno);
			break;
			case OPENED_BRACE:
			fprintf(fp,"Opened brace: %s at line %d\n",yytext,yylineno);
			break;
			case CLOSED_BRACE:
			fprintf(fp,"Closed brace: %s at line %d\n",yytext,yylineno);
			break;
			case OPENED_SQ_BRACKET:
			fprintf(fp,"Opened sq bracket: %s at line %d\n",yytext,yylineno);
			break;
			case CLOSED_SQ_BRACKET:
			fprintf(fp,"Closed sq bracket: %s at line %d\n",yytext,yylineno);
			break;
			case COMMA:
			fprintf(fp,"Comma: %s at line %d\n",yytext,yylineno);
			break;
			case TWO_DOTS:
			fprintf(fp,"Two dots: %s at line %d\n",yytext,yylineno);
			break;
			case PLUS:
			fprintf(fp,"Plus: %s at line %d\n",yytext,yylineno);
			break;
			case MINUS:
			fprintf(fp,"Minus: %s at line %d\n",yytext,yylineno);
			break;
			case MULTIPLY:
			fprintf(fp,"Multiply: %s at line %d\n",yytext,yylineno);
			break;
			case DIVIDE:
			fprintf(fp,"Divide: %s at line %d\n",yytext,yylineno);
			break;
			case REMAINDER:
			fprintf(fp,"Remainder: %s at line %d\n",yytext,yylineno);
			break;
			case PLUS_EQUAL:
			fprintf(fp,"Plus equal: %s at line %d\n",yytext,yylineno);
			break;
			case MINUS_EQUAL:
			fprintf(fp,"Minus equal: %s at line %d\n",yytext,yylineno);
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
			case NOT:
			fprintf(fp,"Not: %s at line %d\n",yytext,yylineno);
			break;
			case NOTEQUAL:
			fprintf(fp,"Not equal: %s at line %d\n",yytext,yylineno);
			break;
			case RETURN:
			fprintf(fp,"Return values: %s at line %d\n",yytext,yylineno);
			break;
			case MAIN:
			fprintf(fp,"Main values: %s at line %d\n",yytext,yylineno);
			break;
			case COMMENT:
			fprintf(fp,"Comment values: %s at line %d\n",yytext,yylineno);
			break;	
		}
		token = yylex();
	}
	fclose (fp);
	printf("Done!\n");
	return 0;
}