%{
  #include <stdio.h>
  #include <stdlib.h>

  int yylex();
  void yyerror(char *msg);
  extern int mylineno;
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

        Comment_:  COMMENT  {printf("\nValid Comment");}
                |  Comment_ COMMENT {printf("\nValid Comment");}
                ;

        Function_: FnDeclaration_ 
                 | Function_ FnDeclaration_
                 | Function_ Comment_ FnDeclaration_
                 ;

        FnDeclaration_: VOID IDENTIFIER OPENED_BRACKET FnArgs_ CLOSED_BRACKET OPENED_BRACE Body_ CLOSED_BRACE {printf("\nValid Function");}
                      | VOID IDENTIFIER OPENED_BRACKET FnArgs_ CLOSED_BRACKET OPENED_BRACE Body_ RETURN SEMI_COLON CLOSED_BRACE {printf("\nValid Function");}
                      | VOID IDENTIFIER OPENED_BRACKET CLOSED_BRACKET OPENED_BRACE Body_ CLOSED_BRACE {printf("\nValid Function");}
                      | VOID IDENTIFIER OPENED_BRACKET CLOSED_BRACKET OPENED_BRACE Body_ RETURN SEMI_COLON CLOSED_BRACE {printf("\nValid Function");}
                      | datatype IDENTIFIER OPENED_BRACKET FnArgs_ CLOSED_BRACKET OPENED_BRACE BodyRtn_ RETURN AllVals_ SEMI_COLON CLOSED_BRACE {printf("\nValid Function");}
                      | datatype IDENTIFIER OPENED_BRACKET CLOSED_BRACKET OPENED_BRACE BodyRtn_ RETURN AllVals_ SEMI_COLON CLOSED_BRACE {printf("\nValid Function");}
                      | datatype OPENED_SQ_BRACKET CLOSED_SQ_BRACKET IDENTIFIER OPENED_BRACKET FnArgs_ CLOSED_BRACKET OPENED_BRACE Body_ RETURN OPENED_BRACE ArrayListVal_ CLOSED_BRACE SEMI_COLON CLOSED_BRACE {printf("\nValid Function");}
 		      | datatype OPENED_SQ_BRACKET CLOSED_SQ_BRACKET IDENTIFIER OPENED_BRACKET FnArgs_ CLOSED_BRACKET OPENED_BRACE Body_ RETURN OPENED_BRACE CLOSED_BRACE SEMI_COLON CLOSED_BRACE {printf("\nValid Function");}
		      | datatype OPENED_SQ_BRACKET CLOSED_SQ_BRACKET IDENTIFIER OPENED_BRACKET FnArgs_ CLOSED_BRACKET OPENED_BRACE Body_ RETURN IDENTIFIER SEMI_COLON CLOSED_BRACE {printf("\nValid Function");}		
                      | datatype OPENED_SQ_BRACKET CLOSED_SQ_BRACKET IDENTIFIER OPENED_BRACKET CLOSED_BRACKET OPENED_BRACE Body_ RETURN OPENED_BRACE ArrayListVal_ CLOSED_BRACE SEMI_COLON CLOSED_BRACE {printf("\nValid Function");} 
 		      | datatype OPENED_SQ_BRACKET CLOSED_SQ_BRACKET IDENTIFIER OPENED_BRACKET CLOSED_BRACKET OPENED_BRACE Body_ RETURN OPENED_BRACE CLOSED_BRACE SEMI_COLON CLOSED_BRACE {printf("\nValid Function");}
		      | datatype OPENED_SQ_BRACKET CLOSED_SQ_BRACKET IDENTIFIER OPENED_BRACKET CLOSED_BRACKET OPENED_BRACE Body_ RETURN IDENTIFIER SEMI_COLON CLOSED_BRACE {printf("\nValid Function");}
                      ;  

        FnArgs_: datatype IDENTIFIER COMMA FnArgs_
               | datatype IDENTIFIER
               | datatype IDENTIFIER OPENED_SQ_BRACKET CLOSED_SQ_BRACKET COMMA FnArgs_
               | datatype IDENTIFIER OPENED_SQ_BRACKET CLOSED_SQ_BRACKET
               ; 

        FnCall_: IDENTIFIER OPENED_BRACKET CLOSED_BRACKET
               | IDENTIFIER OPENED_BRACKET FnCallArgs_ CLOSED_BRACKET
               ;

        FnCallArgs_: FnCallArgs_ COMMA AllVals_
                   | FnCallArgs_ COMMA IDENTIFIER OPENED_SQ_BRACKET ArrIndex_ CLOSED_SQ_BRACKET
                   | AllVals_
                   | IDENTIFIER OPENED_SQ_BRACKET ArrIndex_ CLOSED_SQ_BRACKET
                   ;  
         

        Main_: VOID MAIN OPENED_BRACKET CLOSED_BRACKET OPENED_BRACE Body_ CLOSED_BRACE {printf("\nValid Main");}
             | VOID MAIN OPENED_BRACKET CLOSED_BRACKET OPENED_BRACE CLOSED_BRACE {printf("\nValid Main");}
             ;

        Body_: Body_  Declaration_  
             | Declaration_
             | Body_ Assignment_ SEMI_COLON
             | Assignment_ SEMI_COLON
             | Body_ FnCall_ SEMI_COLON
             | FnCall_ SEMI_COLON
             | Body_ Expr2_ SEMI_COLON
             | Expr2_ SEMI_COLON
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

        BodyRtn_: BodyRtn_  Declaration_  
                | Declaration_
                | BodyRtn_ Assignment_ SEMI_COLON
                | Assignment_ SEMI_COLON
                | BodyRtn_ FnCall_ SEMI_COLON
                | FnCall_ SEMI_COLON
                | BodyRtn_ Expr2_ SEMI_COLON
                | Expr2_ SEMI_COLON
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

        Declaration_: datatype IdentifierList_ SEMI_COLON {printf("\nValid Declaration");}
                    | CONSTANT datatype IdentifierList_ SEMI_COLON {printf("\nValid Constant Declaration");}
                    | datatype IDENTIFIER OPENED_SQ_BRACKET INTVALUE CLOSED_SQ_BRACKET SEMI_COLON {printf("\nValid Array Declaration");}
                    | datatype IDENTIFIER OPENED_SQ_BRACKET INTVALUE CLOSED_SQ_BRACKET EQUAL OPENED_BRACE ArrayListVal_ CLOSED_BRACE SEMI_COLON {printf("\nValid Array Declaration");}
                    | ArrayList_ EQUAL ArrVal_ SEMI_COLON {printf("\nValid Array Declaration");}
                    ;

        ArrIndex_: INTVALUE | IDENTIFIER
                 ;

        ArrayListVal_: ArrayListVal_ COMMA  ArrVal_ | ArrVal_
                     ;

        ArrVal_: AllVals_
               | FnCall_
               | IDENTIFIER OPENED_SQ_BRACKET ArrIndex_ CLOSED_SQ_BRACKET
               ;

        ArrayList_: IDENTIFIER OPENED_SQ_BRACKET ArrIndex_ CLOSED_SQ_BRACKET
                  | ArrayList_ COMMA IDENTIFIER OPENED_SQ_BRACKET ArrIndex_ CLOSED_SQ_BRACKET
                  ;

        datatype: INT 
		| FLOAT 
		| STRING 
		| CHAR 
		| BOOL 
		;            

        IdentifierList_: IDENTIFIER  
                       | IDENTIFIER COMMA IdentifierList_ 
                       | Assignment_
                       ;

        Assignment_: IDENTIFIER EQUAL Expr_ 
                   | IDENTIFIER EQUAL Expr2_
                   |IDENTIFIER EQUAL FnCall_
                   ;

        Val_: STRINGVALUE 
            | CHARVALUE 
            | BOOLVALUE 
            ;

        Number_: INTVALUE 
               | FLOATVALUE 
               ;

        Expr2_: IDENTIFIER PLUS_PLUS
              | PLUS_PLUS IDENTIFIER
              | IDENTIFIER MINUS_MINUS
              | MINUS_MINUS IDENTIFIER
              |IDENTIFIER PLUS_EQUAL Number_
              |IDENTIFIER MINUS_EQUAL Number_
              |IDENTIFIER MULTIPLY_EQUAL Number_
              |IDENTIFIER DIVIDE_EQUAL Number_
              ;

        Expr_: Logical_
             ;

        Logical_: Logical_ AND Math_
                | Logical_ OR Math_
                | Logical_ GREATERTHAN Math_
                | Logical_ GREATERTHANOREQUAL Math_
                | Logical_ SMALLERTHAN Math_
                | Logical_ SMALLERTHANOREQUAL Math_
                | Logical_ EQUALEQUAL Math_
                | Logical_ NOTEQUAL Math_
                | NOT Math_
                | Math_
                ;

        Math_: Math_ PLUS Term_ | Math_ MINUS Term_ | Term_
             ;

        Term_: Term_ MULTIPLY Factor_ | Term_ DIVIDE Factor_ | Factor_
             ;

        Factor_: IDENTIFIER | Val_ | Number_ | OPENED_BRACKET Logical_ CLOSED_BRACKET 
               | IDENTIFIER OPENED_SQ_BRACKET ArrIndex_ CLOSED_SQ_BRACKET;

        IfStmt_: IF OPENED_BRACKET Expr_ CLOSED_BRACKET OPENED_BRACE Body_ CLOSED_BRACE {printf("\nValid If Statement");}
               | IF OPENED_BRACKET Expr_ CLOSED_BRACKET OPENED_BRACE Body_ CLOSED_BRACE ELSE OPENED_BRACE Body_ CLOSED_BRACE {printf("\nValid If Statement");}
               | IF OPENED_BRACKET Expr_ CLOSED_BRACKET OPENED_BRACE Body_ CLOSED_BRACE ELSE IfStmt_ {printf("\nValid If Statement");}
               ;

        IfRtnZero_: IF OPENED_BRACKET Expr_ CLOSED_BRACKET OPENED_BRACE Body_ RETURN SEMI_COLON CLOSED_BRACE {printf("\nValid If Statement");}
                  | IF OPENED_BRACKET Expr_ CLOSED_BRACKET OPENED_BRACE Body_ RETURN SEMI_COLON CLOSED_BRACE ELSE OPENED_BRACE Body_ RETURN SEMI_COLON CLOSED_BRACE {printf("\nValid If Statement");} 
                  | IF OPENED_BRACKET Expr_ CLOSED_BRACKET OPENED_BRACE Body_ RETURN SEMI_COLON CLOSED_BRACE ELSE IfStmt_ {printf("\nValid If Statement");}   
                  | IF OPENED_BRACKET Expr_ CLOSED_BRACKET OPENED_BRACE Body_ RETURN SEMI_COLON CLOSED_BRACE ELSE IfRtnZero_ {printf("\nValid If Statement");}   
                  | IF OPENED_BRACKET Expr_ CLOSED_BRACKET OPENED_BRACE Body_ CLOSED_BRACE ELSE IfRtnZero_ {printf("\nValid If Statement");} 
                  | IF OPENED_BRACKET Expr_ CLOSED_BRACKET OPENED_BRACE Body_ CLOSED_BRACE ELSE OPENED_BRACE Body_ RETURN SEMI_COLON CLOSED_BRACE {printf("\nValid If Statement");}  
                  | IF OPENED_BRACKET Expr_ CLOSED_BRACKET OPENED_BRACE Body_ RETURN SEMI_COLON CLOSED_BRACE ELSE OPENED_BRACE Body_ CLOSED_BRACE {printf("\nValid If Statement");}  
                  ;

        IfRtn_: IF OPENED_BRACKET Expr_ CLOSED_BRACKET OPENED_BRACE Body_ RETURN AllVals_ SEMI_COLON CLOSED_BRACE {printf("\nValid If Statement");} 
              | IF OPENED_BRACKET Expr_ CLOSED_BRACKET OPENED_BRACE Body_ RETURN AllVals_ SEMI_COLON CLOSED_BRACE ELSE OPENED_BRACE Body_ RETURN AllVals_ SEMI_COLON CLOSED_BRACE {printf("\nValid If Statement");} 
              | IF OPENED_BRACKET Expr_ CLOSED_BRACKET OPENED_BRACE Body_ RETURN AllVals_ SEMI_COLON CLOSED_BRACE ELSE IfStmt_ {printf("\nValid If Statement");}
              | IF OPENED_BRACKET Expr_ CLOSED_BRACKET OPENED_BRACE Body_ RETURN AllVals_ SEMI_COLON CLOSED_BRACE ELSE IfRtn_ {printf("\nValid If Statement");} 
              | IF OPENED_BRACKET Expr_ CLOSED_BRACKET OPENED_BRACE Body_ CLOSED_BRACE ELSE IfRtn_ {printf("\nValid If Statement");}
              | IF OPENED_BRACKET Expr_ CLOSED_BRACKET OPENED_BRACE Body_ CLOSED_BRACE ELSE OPENED_BRACE Body_ RETURN AllVals_ SEMI_COLON CLOSED_BRACE {printf("\nValid If Statement");}
              | IF OPENED_BRACKET Expr_ CLOSED_BRACKET OPENED_BRACE Body_ RETURN AllVals_ SEMI_COLON CLOSED_BRACE ELSE OPENED_BRACE Body_ CLOSED_BRACE {printf("\nValid If Statement");}               
              ;

        IfBreak_: IF OPENED_BRACKET Expr_ CLOSED_BRACKET OPENED_BRACE Body_ BREAK SEMI_COLON CLOSED_BRACE {printf("\nValid If Statement");} 
                | IF OPENED_BRACKET Expr_ CLOSED_BRACKET OPENED_BRACE Body_ BREAK SEMI_COLON CLOSED_BRACE ELSE OPENED_BRACE Body_ BREAK SEMI_COLON CLOSED_BRACE {printf("\nValid If Statement");} 
                | IF OPENED_BRACKET Expr_ CLOSED_BRACKET OPENED_BRACE Body_ BREAK SEMI_COLON CLOSED_BRACE ELSE IfStmt_ {printf("\nValid If Statement");}
                | IF OPENED_BRACKET Expr_ CLOSED_BRACKET OPENED_BRACE Body_ BREAK SEMI_COLON CLOSED_BRACE ELSE IfBreak_ {printf("\nValid If Statement");} 
                | IF OPENED_BRACKET Expr_ CLOSED_BRACKET OPENED_BRACE Body_ CLOSED_BRACE ELSE IfBreak_ {printf("\nValid If Statement");}
                | IF OPENED_BRACKET Expr_ CLOSED_BRACKET OPENED_BRACE Body_ CLOSED_BRACE ELSE OPENED_BRACE Body_ BREAK SEMI_COLON CLOSED_BRACE {printf("\nValid If Statement");}
                | IF OPENED_BRACKET Expr_ CLOSED_BRACKET OPENED_BRACE Body_ BREAK SEMI_COLON CLOSED_BRACE ELSE OPENED_BRACE Body_ CLOSED_BRACE {printf("\nValid If Statement");}               
                
                | IF OPENED_BRACKET Expr_ CLOSED_BRACKET OPENED_BRACE Body_ IfBreak_ BREAK SEMI_COLON CLOSED_BRACE {printf("\nValid If Statement");} 
                | IF OPENED_BRACKET Expr_ CLOSED_BRACKET OPENED_BRACE Body_ IfBreak_ BREAK SEMI_COLON CLOSED_BRACE ELSE OPENED_BRACE Body_ IfBreak_ BREAK SEMI_COLON CLOSED_BRACE {printf("\nValid If Statement");} 
                | IF OPENED_BRACKET Expr_ CLOSED_BRACKET OPENED_BRACE Body_ IfBreak_ BREAK SEMI_COLON CLOSED_BRACE ELSE IfStmt_ {printf("\nValid If Statement");}
                | IF OPENED_BRACKET Expr_ CLOSED_BRACKET OPENED_BRACE Body_ IfBreak_ BREAK SEMI_COLON CLOSED_BRACE ELSE IfBreak_ {printf("\nValid If Statement");} 
                | IF OPENED_BRACKET Expr_ CLOSED_BRACKET OPENED_BRACE Body_ IfBreak_ CLOSED_BRACE ELSE IfBreak_ {printf("\nValid If Statement");}
                | IF OPENED_BRACKET Expr_ CLOSED_BRACKET OPENED_BRACE Body_ IfBreak_ CLOSED_BRACE ELSE OPENED_BRACE Body_ IfBreak_ BREAK SEMI_COLON CLOSED_BRACE {printf("\nValid If Statement");}
                | IF OPENED_BRACKET Expr_ CLOSED_BRACKET OPENED_BRACE Body_ IfBreak_ BREAK SEMI_COLON CLOSED_BRACE ELSE OPENED_BRACE Body_ IfBreak_ CLOSED_BRACE {printf("\nValid If Statement");}               
                
                | IF OPENED_BRACKET Expr_ CLOSED_BRACKET OPENED_BRACE Body_ BREAK SEMI_COLON CLOSED_BRACE ELSE OPENED_BRACE Body_ IfBreak_ BREAK SEMI_COLON CLOSED_BRACE {printf("\nValid If Statement");} 
                | IF OPENED_BRACKET Expr_ CLOSED_BRACKET OPENED_BRACE Body_ CLOSED_BRACE ELSE OPENED_BRACE Body_ IfBreak_ BREAK SEMI_COLON CLOSED_BRACE {printf("\nValid If Statement");}
                
                | IF OPENED_BRACKET Expr_ CLOSED_BRACKET OPENED_BRACE Body_ IfBreak_ BREAK SEMI_COLON CLOSED_BRACE ELSE OPENED_BRACE Body_ BREAK SEMI_COLON CLOSED_BRACE {printf("\nValid If Statement");} 
                | IF OPENED_BRACKET Expr_ CLOSED_BRACKET OPENED_BRACE Body_ IfBreak_ CLOSED_BRACE ELSE OPENED_BRACE Body_ BREAK SEMI_COLON CLOSED_BRACE {printf("\nValid If Statement");}
                ;     
        
        BodyLoop_: Body_ | IfBreak_ | IfBreak_ BodyLoop_ | Body_ IfBreak_
                 ;

        WhileStmt_: WHILE OPENED_BRACKET Expr_ CLOSED_BRACKET OPENED_BRACE BodyLoop_ CLOSED_BRACE {printf("\nValid While Statement");} 
                  | WHILE OPENED_BRACKET Expr_ CLOSED_BRACKET OPENED_BRACE CLOSED_BRACE {printf("\nValid While Statement");} 
                  ;    

        ForStmt_: FOR OPENED_BRACKET First_ Second_ Third_ CLOSED_BRACKET OPENED_BRACE BodyLoop_ CLOSED_BRACE {printf("\nValid For Statement");}
                | FOR OPENED_BRACKET First_ Second_ Third_ CLOSED_BRACKET OPENED_BRACE CLOSED_BRACE {printf("\nValid For Statement");}
                ;

        First_: Declaration_ | Assignment_ SEMI_COLON
              ;

        Second_: Expr_ SEMI_COLON
               ;

        Third_: Assignment_
              |Expr2_
              ;   

        DoWhileStmt_: DO OPENED_BRACE BodyLoop_ CLOSED_BRACE WHILE OPENED_BRACKET Expr_ CLOSED_BRACKET SEMI_COLON {printf("\nValid Do while Statement");}
                    | DO OPENED_BRACE CLOSED_BRACE WHILE OPENED_BRACKET Expr_ CLOSED_BRACKET SEMI_COLON {printf("\nValid Do while Statement");}   
                    ;    

        SwitchStmt_: SWITCH OPENED_BRACKET IDENTIFIER CLOSED_BRACKET OPENED_BRACE CaseStmt_ CLOSED_BRACE {printf("\nValid Switch Statement");}   
                   ;

        CaseStmt_: CaseStmt_ DefaultStmt_
                 | DefaultStmt_
                 | CaseStmt_ CASE CaseVal_ TWO_DOTS CaseBody_
                 | CASE CaseVal_ TWO_DOTS CaseBody_  
                 ;

        DefaultStmt_: DEFAULT TWO_DOTS CaseBody_
                    ;      

        CaseVal_: Number_ | Val_ 
                ;

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
  fprintf(stderr,"\nError on line %d : %s",mylineno,msg);
  exit(1);
}


