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
%token ERROR BREAK

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
         | Comment_ Main_ Comment_ {printf("\nAccepted inshaallah\n");}
         | Main_ Comment_ {printf("\nAccepted inshaallah\n");}
         | Main_ {printf("\nAccepted inshaallah\n");}
         | Comment_ Function_ Main_ {printf("\nAccepted inshaallah\n");}
         | Comment_ Function_ Main_ Comment_ {printf("\nAccepted inshaallah\n");}
         | Function_ Main_ Comment_ {printf("\nAccepted inshaallah\n");}
         | Function_ Main_ {printf("\nAccepted inshaallah\n");}
         | Comment_ Function_ Comment_ Main_ {printf("\nAccepted inshaallah\n");}
         | Comment_ Function_ Comment_ Main_ Comment_ {printf("\nAccepted inshaallah\n");}
         | Function_ Comment_ Main_ Comment_ {printf("\nAccepted inshaallah\n");}
         | Function_ Comment_ Main_ {printf("\nAccepted inshaallah\n");}
        ;

    Comment_:  COMMENT  /* COMMENT Comment_ */{printf("First comment\n");}
            |  Comment_ COMMENT {printf("Second comment\n");}
            ;

    Function_: FnDeclaration_
             | Function_ FnDeclaration_
             | Function_ Comment_ FnDeclaration_
             ;


    FnDeclaration_: VOID IDENTIFIER OPENED_BRACKET FnArgs_ CLOSED_BRACKET OPENED_BRACE Body_ CLOSED_BRACE
                  | VOID IDENTIFIER OPENED_BRACKET FnArgs_ CLOSED_BRACKET OPENED_BRACE Body_ RETURN SEMI_COLON CLOSED_BRACE
                  | VOID IDENTIFIER OPENED_BRACKET CLOSED_BRACKET OPENED_BRACE Body_ CLOSED_BRACE
                  | VOID IDENTIFIER OPENED_BRACKET CLOSED_BRACKET OPENED_BRACE Body_ RETURN SEMI_COLON CLOSED_BRACE
                  | datatype IDENTIFIER OPENED_BRACKET FnArgs_ CLOSED_BRACKET OPENED_BRACE BodyRtn_ RETURN AllVals_ SEMI_COLON CLOSED_BRACE
                  | datatype IDENTIFIER OPENED_BRACKET CLOSED_BRACKET OPENED_BRACE BodyRtn_ RETURN AllVals_ SEMI_COLON CLOSED_BRACE
                  ;  
        FnArgs_: datatype IDENTIFIER COMMA FnArgs_
           | datatype IDENTIFIER
           ; 

        FnCall_: IDENTIFIER OPENED_BRACKET CLOSED_BRACKET
                |IDENTIFIER OPENED_BRACKET FnCallArgs_ CLOSED_BRACKET
                ;

        FnCallArgs_: FnCallArgs_ COMMA AllVals_
           | AllVals_
           ;  
         

                         

    Main_: VOID MAIN OPENED_BRACKET CLOSED_BRACKET OPENED_BRACE Body_ CLOSED_BRACE {printf("Main root\n");}
         | VOID MAIN OPENED_BRACKET CLOSED_BRACKET OPENED_BRACE CLOSED_BRACE {printf("Main root\n");}
        ;

    Body_: Body_  Declaration_  {printf("Body\n");}
         | Declaration_
         | Body_ Assignment_ SEMI_COLON
         | Assignment_ SEMI_COLON
         | Body_ IfStmt_
         | IfStmt_
         | Body_ IfRtnZero_
         | IfRtnZero_
         | Body_ WhileStmt_
         | WhileStmt_
         | Body_ ForStmt_
         | ForStmt_
         | Body_ DoWhileStmt_
         | DoWhileStmt_
         | Body_ SwitchStmt_
         | SwitchStmt_
         | Body_ COMMENT
         | COMMENT
         ;

    BodyRtn_: BodyRtn_  Declaration_  {printf("Body\n");}
            | Declaration_
            | BodyRtn_ Assignment_ SEMI_COLON
            | Assignment_ SEMI_COLON
            | BodyRtn_ IfStmt_
            | IfStmt_
            | BodyRtn_ IfRtn_
            | IfRtn_
            | BodyRtn_ WhileStmt_
            | WhileStmt_
            | BodyRtn_ ForStmt_
            | ForStmt_
            | BodyRtn_ DoWhileStmt_
            | DoWhileStmt_
            | BodyRtn_ SwitchStmt_
            | SwitchStmt_
            | BodyRtn_ COMMENT
            | COMMENT
            ;

    Declaration_: datatype IdentifierList_ SEMI_COLON {printf("declaration normal\n  ");}
                | CONSTANT datatype IdentifierList_ SEMI_COLON {printf("constant declaration\n ");}
                |datatype IDENTIFIER OPENED_SQ_BRACKET INTVALUE CLOSED_SQ_BRACKET SEMI_COLON
                ;

    datatype : INT {printf("Data Type");}
			  | FLOAT 
			  | STRING 
			  | CHAR 
			  | BOOL 
		 ;            

    IdentifierList_: IDENTIFIER  {printf("id \n");}
                  | IDENTIFIER COMMA IdentifierList_ {printf("list of identifiers \n ")} 
                  | Assignment_ {printf("assignment \n")}
                   ;

    Assignment_: IDENTIFIER EQUAL Expr_ {printf("assignment expr \n");}
              | IDENTIFIER EQUAL Expr2_
              |IDENTIFIER EQUAL FnCall_
              |IDENTIFIER EQUAL IDENTIFIER OPENED_SQ_BRACKET INTVALUE CLOSED_SQ_BRACKET
              |  Expr2_
            ;

    Val_: STRINGVALUE {printf("val string value\n")}
        | CHARVALUE {printf("val char \n")}
        | BOOLVALUE {printf("val bool \n")}
        ;

    Number_: INTVALUE {printf("number int \n")}
           | FLOATVALUE {printf("number float \n")}
           ;

    Expr2_: IDENTIFIER PLUS_PLUS
          | PLUS_PLUS IDENTIFIER
          | IDENTIFIER MINUS_MINUS
          | MINUS_MINUS IDENTIFIER
          ;

    Expr_: Logical_;

    Logical_: Logical_ AND Math_
            | Logical_ OR Math_
            | Logical_ GREATERTHAN Math_
            | Logical_ GREATERTHANOREQUAL Math_
            | Logical_ SMALLERTHAN Math_
            | Logical_ SMALLERTHANOREQUAL Math_
            | Logical_ EQUALEQUAL Math_
            | Logical_ NOTEQUAL Math_
            | NOT Math_
            | Math_;

    Math_: Math_ PLUS Term_ | Math_ MINUS Term_ | Term_;

    Term_: Term_ MULTIPLY Factor_ | Term_ DIVIDE Factor_ | Factor_;

    Factor_: IDENTIFIER | Val_ | Number_ | OPENED_BRACKET Logical_ CLOSED_BRACKET;

    IfStmt_: IF OPENED_BRACKET Expr_ CLOSED_BRACKET OPENED_BRACE Body_ CLOSED_BRACE 
           | IF OPENED_BRACKET Expr_ CLOSED_BRACKET OPENED_BRACE Body_ CLOSED_BRACE ELSE OPENED_BRACE Body_ CLOSED_BRACE  
           | IF OPENED_BRACKET Expr_ CLOSED_BRACKET OPENED_BRACE Body_ CLOSED_BRACE ELSE IfStmt_
           ;

    IfRtnZero_: IF OPENED_BRACKET Expr_ CLOSED_BRACKET OPENED_BRACE Body_ RETURN SEMI_COLON CLOSED_BRACE 
              | IF OPENED_BRACKET Expr_ CLOSED_BRACKET OPENED_BRACE Body_ RETURN SEMI_COLON CLOSED_BRACE ELSE OPENED_BRACE Body_ RETURN SEMI_COLON CLOSED_BRACE  
              | IF OPENED_BRACKET Expr_ CLOSED_BRACKET OPENED_BRACE Body_ RETURN SEMI_COLON CLOSED_BRACE ELSE IfStmt_   
              | IF OPENED_BRACKET Expr_ CLOSED_BRACKET OPENED_BRACE Body_ RETURN SEMI_COLON CLOSED_BRACE ELSE IfRtnZero_   
              | IF OPENED_BRACKET Expr_ CLOSED_BRACKET OPENED_BRACE Body_ CLOSED_BRACE ELSE IfRtnZero_ 
              | IF OPENED_BRACKET Expr_ CLOSED_BRACKET OPENED_BRACE Body_ CLOSED_BRACE ELSE OPENED_BRACE Body_ RETURN SEMI_COLON CLOSED_BRACE  
              | IF OPENED_BRACKET Expr_ CLOSED_BRACKET OPENED_BRACE Body_ RETURN SEMI_COLON CLOSED_BRACE ELSE OPENED_BRACE Body_ CLOSED_BRACE  
              ;

    IfRtn_: IF OPENED_BRACKET Expr_ CLOSED_BRACKET OPENED_BRACE Body_ RETURN AllVals_ SEMI_COLON CLOSED_BRACE 
          | IF OPENED_BRACKET Expr_ CLOSED_BRACKET OPENED_BRACE Body_ RETURN AllVals_ SEMI_COLON CLOSED_BRACE ELSE OPENED_BRACE Body_ RETURN AllVals_ SEMI_COLON CLOSED_BRACE  
          | IF OPENED_BRACKET Expr_ CLOSED_BRACKET OPENED_BRACE Body_ RETURN AllVals_ SEMI_COLON CLOSED_BRACE ELSE IfStmt_  
          | IF OPENED_BRACKET Expr_ CLOSED_BRACKET OPENED_BRACE Body_ RETURN AllVals_ SEMI_COLON CLOSED_BRACE ELSE IfRtn_  
          | IF OPENED_BRACKET Expr_ CLOSED_BRACKET OPENED_BRACE Body_ CLOSED_BRACE ELSE IfRtn_ 
          | IF OPENED_BRACKET Expr_ CLOSED_BRACKET OPENED_BRACE Body_ CLOSED_BRACE ELSE OPENED_BRACE Body_ RETURN AllVals_ SEMI_COLON CLOSED_BRACE  
          | IF OPENED_BRACKET Expr_ CLOSED_BRACKET OPENED_BRACE Body_ RETURN AllVals_ SEMI_COLON CLOSED_BRACE ELSE OPENED_BRACE Body_ CLOSED_BRACE                
          ;

    WhileStmt_: WHILE OPENED_BRACKET Expr_ CLOSED_BRACKET OPENED_BRACE Body_ CLOSED_BRACE  
              ;    

    ForStmt_: FOR OPENED_BRACKET First_ Second_ Third_ CLOSED_BRACKET OPENED_BRACE Body_ CLOSED_BRACE
            ;

    First_: Declaration_ | Assignment_ SEMI_COLON
          ;

    Second_: Expr_ SEMI_COLON
           ;

    Third_: Assignment_
          ;   

    DoWhileStmt_: DO OPENED_BRACE Body_ CLOSED_BRACE WHILE OPENED_BRACKET Expr_ CLOSED_BRACKET SEMI_COLON      
                ;    

    SwitchStmt_: SWITCH OPENED_BRACKET IDENTIFIER CLOSED_BRACKET OPENED_BRACE CaseStmt_ CLOSED_BRACE 
               ;

    CaseStmt_: CaseStmt_ DefaultStmt_
             | DefaultStmt_
             | CaseStmt_ CASE CaseVal_ TWO_DOTS CaseBody_
             | CASE CaseVal_ TWO_DOTS CaseBody_  
             ;

    DefaultStmt_: DEFAULT TWO_DOTS CaseBody_
                ;      

    CaseVal_: Number_ | Val_ ;

    CaseBody_: Body_ BREAK SEMI_COLON
            | BREAK SEMI_COLON
            ; 

    AllVals_: Number_ | Val_ | IDENTIFIER
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


