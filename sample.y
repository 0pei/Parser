/*	Definition section */
%{
    #include "common.h" //Extern variables that communicate with lex
    // #define YYDEBUG 1
    // int yydebug = 1;
    #include <stdbool.h>

    extern int yylineno;
    extern int yylex();
    extern FILE *yyin;

    void yyerror (char const *s)
    {
        printf("error:%d: %s\n", yylineno, s);
    }


    /* Symbol table function - you can add new function if needed. */
    void create_symbol(/* ... */);
    void insert_symbol(int scope,char*name,char*type,int line,char*et);
    int lookup_symbol(int scope,char*name);
    void dump_symbol(int scope);
%}

%error-verbose

/* Use variable or self-defined structure to represent
 * nonterminal and token type
 */
%union {
    int i_val;
    float f_val;
    char *s_val;
//    char *id;
    /* ... */
}

/* Token without return */
%token INT FLOAT BOOL STRING
%token ';' '(' ')' '[' ']' '{' '}'
%left '+' '-'
%left '*' '/' '%'
%token INC DEC ASSIGN ADD_ASSIGN SUB_ASSIGN MUL_ASSIGN QUO_ASSIGN REM_ASSIGN
%token GTR LSS GEQ LEQ EQL NEQ AND OR NOT TRUE FALSE
%token PRINT IF ELSE FOR WHILE
/* Token with return, which need to sepcify type */
%token <i_val> INT_LIT
%token <f_val> FLOAT_LIT
%token <s_val> STRING_LIT
%token <s_val> IDENT
/* Nonterminal with return, which need to sepcify type */
%type <s_val> type Literal

/* Yacc will start at this nonterminal */
%start Program

/* Grammar section */
%%

Program
    : Program stmts
    | 
;

stmts
	: stmt stmts
	|
;

type
    : INT { $$="int";  }
    | FLOAT { $$="float"; }
    | STRING{ $$="string"; }
    | BOOL{ $$="bool"; }
;
Literal
    : INT_LIT { 
		$$ = "int";
        printf("INT_LIT %d\n", $<i_val>1);
    }
    | FLOAT_LIT {
		$$ = "float";
        printf("FLOAT_LIT %f\n", $<f_val>1);
    }
    | STRING_LIT{
		$$ = "string";
		printf("STRING_LIT %s\n", $<s_val>1);
    }
;
stmt
    : declstmt
    | Block
    | IfStmt
    | LoopStmt
    | PrintStmt
;
%%

/* C code section */
int main(int argc, char *argv[])
{
    if (argc == 2) {
        yyin = fopen(argv[1], "r");
    } else {
        yyin = stdin;
    }
    yyparse();
	printf("Total lines: %d\n", yylineno);
    fclose(yyin);
    return 0;
}
