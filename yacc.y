%{
  #include <stdio.h>
  #include <stdlib.h>
  extern int yylex(); 
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
%token CONSTANT INT FLOAT STRING CHAR BOOL IF THEN ELSE WHILE DO SWITCH CASE DEFAULT FOR AND OR EQUALEQUAL GREATERTHAN SMALLERTHAN GREATERTHANOREQUAL SMALLERTHANOREQUAL NOT NOTEQUAL VOID MAIN RETURN COMMA
%token SEMI_COLON OPENED_BRACKET CLOSED_BRACKET OPENED_BRACE CLOSED_BRACE OPENED_SQ_BRACKET CLOSED_SQ_BRACKET COMMA TWO_DOTS PLUS MINUS MULTIPLY DIVIDE REMAINDER PLUS_EQUAL MINUS_EQUAL MULTIPLY_EQUAL DIVIDE_EQUAL PLUS_PLUS MINUS_MINUS EQUAL

%left MINUS PLUS
%left DIVIDE MULTIPLY
%left REMAINDER


%left OR AND
%left EQUALEQUAL NOTEQUAL 
%left SMALLERTHAN SMALLERTHANOREQUAL GREATERTHAN GREATERTHANOREQUAL
%right NOT 


%%
    /* Language BODY */

    Root: comments funcDefs comments main comments
    |  comments main comments
    ;

    main: VOID MAIN OPENED_BRACKET CLOSED_BRACKET OPENED_BRACE body CLOSED_BRACE
    ;

    body :    whilestmt body 
		| ifstmt body 
		| dowhilestmt body 
		| forstmt body 
		| switchstmt body 
		| declaration body 
		| constdeclaration body 
		| assignment SEMI_COLON body 
		| mathassignment SEMI_COLON body
		/*| function_call SEMI_COLON body */
		| COMMENT body {$$ = $2 ;}
		|{$$ = NULL ;}
	    ;

    fndecs : fndecs comments function_declaration 
	   | comments function_declaration
	   ;

    comments : comments COMMENT
        |
        ;

    /* //////////////////////////////////////// */
    /* Function declarations */
    function_declaration : VOID IDENTIFIER OPENED_BRACKET args CLOSED_BRACKET OPENED_BRACE body CLOSED_BRACE
                         | VOID IDENTIFIER OPENED_BRACKET args CLOSED_BRACKET OPENED_BRACE body RETURN SEMI_COLON CLOSED_BRACE
                         | datatype IDENTIFIER OPENED_BRACKET args CLOSED_BRACKET OPENED_BRACE body RETURN IDENTIFIER SEMI_COLON CLOSED_BRACE
                         | datatype IDENTIFIER OPENED_BRACKET args CLOSED_BRACKET OPENED_BRACE body RETURN val SEMI_COLON CLOSED_BRACE
                         ;
                

    args : datatype IDENTIFIER COMMA args
	 | datatype IDENTIFIER
     |
	 ;

    /* /////////////////////////////////////// */

    /* Utils */
    datatype : INT {$$ = NULL;}
			  | FLOAT {$$ = NULL;}
			  | STRING {$$ = NULL;}
			  | CHAR {$$ = NULL;}
			  | BOOLEAN {$$ = NULL;}
		 ;

    val : number { $$ = $1 ;} 
	| STRINGVALUE  { $$ = con($1,3);}
	| CHARVALUE  { $$ = con($1,2);}
	| boolean { $$ = $1 ;}
	;

    number : INTVALUE
			| FLOATVALUE
		;

    boolean: TRUE
			| FALSE
	;

    /* ///////////////////////////////////// */
%%


int yyerror(char *msg){
  fprintf(stderr,"%s\n",msg);
  exit(1);
}

int main(){
  yyparse();
  return 0;
}