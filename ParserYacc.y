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
    Root_: Comment_ Main_ {printf("\nAccepted inshaallah\n");}
        ;

    Comment_:  COMMENT  /* COMMENT Comment_ */{printf("First comment\n");}
          |Comment_ COMMENT {printf("Second comment\n");}
           
        ; 

    Main_:      VOID MAIN OPENED_BRACKET CLOSED_BRACKET OPENED_BRACE Body_ CLOSED_BRACE {printf("Main root\n");}
        ;

    Body_: Body_  Declaration_  {printf("Body\n");}
    | Declaration_
    ;

    Declaration_: datatype IdentifierList_ SEMI_COLON {printf("declaration normal\n  ");}
                | CONSTANT datatype IdentifierList_ SEMI_COLON {printf("constant declaration\n ");}
                ;

    IdentifierList_: IDENTIFIER  {printf("id \n");}
                  | IDENTIFIER COMMA IdentifierList_ {printf("list of identifiers \n ")} 
                  | Assignment_ {printf("assignment \n")}
                   ;

    
    Assignment_: IDENTIFIER EQUAL Expr_ {printf("assignment expr \n");}
            ;

    Val_: STRINGVALUE {printf("val string value\n")}
        | CHARVALUE {printf("val char \n")}
        | BOOLVALUE {printf("val bool \n")}
        ;

    Number_: INTVALUE {printf("number int \n")}
           | FLOATVALUE {printf("number float \n")}
           ;

    Expr_: MathExpr_
            | LogExpr_
            ;

    datatype : INT {printf("Data Type");}
			  | FLOAT 
			  | STRING 
			  | CHAR 
			  | BOOL 
		 ;
       
  MathExpr_: MathExpr_ PLUS Term_                
          |MathExpr_ MINUS Term_                
          |Term_                       
            ;

  Term_: Term_ MULTIPLY Factor_                 
            |Term_ DIVIDE Factor_                  
            |Factor_                       
              ;

Factor_: OPENED_BRACKET MathExpr_ CLOSED_BRACKET               
          |MINUS Factor_                   
          |Number_
          |IDENTIFIER                     
            ;


    LogExpr_  : Val_
                
                | LogExpr_ OR LogExpr_ ++
                | LogExpr_ AND LogExpr_ 
                | LogExpr_ NOTEQUAL LogExpr_ 
                | LogExpr_ EQUALEQUAL LogExpr_
                | NOT LogExpr_
                | OPENED_BRACKET LogExpr_ CLOSED_BRACKET
                | MathExpr_ NOTEQUAL MathExpr_
                | MathExpr_ EQUALEQUAL MathExpr_
                | MathExpr_ GREATERTHAN MathExpr_ {printf("greater than expression")}
                | MathExpr_ GREATERTHANOREQUAL MathExpr_
                | MathExpr_ SMALLERTHAN MathExpr_
                | MathExpr_ SMALLERTHANOREQUAL MathExpr_
                ;
  
    
%%

#include"lex.yy.c"

int main(){
  yyparse();
  return yylex();
}

int yywrap(void){
return 1;
}

void yyerror(char *msg){
  fprintf(stderr,"%s\n",msg);
  exit(1);
}


