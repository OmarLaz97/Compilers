%{
#include "defs.h"
#include <string.h>
#include <stdio.h>
#include <stdlib.h>
%}
%option nounput yylineno

%%

[-+*/(){}=!&|] 				                        return yytext[0];
"sabet"					                        	return CONSTANT;
"rakam"						                        return INT;
"3ayem"						                        return FLOAT;
"gomla"						                        return STRING;
"7arf"						                        return CHAR;
"bool"						                        return BOOL;
"law"						                        return IF;
"yeb2a"						                        return THEN;
"laken"						                        return ELSE;
"talama"					                        return WHILE;
"e3mel"						                        return DO;
"badel"						                        return SWITCH;
"7alet"						                        return CASE;
"el3ady"					                        return DEFAULT;
"lef"						                        return FOR;
"&&"						                            return AND;
"||"						                            return OR;
"==" 						                            return EQUAL;
">" 						                            return GREATERTHAN;
"<"						                            return SMALLERTHAN;
">="						                            return GREATERTHANOREQUAL;
"<="						                            return SMALLERTHANOREQUAL;

(\+|-)?[0-9]+[ |$|;] return INTVALUE;
[0-9]+\.[0-9]+				                        return FLOATVALUE;
\".*\"            return STRINGVALUE;
\'[a-zA-Z0-9]\'                 return CHARVALUE;
True|False                                        return BOOLVALUE;

((^[a-zA-Z][_a-zA-Z0-9]*)|([ ][a-zA-Z][_a-zA-Z0-9]*)) return IDENTIFIER;
 
[\t\n] ;	
. ;
%%
int yywrap(void){
return 1;
}