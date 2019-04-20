%{
#include <string.h>
#include <stdio.h>
#include <stdlib.h>
#include "ParserYacc.tab.h"
int mylineno = 1;

%}
%option nounput yylineno

%%

  
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
"break"                                             return BREAK;
"return"                                            return RETURN;
"main"                                              return MAIN;
"void"                                              return VOID;
"&&"						                        return AND;
"||"						                        return OR;
"!"                                                 return NOT;
"==" 						                        return EQUALEQUAL;
"!="                                                return NOTEQUAL;
">" 						                        return GREATERTHAN;
"<"						                            return SMALLERTHAN;
">="						                        return GREATERTHANOREQUAL;
"<="						                        return SMALLERTHANOREQUAL;
";"                                                 return SEMI_COLON;
"("                                                 return OPENED_BRACKET;
")"                                                 return CLOSED_BRACKET;
"{"                                                 return OPENED_BRACE;
"}"                                                 return CLOSED_BRACE;
"["                                                 return OPENED_SQ_BRACKET;
"]"                                                 return CLOSED_SQ_BRACKET;
","                                                 return COMMA;
":"                                                 return TWO_DOTS;
"+"                                                 return PLUS;
"-"                                                 return MINUS;
"*"                                                 return MULTIPLY;
"/"                                                 return DIVIDE;
"%"                                                 return REMAINDER;
"+="                                                return PLUS_EQUAL;
"-="                                                return MINUS_EQUAL;
"*="                                                return MULTIPLY_EQUAL;
"/="                                                return DIVIDE_EQUAL;
"++"                                                return PLUS_PLUS;
"--"                                                return MINUS_MINUS;
"="                                                 return EQUAL; 

[0-9]+                                              return INTVALUE;
[0-9]+\.[0-9]+                                      return FLOATVALUE;
[0-9]*\.[0-9]+                                      return FLOATVALUE;
[0-9]+\.[0-9]*		                                return FLOATVALUE;
\".*\"                                              return STRINGVALUE;
\'[a-zA-Z0-9]\'                                     return CHARVALUE;
True|False                                          return BOOLVALUE;
\n {mylineno++;}
[ \t] ;
^[a-zA-Z][_a-zA-Z0-9]*                              return IDENTIFIER;
[a-zA-Z][_a-zA-Z0-9]*                            return IDENTIFIER;

(\/\*([^*]|[\r\n]|(\*+([^*/]|[\r\n])))*\*+\/)|(\/\/.*)                                           return COMMENT;




 	
[0-9]+[a-zA-Z]                                      {fprintf(stderr,"\nError Invalid Token on line %d : %s",mylineno,yytext);; return ERROR;}
.                                                   {fprintf(stderr,"\nError Invalid Token on line %d : %s",mylineno,yytext);; return ERROR;}
^[a-zA-Z][_a-zA-Z0-9]*\.[_a-zA-Z0-9]*               {fprintf(stderr,"\nError Invalid Token on line %d : %s",mylineno,yytext);; return ERROR;}
[ ][a-zA-Z][_a-zA-Z0-9]*\.[_a-zA-Z0-9]*             {fprintf(stderr,"\nError Invalid Token on line %d : %s",mylineno,yytext);; return ERROR;}
[0-9]+\.[0-9]+[_a-zA-Z0-9\.]*                       {fprintf(stderr,"\nError Invalid Token on line %d : %s",mylineno,yytext);; return ERROR;}
[0-9]*\.[0-9]+[_a-zA-Z0-9\.]*                       {fprintf(stderr,"\nError Invalid Token on line %d : %s",mylineno,yytext);; return ERROR;}
[0-9]+\.[0-9]*[_a-zA-Z0-9\.]*                       {fprintf(stderr,"\nError Invalid Token on line %d : %s",mylineno,yytext);; return ERROR;}



%%      