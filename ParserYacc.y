%{
  #include <stdio.h>
  #include <stdlib.h>
  #include <stdarg.h>
  #include <string.h>
  #include "SymbolTable.c"

  int yylex();
  void yyerror(char *msg);
  extern int mylineno;

  int NumberIdent=0;
  char *IDs[10];
  int n;

  int Scope_= 0;
  int MaxScope=0;
  push(Scope_);

  nodeType * IdenDetected(char *a[], int Type, int Scope, int Num, int Per);
  nodeType * Assign(char* Name, int newValue);
  int Abrev(char* Name, int c,int val);
  nodeType * Assign2(char* Name, bool newValue);
  int getValue(char* Name);

%}

%union{
        int MyintValue;	    /* integer value */
	float MyfloatValue;    /* float value */
	char* MycharValue;    /* char value */
	char* MystringValue;    /* string value*/
	char* Myidentifier;       /* identifier name */
	/*char* Myarrayidentifier;*/
	char* Mycomment;
	nodeType* nPtr;
};

%token <MyintValue> INTVALUE;
%token <MyfloatValue> FLOATVALUE;
%token <MycharValue> CHARVALUE;
%token <MystringValue> STRINGVALUE;
%token <Mycomment> COMMENT;
%token <Myidentifier> IDENTIFIER;
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

%type <MyintValue> Expr_ Number_ Factor_ Math_ Logical_ Term_  Expr2_
%type <nPtr> Declaration_ IdentifierList_ BodyLoop_ WhileStmt_ Assignment_  PLUS_PLUS
%type <MyintValue> datatype
/*%type <nPtr> Math_ Term_ Expr_ Logical_ Factor_ Number_*/

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
                      | VOID IDENTIFIER OPENED_BRACKET CLOSED_BRACKET OPENED_BRACE Body_ CLOSED_BRACE {printf("\nValid Function");}
                      | datatype IDENTIFIER OPENED_BRACKET FnArgs_ CLOSED_BRACKET OPENED_BRACE BodyRtn_ RETURN AllVals_ SEMI_COLON CLOSED_BRACE {printf("\nValid Function");}
                      | datatype IDENTIFIER OPENED_BRACKET CLOSED_BRACKET OPENED_BRACE BodyRtn_ RETURN AllVals_ SEMI_COLON CLOSED_BRACE {printf("\nValid Function");}
                      | datatype OPENED_SQ_BRACKET CLOSED_SQ_BRACKET IDENTIFIER OPENED_BRACKET FnArgs_ CLOSED_BRACKET OPENED_BRACE BodyRtn_ RETURN OPENED_BRACE ArrayListVal_ CLOSED_BRACE SEMI_COLON CLOSED_BRACE {printf("\nValid Function");}
 		        | datatype OPENED_SQ_BRACKET CLOSED_SQ_BRACKET IDENTIFIER OPENED_BRACKET FnArgs_ CLOSED_BRACKET OPENED_BRACE BodyRtn_ RETURN OPENED_BRACE CLOSED_BRACE SEMI_COLON CLOSED_BRACE {printf("\nValid Function");}
		        | datatype OPENED_SQ_BRACKET CLOSED_SQ_BRACKET IDENTIFIER OPENED_BRACKET FnArgs_ CLOSED_BRACKET OPENED_BRACE BodyRtn_ RETURN AllVals_ SEMI_COLON CLOSED_BRACE {printf("\nValid Function");}		
                      | datatype OPENED_SQ_BRACKET CLOSED_SQ_BRACKET IDENTIFIER OPENED_BRACKET CLOSED_BRACKET OPENED_BRACE BodyRtn_ RETURN OPENED_BRACE ArrayListVal_ CLOSED_BRACE SEMI_COLON CLOSED_BRACE {printf("\nValid Function");} 
 		        | datatype OPENED_SQ_BRACKET CLOSED_SQ_BRACKET IDENTIFIER OPENED_BRACKET CLOSED_BRACKET OPENED_BRACE BodyRtn_ RETURN OPENED_BRACE CLOSED_BRACE SEMI_COLON CLOSED_BRACE {printf("\nValid Function");}
		        | datatype OPENED_SQ_BRACKET CLOSED_SQ_BRACKET IDENTIFIER OPENED_BRACKET CLOSED_BRACKET OPENED_BRACE BodyRtn_ RETURN AllVals_ SEMI_COLON CLOSED_BRACE {printf("\nValid Function");}
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
             | Body_ RETURN SEMI_COLON
             | RETURN SEMI_COLON
             ;

        BodyRtn_: BodyRtn_  Declaration_  
                | Declaration_
                | BodyRtn_ Assignment_ SEMI_COLON
                | Assignment_ SEMI_COLON
                | BodyRtn_ FnCall_ SEMI_COLON
                | FnCall_ SEMI_COLON
                | BodyRtn_ Expr2_ SEMI_COLON
                | Expr2_ SEMI_COLON
                | BodyRtn_ IfRtn_
                | IfRtn_
                | BodyRtn_ WhileStmtRtn_
                | WhileStmtRtn_
                | BodyRtn_ ForStmtRtn_
                | ForStmtRtn_
                | BodyRtn_ DoWhileStmtRtn_
                | DoWhileStmtRtn_
                | BodyRtn_ SwitchStmt_
                | SwitchStmt_
                | BodyRtn_ COMMENT
                | COMMENT
                | BodyRtn_ RETURN AllVals_ SEMI_COLON
                | RETURN AllVals_ SEMI_COLON
                ;

        Declaration_: datatype IdentifierList_ SEMI_COLON { printf("\nValid Declaration"); $$ = IdenDetected(IDs, $1, Scope_,NumberIdent, 0); NumberIdent=0;}
                    | CONSTANT datatype IdentifierList_ SEMI_COLON {printf("\nValid Constant Declaration"); $$ = IdenDetected(IDs, $2, Scope_,NumberIdent, 1); NumberIdent=0;}
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

        datatype: INT {$$ = 0;}
		| FLOAT {$$ = 1;}
		| STRING {$$ = 2;}
		| CHAR {$$ = 3;}
		| BOOL {$$ = 4;}
		;            

        IdentifierList_: IDENTIFIER  {IDs[NumberIdent] = $1; NumberIdent++; $$= $1;}
                       | IDENTIFIER COMMA IdentifierList_ {IDs[NumberIdent] = $1;NumberIdent++; $$=$1;}
                       | Assignment_ {$$=$1;}
                       ;

        Assignment_: IDENTIFIER EQUAL Expr_ {if($3==true)$$= Assign2($1, $3);
                                                 else if ($3==false) $$= Assign2($1, $3); 
                                                 else $$= Assign($1, $3);}
                   | IDENTIFIER EQUAL Expr2_ {$$= Assign($1, $3);}
                   |IDENTIFIER EQUAL FnCall_
                   ;

        Val_: STRINGVALUE 
            | CHARVALUE 
            | BOOLVALUE 
            ;

        Number_: INTVALUE {$$=$1;}
               | FLOATVALUE /*{$$=$1;}*/
               ;

        Expr2_: IDENTIFIER PLUS_PLUS {$$=Abrev($1,1,1);}
              | PLUS_PLUS IDENTIFIER {$$=Abrev($2,1,1);}
              | IDENTIFIER MINUS_MINUS{$$=Abrev($1,2,1);}
              | MINUS_MINUS IDENTIFIER {$$=Abrev($2,2,1);}
              |IDENTIFIER PLUS_EQUAL Number_ {$$=Abrev($1,1,$3);}
              |IDENTIFIER MINUS_EQUAL Number_ {$$=Abrev($1,2,$3);}
              |IDENTIFIER MULTIPLY_EQUAL Number_ {$$=Abrev($1,3,$3);}
              |IDENTIFIER DIVIDE_EQUAL Number_ {$$=Abrev($1,4,$3);}
              ;

        Expr_: Logical_ {$$=$1;}/*{printf("result = %f\n", $1);}*/
             ;

        Logical_: Logical_ AND Math_
                | Logical_ OR Math_
                | Logical_ GREATERTHAN Math_ {if($1>$3) $$=true; else $$=false;}
                | Logical_ GREATERTHANOREQUAL Math_ {if($1>=$3) $$=true; else $$=false;}
                | Logical_ SMALLERTHAN Math_ {if($1<$3) $$=true; else $$=false;}
                | Logical_ SMALLERTHANOREQUAL Math_ {if($1<=$3) $$=true; else $$=false;}
                | Logical_ EQUALEQUAL Math_ {if($1==$3) $$=true; else $$=false;}
                | Logical_ NOTEQUAL Math_ {if($1!=$3) $$=true; else $$=false;}
                | NOT Math_
                | Math_ {$$=$1;}
                ;

        Math_: Math_ PLUS Term_ {$$= $1 + $3;}
             | Math_ MINUS Term_ {$$= $1 - $3;}
             | Term_ {$$=$1;}
             ;

        Term_: Term_ MULTIPLY Factor_ {$$= $1 * $3;}
             | Term_ DIVIDE Factor_ {if ($3 == 0.0) yyerror("Divide By Zero"); else $$= $1 / $3;}
             | Factor_ {$$=$1;}
             ;

        Factor_: IDENTIFIER{$$=getValue($1)} | Val_ | Number_ {$$=$1;}| OPENED_BRACKET Logical_ CLOSED_BRACKET 
               | IDENTIFIER OPENED_SQ_BRACKET ArrIndex_ CLOSED_SQ_BRACKET;

        IfStmt_: IF OPENED_BRACKET Expr_ CLOSED_BRACKET OpenedBrace_ Body_ ClosedBrace_ {printf("\nValid If Statement");}
               | IF OPENED_BRACKET Expr_ CLOSED_BRACKET OpenedBrace_ Body_ ClosedBrace_ ELSE OpenedBrace_ Body_ ClosedBrace_ {printf("\nValid If Statement");}
               | IF OPENED_BRACKET Expr_ CLOSED_BRACKET OpenedBrace_ Body_ ClosedBrace_ ELSE IfStmt_ {printf("\nValid If Statement");}
               ;

        IfRtn_: IF OPENED_BRACKET Expr_ CLOSED_BRACKET OpenedBrace_ BodyRtn_ ClosedBrace_ {printf("\nValid If Statement");}
              | IF OPENED_BRACKET Expr_ CLOSED_BRACKET OpenedBrace_ BodyRtn_ ClosedBrace_ ELSE OpenedBrace_ BodyRtn_ ClosedBrace_ {printf("\nValid If Statement");}
              | IF OPENED_BRACKET Expr_ CLOSED_BRACKET OpenedBrace_ BodyRtn_ ClosedBrace_ ELSE IfRtn_ {printf("\nValid If Statement");}
              ;    

       IfBreak_: IF OPENED_BRACKET Expr_ CLOSED_BRACKET OpenedBrace_ BodyLoop_ ClosedBrace_ {printf("\nValid If Statement");} 
               | IF OPENED_BRACKET Expr_ CLOSED_BRACKET OpenedBrace_ BodyLoop_ ClosedBrace_ ELSE OpenedBrace_ BodyLoop_ ClosedBrace_ {printf("\nValid If Statement");} 
               | IF OPENED_BRACKET Expr_ CLOSED_BRACKET OpenedBrace_ BodyLoop_ ClosedBrace_ ELSE IfBreak_ {printf("\nValid If Statement");} 
                ;  

      
       IfBreakRtn_: IF OPENED_BRACKET Expr_ CLOSED_BRACKET OpenedBrace_ BodyLoopRtn_ ClosedBrace_ {printf("\nValid If Statement");} 
               | IF OPENED_BRACKET Expr_ CLOSED_BRACKET OpenedBrace_ BodyLoopRtn_ ClosedBrace_ ELSE OpenedBrace_ BodyLoopRtn_ ClosedBrace_ {printf("\nValid If Statement");} 
               | IF OPENED_BRACKET Expr_ CLOSED_BRACKET OpenedBrace_ BodyLoopRtn_ ClosedBrace_ ELSE IfBreakRtn_ {printf("\nValid If Statement");} 
               ;             
        
        BodyLoop_: BodyLoop_  Declaration_  
             | Declaration_
             | BodyLoop_ Assignment_ SEMI_COLON
             | Assignment_ SEMI_COLON
             | BodyLoop_ FnCall_ SEMI_COLON
             | FnCall_ SEMI_COLON
             | BodyLoop_ Expr2_ SEMI_COLON
             | Expr2_ SEMI_COLON
             
             | BodyLoop_ WhileStmt_
             | WhileStmt_
             | BodyLoop_ ForStmt_
             | ForStmt_
             | BodyLoop_ DoWhileStmt_
             | DoWhileStmt_
             | BodyLoop_ SwitchStmt_
             | SwitchStmt_
             | BodyLoop_ COMMENT
             | COMMENT
             | BodyLoop_ RETURN SEMI_COLON
             | RETURN SEMI_COLON
             | BodyLoop_ BREAK SEMI_COLON
             | BREAK SEMI_COLON
             | BodyLoop_ IfBreak_
             | IfBreak_
             ;

       BodyLoopRtn_: BodyLoopRtn_  Declaration_  
                | Declaration_
                | BodyLoopRtn_ Assignment_ SEMI_COLON
                | Assignment_ SEMI_COLON
                | BodyLoopRtn_ FnCall_ SEMI_COLON
                | FnCall_ SEMI_COLON
                | BodyLoopRtn_ Expr2_ SEMI_COLON
                | Expr2_ SEMI_COLON
                
                | BodyLoopRtn_ WhileStmtRtn_
                | WhileStmtRtn_
                | BodyLoopRtn_ ForStmtRtn_
                | ForStmtRtn_
                | BodyLoopRtn_ DoWhileStmtRtn_
                | DoWhileStmtRtn_
                | BodyLoopRtn_ SwitchStmt_
                | SwitchStmt_
                | BodyLoopRtn_ COMMENT
                | COMMENT
                | BodyLoopRtn_ RETURN AllVals_ SEMI_COLON
                | RETURN AllVals_ SEMI_COLON
                | BodyLoopRtn_ BREAK SEMI_COLON
                | BREAK SEMI_COLON
                | BodyLoopRtn_ IfBreakRtn_
                | IfBreakRtn_
                ;         

        WhileStmt_: WHILE OPENED_BRACKET Expr_ CLOSED_BRACKET OpenedBrace_ BodyLoop_ ClosedBrace_ {printf("\nValid While Statement");} 
                  | WHILE OPENED_BRACKET Expr_ CLOSED_BRACKET OpenedBrace_ ClosedBrace_ {printf("\nValid While Statement");} 
                  ; 

        OpenedBrace_: OPENED_BRACE {MaxScope++; Scope_= MaxScope; push(MaxScope);}
                    ;

        ClosedBrace_: CLOSED_BRACE {pop(); Scope_= peek();}
                    ;                      

       WhileStmtRtn_: WHILE OPENED_BRACKET Expr_ CLOSED_BRACKET OpenedBrace_ BodyLoopRtn_ ClosedBrace_ {printf("\nValid While Statement");} 
                  | WHILE OPENED_BRACKET Expr_ CLOSED_BRACKET OpenedBrace_ ClosedBrace_ {printf("\nValid While Statement");} 
                  ;


        ForStmt_: FOR OPENED_BRACKET First_ Second_ Third_ CLOSED_BRACKET OpenedBrace_ BodyLoop_ ClosedBrace_ {printf("\nValid For Statement");}
                | FOR OPENED_BRACKET First_ Second_ Third_ CLOSED_BRACKET OpenedBrace_ ClosedBrace_ {printf("\nValid For Statement");}
                ;

        ForStmtRtn_: FOR OPENED_BRACKET First_ Second_ Third_ CLOSED_BRACKET OpenedBrace_ BodyLoopRtn_ ClosedBrace_ {printf("\nValid For Statement");}
                | FOR OPENED_BRACKET First_ Second_ Third_ CLOSED_BRACKET OpenedBrace_ ClosedBrace_ {printf("\nValid For Statement");}
                ;        

        First_: Declaration_ | Assignment_ SEMI_COLON
              ;

        Second_: Expr_ SEMI_COLON
               ;

        Third_: Assignment_
              |Expr2_
              ;   

        DoWhileStmt_: DO OpenedBrace_ BodyLoop_ ClosedBrace_ WHILE OPENED_BRACKET Expr_ CLOSED_BRACKET SEMI_COLON {printf("\nValid Do while Statement");}
                    | DO OpenedBrace_ ClosedBrace_ WHILE OPENED_BRACKET Expr_ CLOSED_BRACKET SEMI_COLON {printf("\nValid Do while Statement");}   
                    ; 

        DoWhileStmtRtn_: DO OpenedBrace_ BodyLoopRtn_ ClosedBrace_ WHILE OPENED_BRACKET Expr_ CLOSED_BRACKET SEMI_COLON {printf("\nValid Do while Statement");}
                    | DO OpenedBrace_ ClosedBrace_ WHILE OPENED_BRACKET Expr_ CLOSED_BRACKET SEMI_COLON {printf("\nValid Do while Statement");}   
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

  PrintSymbolTable();
  return yylex();
}

int yywrap(void){
return 1;
}

void yyerror(char *msg){
  fprintf(stderr,"\nError on line %d : %s",mylineno,msg);
  exit(1);
}


nodeType * IdenDetected(char *a[], int Type, int Scope, int Num, int Per){
        printf("Num = %d ", Num);
        printf(a[0]);

        for (int i=0; i<Num; i++){
                if (AlreadyDeclaredInScope(a[i],Scope)!=NULL){
                printf("\nIdentifier with name %s on line %d is already defined in this scope",a[i], mylineno);
                exit(1);
                }

        
                struct SymbolInfo *temp= malloc(sizeof(struct SymbolInfo));  
                temp->Sym_Name = a[i];
                temp->Sym_Type = Type;
                temp->Sym_Scope = Scope;
                temp->Sym_Perm = Per;
                temp->Sym_Init = false;

                printf ("temp name %s", a[i]);
                if (!InsertTable(temp)){
                        printf("\nIdentifier with name %s on line %d and same type is already defined in this scope",a[i], mylineno);
                        exit(1);
                }
        }
        
}

nodeType * Assign(char* Name, int newValue){
        if(!UpdateHash3(Name, newValue)){
                printf("\nIdentifier with name %s on line %d is not declared in this/previous scopes",Name, mylineno);
                exit(1);  
        }
}
nodeType * Assign2(char* Name, bool newValue){
        if(!UpdateHash4(Name, newValue)){
                printf("\nIdentifier with name %s on line %d is not declared in this/previous scopes",Name, mylineno);
                exit(1);  
        }
}
int getValue(char* Name){
        struct SymbolInfo *symbolEntry = SearchByName(Name);
         int newv;
         newv=symbolEntry->Sym_Value.MyintValue;
         return newv;
}
int Abrev(char* Name , int c,int val)
{
         struct SymbolInfo *symbolEntry = SearchByName(Name);
         
         int newv;
        if(c==1)
        {
                newv=symbolEntry->Sym_Value.MyintValue+val;
        }
        else if(c==2)
        {
                newv=symbolEntry->Sym_Value.MyintValue-val;
        }
        else if(c==3)
        {
                newv=symbolEntry->Sym_Value.MyintValue*val;
        }
        else if(c==4)
        {
                newv=symbolEntry->Sym_Value.MyintValue/val;
        }
        if(!UpdateHash3(Name, newv)){
                printf("\nIdentifier with name %s on line %d is not declared in this/previous scopes",Name, mylineno);
                exit(1);  
        }
        return newv;

   
}

