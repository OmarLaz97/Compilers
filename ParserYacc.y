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
  int TypesArray[10];

  int Expr2Type = -1;

  int n;
  int DatatypeId[10];
  int compare=0;

 struct SymbolInfo * TestSymbol = NULL;
  struct SymbolInfo * FounSymbol = NULL;

  int Scope_= -1;
  int MaxScope=-1;
  push(Scope_);

  nodeType * IdenDetected(char *a[], int Type[], int Scope, int Num, int Per);
  nodeType * Assign(char* Name, int newValue);
  nodeType *Test(char* Name, int Per, int Type);
  int gettype(char* Name);
  
  int Abrev(char* Name, int c,int val);
  nodeType * Assign2(char* Name, bool newValue);
  int getValue(char* Name);
  bool getInit(char* Name);

  int ExprTypes[10];
  int indexExpr= 0;

  int LastFunDatatype =-1;

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
%token <MyintValue> BOOLVALUE
%token <Mycomment> COMMENT;
%token <Myidentifier> IDENTIFIER;
%token CONSTANT INT FLOAT STRING CHAR BOOL IF THEN ELSE WHILE DO SWITCH CASE DEFAULT FOR AND OR EQUALEQUAL GREATERTHAN SMALLERTHAN GREATERTHANOREQUAL SMALLERTHANOREQUAL NOT NOTEQUAL VOID MAIN RETURN  
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

%type <MyintValue> Expr_ Number_ Factor_ Math_ Logical_ Term_  Expr2_ AllVals_
%type <nPtr> Declaration_ IdentifierList_ BodyLoop_ WhileStmt_ Assignment_  PLUS_PLUS FnArgs_ ClosedBracket_
%type <MyintValue> datatype Val_
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

        FnDeclaration_: VOID IDENTIFIER OpenedBracket_ FnArgs_ ClosedBracket_ OPENED_BRACE Body_ ClosedBrace_ {printf("\nValid Function");}
                      | VOID IDENTIFIER OpenedBracket_ ClosedBracket_ OPENED_BRACE Body_ ClosedBrace_ {printf("\nValid Function");}
                      | datatype IDENTIFIER OpenedBracket_ FnArgs_ ClosedBracket_ OPENED_BRACE BodyRtn_ RETURN AllVals_ SEMI_COLON ClosedBrace_ {
                                if ($1 != $9){
                                      printf("\nFunction on line %d doesn't return same type", mylineno);
                                      exit(0);
                                }
                                printf("\nValid Function");}
                      | datatype IDENTIFIER OpenedBracket_ ClosedBracket_ OPENED_BRACE BodyRtn_ RETURN AllVals_ SEMI_COLON ClosedBrace_ {
                                if ($1 != $8){
                                      printf("\nFunction on line %d doesn't return same type", mylineno);
                                      exit(0);
                                }
                                printf("\nValid Function");}
                      
                      | datatype OPENED_SQ_BRACKET CLOSED_SQ_BRACKET IDENTIFIER OpenedBracket_ FnArgs_ ClosedBracket_ OPENED_BRACE BodyRtn_ RETURN OPENED_BRACE ArrayListVal_ CLOSED_BRACE SEMI_COLON ClosedBrace_ {printf("\nValid Function");}
 		        | datatype OPENED_SQ_BRACKET CLOSED_SQ_BRACKET IDENTIFIER OpenedBracket_ FnArgs_ ClosedBracket_ OPENED_BRACE BodyRtn_ RETURN OPENED_BRACE CLOSED_BRACE SEMI_COLON ClosedBrace_ {printf("\nValid Function");}
		        | datatype OPENED_SQ_BRACKET CLOSED_SQ_BRACKET IDENTIFIER OpenedBracket_ FnArgs_ ClosedBracket_ OPENED_BRACE BodyRtn_ RETURN AllVals_ SEMI_COLON ClosedBrace_ {printf("\nValid Function");}		
                      | datatype OPENED_SQ_BRACKET CLOSED_SQ_BRACKET IDENTIFIER OpenedBracket_ ClosedBracket_ OPENED_BRACE BodyRtn_ RETURN OPENED_BRACE ArrayListVal_ CLOSED_BRACE SEMI_COLON ClosedBrace_ {printf("\nValid Function");} 
 		        | datatype OPENED_SQ_BRACKET CLOSED_SQ_BRACKET IDENTIFIER OpenedBracket_ ClosedBracket_ OPENED_BRACE BodyRtn_ RETURN OPENED_BRACE CLOSED_BRACE SEMI_COLON ClosedBrace_ {printf("\nValid Function");}
		        | datatype OPENED_SQ_BRACKET CLOSED_SQ_BRACKET IDENTIFIER OpenedBracket_ ClosedBracket_ OPENED_BRACE BodyRtn_ RETURN AllVals_ SEMI_COLON ClosedBrace_ {printf("\nValid Function");}
                      ;

        OpenedBracket_: OPENED_BRACKET {MaxScope++; Scope_= MaxScope; ScopesArray[Scope_]= true; push(MaxScope);}
                    ;
              
        ClosedBracket_: CLOSED_BRACKET {$$ = IdenDetected(IDs, TypesArray, Scope_,NumberIdent, 0); NumberIdent=0;}
                      ;

        FnArgs_: datatype IDENTIFIER COMMA FnArgs_ {IDs[NumberIdent] = $2; TypesArray[NumberIdent] = $1; NumberIdent++;}
               | datatype IDENTIFIER {IDs[NumberIdent] = $2; TypesArray[NumberIdent] = $1; NumberIdent++;}
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
         

        Main_: VOID MAIN OPENED_BRACKET CLOSED_BRACKET OpenedBrace_ Body_ ClosedBrace_ {printf("\nValid Main");}
             | VOID MAIN OPENED_BRACKET CLOSED_BRACKET OPENED_BRACE CLOSED_BRACE {printf("\nValid Main");}
             ;

        Body_: Body_  Declaration_  
             | Declaration_ 
             | Body_ Assignment_ SEMI_COLON {
                        if (TestSymbol != NULL){ //undeclared virtual p=0;
                             if (FounSymbol != NULL){ //previously declared
                                        if (FounSymbol->Sym_Scope != Scope_){
                                                printf("\nSymbol with name %s on line %d not declared in this scope but declared before", TestSymbol->Sym_Name, mylineno);
                                        }
                                       
                                        if (FounSymbol->Sym_Perm== 1 && FounSymbol->Sym_Init == 1){//const and already assigned
                                                printf("\nCannot change the value of Constant %s on line %d", FounSymbol->Sym_Name, mylineno);
                                                exit(0);
                                        }
                                        else{   
                                                if (compare == 0){
                                                        for (int i=0; i<indexExpr; i++){
                                                        if (FounSymbol->Sym_Type != DatatypeId[i]){//check type
                                                        printf("\nValue of identifier %s on line %d is not of the same type", FounSymbol->Sym_Name, mylineno);
                                                        exit(0);
                                                        }
                                                        }
                                                }
                                                else{
                                                        compare = 0;
                                                        for (int i=0; i<indexExpr-1; i++){
                                                                if (FounSymbol->Sym_Type != 4 || DatatypeId[i]!=DatatypeId[i+1]){//check type
                                                                printf("\nValue of identifier %s on line %d is not of the same type", FounSymbol->Sym_Name, mylineno);
                                                                exit(0);
                                                                }
                                                        }
                                                }
                                                
                                                indexExpr=0;
                                                
                                                FounSymbol->Sym_Value.MyintValue = TestSymbol->Sym_Value.MyintValue;
                                                FounSymbol->Sym_Init = TestSymbol->Sym_Init;
                                                Delete(TestSymbol);
                                                TestSymbol = NULL; 
                                                NumberIdent=0;
                                                FounSymbol = NULL;
                                        }
                             }
                             else { //not declared at all
                                printf("\nSymbol with name %s on line %d not declared", TestSymbol->Sym_Name, mylineno); 
                                Delete(TestSymbol);
                                TestSymbol = NULL; 
                                NumberIdent=0;
                                exit(0);
                             }
                             
                        }
                }
             
             | Assignment_ SEMI_COLON {
                        if (TestSymbol != NULL){ //undeclared virtual p=0;
                                if (FounSymbol != NULL){ //previously declared
                                        if (FounSymbol->Sym_Scope != Scope_){
                                                printf("\nSymbol with name %s on line %d not declared in this scope but declared before", TestSymbol->Sym_Name, mylineno);
                                        }
                                        
                                        if (FounSymbol->Sym_Perm== 1 && FounSymbol->Sym_Init == 1){//const and already assigned
                                                printf("\nCannot change the value of Constant %s on line %d", FounSymbol->Sym_Name, mylineno);
                                                exit(0);
                                        }
                                        else{
                                               
                                                if(compare==0)
                                                {
                                                        for (int i=0; i<indexExpr; i++){
                                                                if (FounSymbol->Sym_Type != DatatypeId[i]){//check type
                                                                        printf("\nValue of identifier %s on line %d is not of the same type", FounSymbol->Sym_Name, mylineno);
                                                                        exit(0);
                                                                }
                                                        }
                                                }
                                                else //compare = 1
                                                {
                                                        for (int i=0; i<indexExpr-1; i++){
                                                             if (FounSymbol->Sym_Type!=4 ||  DatatypeId[i]!= DatatypeId[i+1]){//check type
                                                                printf("\nValue of identifier %s on line %d is not of the same type", FounSymbol->Sym_Name, mylineno);
                                                                exit(0);
                                                                }    
                                                        }
                                                }
                                                compare=0;
                                                indexExpr=0;
                                                FounSymbol->Sym_Value.MyintValue = TestSymbol->Sym_Value.MyintValue;
                                                FounSymbol->Sym_Init = TestSymbol->Sym_Init;
                                                Delete(TestSymbol);
                                                TestSymbol = NULL; 
                                                NumberIdent=0;
                                                FounSymbol = NULL;
                                        }        
                             }
                             else { //not declared at all
                                printf("\nSymbol with name %s on line %d not declared", TestSymbol->Sym_Name, mylineno); 
                                Delete(TestSymbol);
                                TestSymbol = NULL; 
                                NumberIdent=0;
                                exit(0);
                             }
                        }
                }
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
                | BodyRtn_ Assignment_ SEMI_COLON {
                        if (TestSymbol != NULL){ //undeclared virtual p=0;
                             if (FounSymbol != NULL){ //previously declared
                                        if (FounSymbol->Sym_Scope != Scope_){
                                                printf("\nSymbol with name %s on line %d not declared in this scope but declared before", TestSymbol->Sym_Name, mylineno);
                                        }
                                        
                                        if (FounSymbol->Sym_Perm== 1 && FounSymbol->Sym_Init == 1){//const and already assigned
                                                printf("\nCannot change the value of Constant %s on line %d", FounSymbol->Sym_Name, mylineno);
                                                exit(0);
                                        }
                                        else{   
                                                if (compare == 0){
                                                        for (int i=0; i<indexExpr; i++){
                                                        if (FounSymbol->Sym_Type != DatatypeId[i]){//check type
                                                        printf("\nValue of identifier %s on line %d is not of the same type", FounSymbol->Sym_Name, mylineno);
                                                        exit(0);
                                                        }
                                                        }
                                                }
                                                else{
                                                        compare = 0;
                                                        for (int i=0; i<indexExpr-1; i++){
                                                                if (FounSymbol->Sym_Type != 4 || DatatypeId[i]!=DatatypeId[i+1]){//check type
                                                                printf("\nValue of identifier %s on line %d is not of the same type", FounSymbol->Sym_Name, mylineno);
                                                                exit(0);
                                                                }
                                                        }
                                                }
                                                
                                                indexExpr=0;
                                                
                                                FounSymbol->Sym_Value.MyintValue = TestSymbol->Sym_Value.MyintValue;
                                                FounSymbol->Sym_Init = TestSymbol->Sym_Init;
                                                Delete(TestSymbol);
                                                TestSymbol = NULL; 
                                                NumberIdent=0;
                                                FounSymbol = NULL;
                                        }
                             }
                             else { //not declared at all
                                printf("\nSymbol with name %s on line %d not declared", TestSymbol->Sym_Name, mylineno); 
                                Delete(TestSymbol);
                                TestSymbol = NULL; 
                                NumberIdent=0;
                                exit(0);
                             }
                             
                        }
                }
             
             | Assignment_ SEMI_COLON {
                        if (TestSymbol != NULL){ //undeclared virtual p=0;
                                if (FounSymbol != NULL){ //previously declared
                                        if (FounSymbol->Sym_Scope != Scope_){
                                                printf("\nSymbol with name %s on line %d not declared in this scope but declared before", TestSymbol->Sym_Name, mylineno);
                                        }
                                        
                                        if (FounSymbol->Sym_Perm== 1 && FounSymbol->Sym_Init == 1){//const and already assigned
                                                printf("\nCannot change the value of Constant %s on line %d", FounSymbol->Sym_Name, mylineno);
                                                exit(0);
                                        }
                                        else{
                                               
                                                if(compare==0)
                                                {
                                                        for (int i=0; i<indexExpr; i++){
                                                                if (FounSymbol->Sym_Type != DatatypeId[i]){//check type
                                                                        printf("\nValue of identifier %s on line %d is not of the same type", FounSymbol->Sym_Name, mylineno);
                                                                        exit(0);
                                                                }
                                                        }
                                                }
                                                else //compare = 1
                                                {
                                                        for (int i=0; i<indexExpr-1; i++){
                                                             if (FounSymbol->Sym_Type!=4 ||  DatatypeId[i]!= DatatypeId[i+1]){//check type
                                                                printf("\nValue of identifier %s on line %d is not of the same type", FounSymbol->Sym_Name, mylineno);
                                                                exit(0);
                                                                }    
                                                        }
                                                }
                                                compare=0;
                                                indexExpr=0;
                                                FounSymbol->Sym_Value.MyintValue = TestSymbol->Sym_Value.MyintValue;
                                                FounSymbol->Sym_Init = TestSymbol->Sym_Init;
                                                Delete(TestSymbol);
                                                TestSymbol = NULL; 
                                                NumberIdent=0;
                                                FounSymbol = NULL;
                                        }        
                             }
                             else { //not declared at all
                                printf("\nSymbol with name %s on line %d not declared", TestSymbol->Sym_Name, mylineno); 
                                Delete(TestSymbol);
                                TestSymbol = NULL; 
                                NumberIdent=0;
                                exit(0);
                             }
                        }
                }

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

        Declaration_: datatype IdentifierList_ SEMI_COLON { 
                                                if(TestSymbol == NULL) { //no virtual is created
                                                        for (int i=0; i < NumberIdent; i++){
                                                                TypesArray[i] = $1;
                                                        }
                                                        $$ = IdenDetected(IDs, TypesArray, Scope_,NumberIdent, 0); 
                                                        TestSymbol = NULL;
                                                        indexExpr=0;
                                                        NumberIdent=0;
                                                }
                                                else { //fih virtual, fi assignmnett
                                                        if (FounSymbol == NULL){ //not found before
                                                       
                                                                
                                                                if(compare==0){
                                                                        for (int i=0; i<indexExpr; i++){
                                                                                if ($1 != DatatypeId[i]){//check datatype
                                                                                        printf("\nThe value of identifier %s on line %d is not of the same type\n", TestSymbol->Sym_Name, mylineno);
                                                                                        Delete(TestSymbol);        
                                                                                        TestSymbol = NULL; 
                                                                                        NumberIdent=0;
                                                                                        exit(0);
                                                                                }
                                                                        }
                                                                }
                                                                else if(compare==1){
                                                                        for (int i=0; i<indexExpr-1; i++){
                                                                                if(DatatypeId[i]!=DatatypeId[i+1] || $1!=4)
                                                                                {
                                                                                        printf("\nThe value of identifier %s on line %d is not of the same type\n", TestSymbol->Sym_Name, mylineno);
                                                                                        Delete(TestSymbol);        
                                                                                        TestSymbol = NULL; 
                                                                                        NumberIdent=0;
                                                                                        exit(0);
                                                                                }
                                                                        }
                                                                }
                                                                
                                                                compare=0;
                                                                indexExpr=0;
                                                                $$ = Test(IDs[0], 0, $1);
                                                                TestSymbol = NULL;
                                                                NumberIdent=0;
                                                        }
                                                        else { //found before
                                                                if (TestSymbol->Sym_Scope == FounSymbol->Sym_Scope){
                                                                printf("\nAlready declared in same scope\n");
                                                                exit(0);
                                                                }
                                                                //not same scope
                                                                for (int i=0; i<indexExpr; i++){
                                                                        if(compare==0)
                                                                        {
                                                                        if ($1 != DatatypeId[i]){//check datatype
                                                                                printf("\nThe value of identifier %s on line %d is not of the same type\n", TestSymbol->Sym_Name, mylineno);
                                                                                Delete(TestSymbol);
                                                                                TestSymbol = NULL; 
                                                                                NumberIdent=0;
                                                                                exit(0);
                                                                        }
                                                                        }
                                                                        else
                                                                        {
                                                                                if(DatatypeId[i]!=DatatypeId[i+1] || $1!=4)
                                                                                {
                                                                                        printf("\nThe value of identifier %s on line %d is not of the same type\n", TestSymbol->Sym_Name, mylineno);
                                                                                Delete(TestSymbol);        
                                                                                TestSymbol = NULL; 
                                                                                NumberIdent=0;
                                                                                exit(0);
                                                                                }
                                                                        }
                                                                }
                                                                indexExpr=0;
                                                                $$ = Test(IDs[0], 0, $1);
                                                                TestSymbol = NULL;
                                                                NumberIdent=0;
                                                                compare=0;
                                                        }
                                                }
                                                        printf("\nValid Declaration");
                                                }
                    | CONSTANT datatype IdentifierList_ SEMI_COLON { 
                                                if(TestSymbol == NULL) { //no virtual is created
                                                        for (int i=0; i < NumberIdent; i++){
                                                                TypesArray[i] = $2;
                                                        }
                                                        $$ = IdenDetected(IDs, TypesArray, Scope_,NumberIdent, 1); 
                                                        TestSymbol = NULL;
                                                        indexExpr=0;
                                                        NumberIdent=0;
                                                }
                                                else { //fih virtual, fi assignmnett
                                                        if (FounSymbol == NULL){
                                                                for (int i=0; i<indexExpr; i++){
                                                                        if ($2 != DatatypeId[i]){//check datatype
                                                                                printf("\nThe value of identifier %s on line %d is not of the same type\n", TestSymbol->Sym_Name, mylineno);
                                                                                Delete(TestSymbol);
                                                                                TestSymbol = NULL; 
                                                                                NumberIdent=0;
                                                                                exit(0);
                                                                        }
                                                                }
                                                                indexExpr =0;
                                                                $$ = Test(IDs[0], 1, $2);
                                                                TestSymbol = NULL;
                                                                NumberIdent=0;
                                                        }
                                                        else {
                                                                if (TestSymbol->Sym_Scope == FounSymbol->Sym_Scope){
                                                                printf("\nDeclared in same scope");
                                                                exit(0);
                                                                }
                                                                //not same scope
                                                                for (int i=0; i<indexExpr;i++){
                                                                        if ($2 != DatatypeId[i]){//check datatype
                                                                                printf("\nThe value of identifier %s on line %d is not of the same type\n", TestSymbol->Sym_Name, mylineno);
                                                                                Delete(TestSymbol);
                                                                                TestSymbol = NULL; 
                                                                                NumberIdent=0;
                                                                                exit(0);
                                                                        }
                                                                }
                                                                indexExpr=0;
                                                                $$ = Test(IDs[0], 1, $2);
                                                                TestSymbol = NULL;
                                                                NumberIdent=0;
                                                        } 
                                                }
                                                        printf("\nValid Declaration");
                                                }
                                        
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

        Assignment_: IDENTIFIER EQUAL Expr_ {IDs[NumberIdent] = $1; NumberIdent++; $$= Assign($1, $3);}
                   | IDENTIFIER EQUAL Expr2_ {int TestType= gettype($1);
                                                if (TestType != Expr2Type){
                                                        printf("\nThe value of identifier %s on line %d is not of the same type..\n", $1, mylineno);
                                                        exit(0);
                                                }
                                                Expr2Type = -1;
                                                $$= Assign($1, $3);}
                   |IDENTIFIER EQUAL FnCall_
                   ;

        Val_: STRINGVALUE {DatatypeId[indexExpr]= 2; indexExpr++; $$=$1;}
            | CHARVALUE {DatatypeId[indexExpr]= 3; indexExpr++; $$=$1;}
            | BOOLVALUE {DatatypeId[indexExpr]= 4; indexExpr++; $$=$1;}
            ;

        Number_: INTVALUE {pushQ();DatatypeId[indexExpr] =0; indexExpr++; $$=$1;}
               | FLOATVALUE {pushQ();DatatypeId[indexExpr] =1; indexExpr++; $$=$1;}
               ;

        Expr2_: IDENTIFIER PLUS_PLUS {codegen_single("ADD", $1, 1);Expr2Type= gettype($1); $$=Abrev($1,1,1);}
              | PLUS_PLUS IDENTIFIER {codegen_single("ADD", $2, 1);Expr2Type= gettype($2); $$=Abrev($2,1,1);}
              | IDENTIFIER MINUS_MINUS{codegen_single("SUB", $1, 1); Expr2Type= gettype($1); $$=Abrev($1,2,1);}
              | MINUS_MINUS IDENTIFIER {codegen_single("SUB", $2, 1); Expr2Type= gettype($2); $$=Abrev($2,2,1);}
              |IDENTIFIER PLUS_EQUAL Number_ {codegen_single("ADD", $1, $3);int typeIdtnt= gettype($1); 
                                                int numtype= DatatypeId[indexExpr-1]; 
                                                 if (typeIdtnt != numtype){
                                                        printf("\nThe value of identifier %s on line %d is not of the same type..\n", $1, mylineno);
                                                        exit(0);
                                                }
                                               indexExpr=0;
                                                $$=Abrev($1,1,$3);}
              |IDENTIFIER MINUS_EQUAL Number_ {codegen_single("SUB", $1, $3); int typeIdtnt= gettype($1); 
                                                int numtype= DatatypeId[indexExpr-1]; 
                                                 if (typeIdtnt != numtype){
                                                        printf("\nThe value of identifier %s on line %d is not of the same type..\n", $1, mylineno);
                                                        exit(0);
                                                }
                                               indexExpr=0;$$=Abrev($1,2,$3);}
              |IDENTIFIER MULTIPLY_EQUAL Number_ {codegen_single("MUL", $1, $3); int typeIdtnt= gettype($1); 
                                                int numtype= DatatypeId[indexExpr-1]; 
                                                 if (typeIdtnt != numtype){
                                                        printf("\nThe value of identifier %s on line %d is not of the same type..\n", $1, mylineno);
                                                        exit(0);
                                                }
                                               indexExpr=0;
                                               $$=Abrev($1,3,$3);}
                |IDENTIFIER DIVIDE_EQUAL Number_ {codegen_single("DIV", $1, $3); int typeIdtnt= gettype($1); 
                                                int numtype= DatatypeId[indexExpr-1]; 
                                                 if (typeIdtnt != numtype){
                                                        printf("\nThe value of identifier %s on line %d is not of the same type..\n", $1, mylineno);
                                                        exit(0);
                                                }
                                               indexExpr=0;
                                               $$=Abrev($1,4,$3);}                               
              ;

        Expr_: Logical_ {$$=$1;}
             ;

        Logical_: Logical_ AND Math_
                | Logical_ OR Math_
                | Logical_ GREATERTHAN Math_ {if($1>$3) $$=true; else $$=false; compare=1;}
                | Logical_ GREATERTHANOREQUAL Math_ {if($1>=$3) $$=true; else $$=false; compare=1;}
                | Logical_ SMALLERTHAN Math_ {if($1<$3) $$=true; else $$=false;compare=1;}
                | Logical_ SMALLERTHANOREQUAL Math_ {if($1<=$3) $$=true; else $$=false;compare=1;}
                | Logical_ EQUALEQUAL Math_ {if($1==$3) $$=true; else $$=false;compare=1;}
                | Logical_ NOTEQUAL Math_ {if($1!=$3) $$=true; else $$=false;compare=1;}
                | NOT Math_
                | Math_ {$$=$1;}
                ;

        Math_: Math_ PLUS Term_ {pushS("ADD"); codegen(); $$= $1 + $3;}
             | Math_ MINUS Term_ {pushS("SUB"); codegen(); $$= $1 - $3;}
             | Term_ {$$=$1;}
             ;

        Term_: Term_ MULTIPLY Factor_ {pushS("MUL"); codegen();$$= $1 * $3;}
             | Term_ DIVIDE Factor_ {pushS("DIV");codegen();  if ($3 == 0.0) yyerror("Divide By Zero"); else $$= $1 / $3;}
             | Factor_ {$$=$1;}
             ;

        Factor_: IDENTIFIER { pushS($1); DatatypeId[indexExpr] =gettype($1); indexExpr++;if(getInit($1)) $$=getValue($1);
                             else  yyerror("Identifier not initialized");  } 
                | Val_ {$$=$1;}
                | Number_ {$$=$1;}
                | OPENED_BRACKET Logical_ CLOSED_BRACKET 
               | IDENTIFIER OPENED_SQ_BRACKET ArrIndex_ CLOSED_SQ_BRACKET;

        IfStmt_: IF OPENED_BRACKET Expr_ ClosedBracket2_ OpenedBrace_ Body_ ClosedBrace_ { printf("\nValid If Statement");}
               | IF OPENED_BRACKET Expr_ ClosedBracket2_ OpenedBrace_ Body_ ClosedBrace_ ELSE OpenedBrace_ Body_ ClosedBrace_ {printf("\nValid If Statement");}
               | IF OPENED_BRACKET Expr_ ClosedBracket2_ OpenedBrace_ Body_ ClosedBrace_ ELSE IfStmt_ {printf("\nValid If Statement");}
               ;

        ClosedBracket2_ : CLOSED_BRACKET {indexExpr=0;}       

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
             | BodyLoop_ Assignment_ SEMI_COLON {
                        if (TestSymbol != NULL){ //undeclared virtual p=0;
                             if (FounSymbol != NULL){ //previously declared
                                        if (FounSymbol->Sym_Scope != Scope_){
                                                printf("\nSymbol with name %s on line %d not declared in this scope but declared before\n", TestSymbol->Sym_Name, mylineno);
                                        }
                                       
                                        if (FounSymbol->Sym_Perm== 1 && FounSymbol->Sym_Init == 1){//const and already assigned
                                                printf("\nCannot change the value of Constant %s on line %d", FounSymbol->Sym_Name, mylineno);
                                                exit(0);
                                        }
                                        else{   
                                                if (compare == 0){
                                                        for (int i=0; i<indexExpr; i++){
                                                        if (FounSymbol->Sym_Type != DatatypeId[i]){//check type
                                                        printf("\nValue of identifier %s on line %d is not of the same type\n", FounSymbol->Sym_Name, mylineno);
                                                        exit(0);
                                                        }
                                                        }
                                                }
                                                else{
                                                        compare = 0;
                                                        for (int i=0; i<indexExpr-1; i++){
                                                                if (FounSymbol->Sym_Type != 4 || DatatypeId[i]!=DatatypeId[i+1]){//check type
                                                                printf("\nValue of identifier %s on line %d is not of the same type\n", FounSymbol->Sym_Name, mylineno);
                                                                exit(0);
                                                                }
                                                        }
                                                }
                                                
                                                indexExpr=0;
                                                
                                                FounSymbol->Sym_Value.MyintValue = TestSymbol->Sym_Value.MyintValue;
                                                FounSymbol->Sym_Init = TestSymbol->Sym_Init;
                                                Delete(TestSymbol);
                                                TestSymbol = NULL; 
                                                NumberIdent=0;
                                                FounSymbol = NULL;
                                        }
                             }
                             else { //not declared at all
                                printf("\nSymbol with name %s on line %d not declared", TestSymbol->Sym_Name, mylineno); 
                                Delete(TestSymbol);
                                TestSymbol = NULL; 
                                NumberIdent=0;
                                exit(0);
                             }
                             
                        }
                }
             
             | Assignment_ SEMI_COLON {
                        if (TestSymbol != NULL){ //undeclared virtual p=0;
                                if (FounSymbol != NULL){ //previously declared
                                        if (FounSymbol->Sym_Scope != Scope_){
                                                printf("\nSymbol with name %s on line %d not declared in this scope but declared before\n", TestSymbol->Sym_Name, mylineno);
                                        }
                                        
                                        if (FounSymbol->Sym_Perm== 1 && FounSymbol->Sym_Init == 1){//const and already assigned
                                                printf("\nCannot change the value of Constant %s on line %d", FounSymbol->Sym_Name, mylineno);
                                                exit(0);
                                        }
                                        else{
                                               
                                                if(compare==0)
                                                {
                                                        for (int i=0; i<indexExpr; i++){
                                                                if (FounSymbol->Sym_Type != DatatypeId[i]){//check type
                                                                        printf("\nValue of identifier %s on line %d is not of the same type\n", FounSymbol->Sym_Name, mylineno);
                                                                        exit(0);
                                                                }
                                                        }
                                                }
                                                else //compare = 1
                                                {
                                                        for (int i=0; i<indexExpr-1; i++){
                                                             if (FounSymbol->Sym_Type!=4 ||  DatatypeId[i]!= DatatypeId[i+1]){//check type
                                                                printf("\nValue of identifier %s on line %d is not of the same type\n", FounSymbol->Sym_Name, mylineno);
                                                                exit(0);
                                                                }    
                                                        }
                                                }
                                                compare=0;
                                                indexExpr=0;
                                                FounSymbol->Sym_Value.MyintValue = TestSymbol->Sym_Value.MyintValue;
                                                FounSymbol->Sym_Init = TestSymbol->Sym_Init;
                                                Delete(TestSymbol);
                                                TestSymbol = NULL; 
                                                NumberIdent=0;
                                                FounSymbol = NULL;
                                        }        
                             }
                             else { //not declared at all
                                printf("\nSymbol with name %s on line %d not declared", TestSymbol->Sym_Name, mylineno); 
                                Delete(TestSymbol);
                                TestSymbol = NULL; 
                                NumberIdent=0;
                                exit(0);
                             }
                        }
                }

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
                | BodyLoopRtn_ Assignment_ SEMI_COLON {
                        if (TestSymbol != NULL){ //undeclared virtual p=0;
                             if (FounSymbol != NULL){ //previously declared
                                        if (FounSymbol->Sym_Scope != Scope_){
                                                printf("\nSymbol with name %s on line %d not declared in this scope but declared before\n", TestSymbol->Sym_Name, mylineno);
                                        }
                                        
                                        if (FounSymbol->Sym_Perm== 1 && FounSymbol->Sym_Init == 1){//const and already assigned
                                                printf("\nCannot change the value of Constant %s on line %d", FounSymbol->Sym_Name, mylineno);
                                                exit(0);
                                        }
                                        else{   
                                                if (compare == 0){
                                                        for (int i=0; i<indexExpr; i++){
                                                        if (FounSymbol->Sym_Type != DatatypeId[i]){//check type
                                                        printf("\nValue of identifier %s on line %d is not of the same type\n", FounSymbol->Sym_Name, mylineno);
                                                        exit(0);
                                                        }
                                                        }
                                                }
                                                else{
                                                        compare = 0;
                                                        for (int i=0; i<indexExpr-1; i++){
                                                                if (FounSymbol->Sym_Type != 4 || DatatypeId[i]!=DatatypeId[i+1]){//check type
                                                                printf("\nValue of identifier %s on line %d is not of the same type\n", FounSymbol->Sym_Name, mylineno);
                                                                exit(0);
                                                                }
                                                        }
                                                }
                                                
                                                indexExpr=0;
                                                
                                                FounSymbol->Sym_Value.MyintValue = TestSymbol->Sym_Value.MyintValue;
                                                FounSymbol->Sym_Init = TestSymbol->Sym_Init;
                                                Delete(TestSymbol);
                                                TestSymbol = NULL; 
                                                NumberIdent=0;
                                                FounSymbol = NULL;
                                        }
                             }
                             else { //not declared at all
                                printf("\nSymbol with name %s on line %d not declared", TestSymbol->Sym_Name, mylineno); 
                                Delete(TestSymbol);
                                TestSymbol = NULL; 
                                NumberIdent=0;
                                exit(0);
                             }
                             
                        }
                }
             
             | Assignment_ SEMI_COLON {
                        if (TestSymbol != NULL){ //undeclared virtual p=0;
                                if (FounSymbol != NULL){ //previously declared
                                        if (FounSymbol->Sym_Scope != Scope_){
                                                printf("\nSymbol with name %s on line %d not declared in this scope but declared before\n", TestSymbol->Sym_Name, mylineno);
                                        }
                                          
                                        if (FounSymbol->Sym_Perm== 1 && FounSymbol->Sym_Init == 1){//const and already assigned
                                                printf("\nCannot change the value of Constant %s on line %d", FounSymbol->Sym_Name, mylineno);
                                                exit(0);
                                        }
                                        else{
                                               
                                                if(compare==0)
                                                {
                                                        for (int i=0; i<indexExpr; i++){
                                                                if (FounSymbol->Sym_Type != DatatypeId[i]){//check type
                                                                        printf("\nValue of identifier %s on line %d is not of the same type\n", FounSymbol->Sym_Name, mylineno);
                                                                        exit(0);
                                                                }
                                                        }
                                                }
                                                else //compare = 1
                                                {
                                                        for (int i=0; i<indexExpr-1; i++){
                                                             if (FounSymbol->Sym_Type!=4 ||  DatatypeId[i]!= DatatypeId[i+1]){//check type
                                                                printf("\nValue of identifier %s on line %d is not of the same type\n", FounSymbol->Sym_Name, mylineno);
                                                                exit(0);
                                                                }    
                                                        }
                                                }
                                                compare=0;
                                                indexExpr=0;
                                                FounSymbol->Sym_Value.MyintValue = TestSymbol->Sym_Value.MyintValue;
                                                FounSymbol->Sym_Init = TestSymbol->Sym_Init;
                                                Delete(TestSymbol);
                                                TestSymbol = NULL; 
                                                NumberIdent=0;
                                                FounSymbol = NULL;
                                        }        
                             }
                             else { //not declared at all
                                printf("\nSymbol with name %s on line %d not declared", TestSymbol->Sym_Name, mylineno); 
                                Delete(TestSymbol);
                                TestSymbol = NULL; 
                                NumberIdent=0;
                                exit(0);
                             }
                        }
                }

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

        OpenedBrace_: OPENED_BRACE {MaxScope++; Scope_= MaxScope; ScopesArray[Scope_]= true; push(MaxScope);}
                    ;

        ClosedBrace_: CLOSED_BRACE {ScopesArray[Scope_]= false; pop(); Scope_= peek();}
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

        First_: Declaration_ 
                | Assignment_ SEMI_COLON {{
                        if (TestSymbol != NULL){ //undeclared virtual p=0;
                                if (FounSymbol != NULL){ //previously declared
                                        if (FounSymbol->Sym_Scope != Scope_){
                                                printf("\nSymbol with name %s on line %d not declared in this scope but declared before\n", TestSymbol->Sym_Name, mylineno);
                                        }
                                         
                                        if (FounSymbol->Sym_Perm== 1 && FounSymbol->Sym_Init == 1){//const and already assigned
                                                printf("\nCannot change the value of Constant %s on line %d", FounSymbol->Sym_Name, mylineno);
                                                exit(0);
                                        }
                                        else{
                                               
                                                if(compare==0)
                                                {
                                                        for (int i=0; i<indexExpr; i++){
                                                                if (FounSymbol->Sym_Type != DatatypeId[i]){//check type
                                                                        printf("\nValue of identifier %s on line %d is not of the same type\n", FounSymbol->Sym_Name, mylineno);
                                                                        exit(0);
                                                                }
                                                        }
                                                }
                                                else //compare = 1
                                                {
                                                        for (int i=0; i<indexExpr-1; i++){
                                                             if (FounSymbol->Sym_Type!=4 ||  DatatypeId[i]!= DatatypeId[i+1]){//check type
                                                                printf("\nValue of identifier %s on line %d is not of the same type\n", FounSymbol->Sym_Name, mylineno);
                                                                exit(0);
                                                                }    
                                                        }
                                                }
                                                compare=0;
                                                indexExpr=0;
                                                FounSymbol->Sym_Value.MyintValue = TestSymbol->Sym_Value.MyintValue;
                                                FounSymbol->Sym_Init = TestSymbol->Sym_Init;
                                                Delete(TestSymbol);
                                                TestSymbol = NULL; 
                                                NumberIdent=0;
                                                FounSymbol = NULL;
                                        }        
                             }
                             else { //not declared at all
                                printf("\nSymbol with name %s on line %d not declared", TestSymbol->Sym_Name, mylineno); 
                                Delete(TestSymbol);
                                TestSymbol = NULL; 
                                NumberIdent=0;
                                exit(0);
                             }
                        }
                }}
              ;

        Second_: Expr_ SEMI_COLON {if (compare ==1){
                
                                        for (int i=0; i<indexExpr-1; i++){
                                                if(DatatypeId[i]!=DatatypeId[i+1])
                                                {
                                                        printf("\nThe value of identifier on line %d in for loop is not of the same type\n", mylineno);
                                                        
                                                        exit(0);
                                                }
                                        }
                                        NumberIdent=0;
                                        indexExpr=0;
                                        compare=0;
                                        }
                                }        
               ;

        Third_: Assignment_ {{
                        if (TestSymbol != NULL){ //undeclared virtual p=0;
                                if (FounSymbol != NULL){ //previously declared
                                        if (FounSymbol->Sym_Scope != Scope_){
                                                printf("\nSymbol with name %s on line %d not declared in this scope but declared before\n", TestSymbol->Sym_Name, mylineno);
                                        }
                                         
                                        if (FounSymbol->Sym_Perm== 1 && FounSymbol->Sym_Init == 1){//const and already assigned
                                                printf("\nCannot change the value of Constant %s on line %d", FounSymbol->Sym_Name, mylineno);
                                                exit(0);
                                        }
                                        else{
                                               
                                                if(compare==0)
                                                {
                                                        for (int i=0; i<indexExpr; i++){
                                                                if (FounSymbol->Sym_Type != DatatypeId[i]){//check type
                                                                        printf("\nValue of identifier %s on line %d is not of the same type\n", FounSymbol->Sym_Name, mylineno);
                                                                        exit(0);
                                                                }
                                                        }
                                                }
                                                else //compare = 1
                                                {
                                                        for (int i=0; i<indexExpr-1; i++){
                                                             if (FounSymbol->Sym_Type!=4 ||  DatatypeId[i]!= DatatypeId[i+1]){//check type
                                                                printf("\nValue of identifier %s on line %d is not of the same type\n", FounSymbol->Sym_Name, mylineno);
                                                                exit(0);
                                                                }    
                                                        }
                                                }
                                                compare=0;
                                                indexExpr=0;
                                                FounSymbol->Sym_Value.MyintValue = TestSymbol->Sym_Value.MyintValue;
                                                FounSymbol->Sym_Init = TestSymbol->Sym_Init;
                                                Delete(TestSymbol);
                                                TestSymbol = NULL; 
                                                NumberIdent=0;
                                                FounSymbol = NULL;
                                        }        
                             }
                             else { //not declared at all
                                printf("\nSymbol with name %s on line %d not declared", TestSymbol->Sym_Name, mylineno); 
                                Delete(TestSymbol);
                                TestSymbol = NULL; 
                                NumberIdent=0;
                                exit(0);
                             }
                        }
                }}
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

        AllVals_: Number_ | Val_ | IDENTIFIER {$$= gettype($1);}
                ;        
                                                         
%%

#include"lex.yy.c"
#include<ctype.h>
char st[100][10];
int topQ=0;
//char i_[2]="0";
char tempV[3]="t0"; 
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
  exit(0);
}

pushQ()
{
strcpy(st[++topQ],yytext);
}
pushS( char* val)
{
strcpy(st[++topQ],val);
}
codegen()
{ FILE *f = fopen("file.txt", "a");
// strcpy(temp,"t");
// strcat(temp,i_);
fprintf(f," %s  %s %s %s\n",st[topQ],tempV,st[topQ-2],st[topQ-1]);
fclose(f);
topQ-=2;
strcpy(st[topQ],tempV);
tempV[1]++;
}
codegen_umin()
{
// strcpy(temp,"t");
// strcat(temp,i_);
printf("%s = -%s\n",tempV,st[topQ]);
topQ--;
strcpy(st[topQ],tempV);
tempV[1]++;
}
codegen_single(char* operation, char* Identifier, int value ){
      
      
FILE *f = fopen("file.txt", "a");

fprintf(f," %s  %s %s %d\n",operation,Identifier,Identifier,value);
fclose(f);
}
codegen_assign()
{
printf("Load %s  %s\n",st[topQ-2],st[topQ]);
topQ-=2;
}
nodeType * IdenDetected(char *a[], int Type[], int Scope, int Num, int Per){
        for (int i=0; i<Num; i++){
                if (AlreadyDeclaredInScope(a[i],Scope)!=NULL){
                printf("\nIdentifier with name %s on line %d is already defined in this scope",a[i], mylineno);
                exit(0);
                }

                struct SymbolInfo *temp= malloc(sizeof(struct SymbolInfo));  
                temp->Sym_Name = a[i];
                temp->Sym_Type = Type[i];
                temp->Sym_Scope = Scope;
                temp->Sym_Perm = Per;
                temp->Sym_Init = false;

                if (!InsertTable(temp)){
                        printf("\nIdentifier with name %s on line %d and same type is already defined in this scope",a[i], mylineno);
                        exit(0);
                }
        }
        
}

nodeType *Test(char* Name, int Per, int Type){
        UpdatePermAndType(Name, Per, Type);
}

nodeType * Assign(char* Name, int newValue){
        bool Found= false;
        struct SymbolInfo * Virtual = NULL;
        struct SymbolInfo * temp= UpdateAnyway(Name, newValue, &Found, Scope_, &Virtual);
        
        //temp is null if not Found
        //temp != null if found in this/previous scope

        if (Found == false){
                TestSymbol = Virtual; 
                FounSymbol = temp; //NULL
        }
        else if (Found && temp != NULL && temp->Sym_Perm == 1){ //Constant already assigned found
                TestSymbol = Virtual; 
                FounSymbol = temp; //NULL
        }
        else if (Found && temp != NULL){//found in current scope or previous scopes
                TestSymbol = Virtual;
                FounSymbol = temp;
        }
}

int getValue(char* Name){
        struct SymbolInfo *symbolEntry = SearchByName(Name);
        if (symbolEntry == NULL){
                printf("\nIdentifier with name %s on line %d is not declared",Name, mylineno);
                exit(0);
        }
        int newv;
        newv=symbolEntry->Sym_Value.MyintValue;
       
        return newv;
}
bool getInit(char* Name){
        struct SymbolInfo *symbolEntry = SearchByName(Name);
        if (symbolEntry == NULL){
                printf("\nIdentifier with name %s on line %d is not declared",Name, mylineno);
                exit(0);
        }
        bool newinit;
        newinit=symbolEntry->Sym_Init;
        return newinit;
}
//aheeh heeehh tayyeb yalla sanyyaaaaa laa tamam yala netla3 fo2 aywaa yalla
int gettype(char* Name){
        struct SymbolInfo *symbolEntry = SearchByName(Name);
        if (symbolEntry == NULL){
                printf("\nIdentifier with name %s on line %d is not declared",Name, mylineno);
                exit(0);
        }
        int newinit;
        newinit=symbolEntry->Sym_Type;
        return newinit;
}

int Abrev(char* Name , int c,int val)
{
         struct SymbolInfo *symbolEntry = SearchByName(Name);
         if (symbolEntry == NULL){
                 printf("\nIdentifier with name %s on line %d is not declared in this/previous scopes",Name, mylineno);
                exit(0); 
         }
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
                exit(0);  
        }
        return newv;

   
}

