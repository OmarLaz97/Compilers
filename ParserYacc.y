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
    Root_:       Comment_  {printf("\nAccepted inshaallah\n"); exit(0);}
        ;

    Comment_:   /* empty */ 
            |  COMMENT  /* COMMENT Comment_ */
        ; 

    Function_:     /* ASssume this is function description */   

    Main_:      VOID MAIN OPENED_BRACKET CLOSED_BRACKET OPENED_BRACE Body_ CLOSED_BRACE
        ;

    Body_   : Declaration_ Body_
            | Assignment_ SEMI_COLON Body_
            | Comment_ Body_
            | WhileStmt_ Body_
            | IfStmt_ Body_
            | ForStmt_ Body_
            | Comment_ Body_  
		    |
	        ;

    Declaration_: datatype IdentifierList_ SEMI_COLON
                ;

    IdentifierList_: IDENTIFIER 
                   | IDENTIFIER COMMA IdentifierList_ 
                   | Assignment_  
                   ;

    Assignment_: IDENTIFIER EQUAL IDENTIFIER
               | IDENTIFIER EQUAL Val_
               | IDENTIFIER EQUAL Expr_
               |
               ;

    Val_: Number_ 
        | STRINGVALUE
        | CHARVALUE
        | BOOLVALUE
        ;

    Number_: INTVALUE
           | FLOATVALUE
           ;

    Expr_: MathExpr_
            | LogExpr_
            ;

    MathExpr_ : IDENTIFIER
                | MathExpr_ PLUS MathExpr_
                | MathExpr_ MINUS MathExpr_
                | MathExpr_ MULTIPLY MathExpr_
                | MathExpr_ DIVIDE MathExpr_
                | MathExpr_ REMAINDER MathExpr_
                | OPENED_BRACKET MathExpr_ CLOSED_BRACKET
                | PLUS_PLUS IDENTIFIER
                | MINUS_MINUS IDENTIFIER
                | IDENTIFIER PLUS_PLUS
                | IDENTIFIER MINUS_MINUS
                ;

    LogExpr_  : IDENTIFIER
                | Val_
                | LogExpr_ OR LogExpr_ 
                | LogExpr_ AND LogExpr_ 
                | LogExpr_ NOTEQUAL LogExpr_ 
                | LogExpr_ EQUALEQUAL LogExpr_
                | NOT LogExpr_
                | OPENED_BRACKET LogExpr_ CLOSED_BRACKET
                | MathExpr_ NOTEQUAL MathExpr_
                | MathExpr_ EQUALEQUAL MathExpr_
                | MathExpr_ GREATERTHAN MathExpr_
                | MathExpr_ GREATERTHANOREQUAL MathExpr_
                | MathExpr_ SMALLERTHAN MathExpr_
                | MathExpr_ SMALLERTHANOREQUAL MathExpr_
                ;

    WhileStmt_: WHILE OPENED_BRACKET LogExpr_ CLOSED_BRACKET OPENED_BRACE Body_ CLOSED_BRACE
              ;

    IfStmt_: IF OPENED_BRACKET LogExpr_ CLOSED_BRACKET OPENED_BRACE Body_ CLOSED_BRACE
           | IF OPENED_BRACKET LogExpr_ CLOSED_BRACKET OPENED_BRACE Body_ CLOSED_BRACE ELSE OPENED_BRACE Body_ CLOSED_BRACE
           ;

    ForStmt_: FOR OPENED_BRACKET First_ Second_ MathExpr_ CLOSED_BRACKET OPENED_BRACE Body_ CLOSED_BRACE
            ;

    First_: Declaration_ | Assignment_ SEMI_COLON;
    Second_: LogExpr_ SEMI_COLON;                                     

    /* Utils */
    datatype : INT 
			  | FLOAT 
			  | STRING 
			  | CHAR 
			  | BOOL 
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
