%{
  #include <stdio.h>
  #include <stdlib.h>

  int yylex();
  void yyerror(char *msg);
%}

%union{
    int intValue;	    /* integer value */
	float floatValue;    /* float value */
	char charValue;    /* char value */
	char* stringValue;    /* string value*/
	char* identifier;       /* identifier name */
	char* comment;
};

%token <intValue> INTVALUE;
%token <floatValue> FLOATVALUE;
%token <charValue> CHARVALUE;
%token <stringValue> STRINGVALUE;
%token <comment> COMMENT;
%token <identifier> IDENTIFIER;
%token CONSTANT INT FLOAT STRING CHAR BOOL IF THEN ELSE WHILE DO SWITCH CASE DEFAULT FOR AND OR EQUALEQUAL GREATERTHAN SMALLERTHAN GREATERTHANOREQUAL SMALLERTHANOREQUAL NOT NOTEQUAL VOID MAIN RETURN BOOLVALUE 
%token SEMI_COLON OPENED_BRACKET CLOSED_BRACKET OPENED_BRACE CLOSED_BRACE OPENED_SQ_BRACKET CLOSED_SQ_BRACKET COMMA TWO_DOTS PLUS MINUS MULTIPLY DIVIDE REMAINDER PLUS_EQUAL MINUS_EQUAL MULTIPLY_EQUAL DIVIDE_EQUAL PLUS_PLUS MINUS_MINUS EQUAL
%token ERROR

%right MINUS
%left PLUS 
%right DIVIDE
%left MULTIPLY 
%right REMAINDER
%nonassoc PLUS_PLUS MINUS_MINUS


%left OR AND
%left EQUALEQUAL NOTEQUAL 
%left SMALLERTHAN SMALLERTHANOREQUAL GREATERTHAN GREATERTHANOREQUAL
%right NOT 


%%
    /* Language BODY */
                /* Comment_ Function_ Comment_ Main_ Comment_ */
    Root_: Comment_ SEMI_COLON {printf("\nAccepted inshaallah\n");}
        ;

    Comment_:  COMMENT  /* COMMENT Comment_ */{printf("First comment\n");}
          |Comment_ COMMENT {printf("Second comment\n");}
        ; 
    
%%

#include"lex.yy.c"

int main(){
  yyparse();
  return yylex();
}

void yyerror(char *msg){
  fprintf(stderr,"%s\n",msg);
  exit(1);
}

int yywrap(){
return 1;
}
