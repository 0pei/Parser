/*	Definition section */
%{
    #include "common.h" //Extern variables that communicate with lex
    // #define YYDEBUG 1
    // int yydebug = 1;

    extern int yylineno;
    extern int yylex();
    extern FILE *yyin;

    void yyerror (char const *s)
    {
        printf("error:%d: %s\n", yylineno, s);
    }

    int ind = 0, addr = 0, sco = 0;
    typedef struct NODE {
        char *name;
        char *type;
        int address;
        int lineno;
        char *elementType;
        struct NODE *next;
    } node;
    node *sym_ta[15] = { NULL };

    /* Symbol table function - you can add new function if needed. */
    static void create()    { sco++; };
    static void insert(char *name, char *type, char *elementType);
    static node* lookup(char *name);
    static void dump(/* ... */);
    static void check_error(char *s1, char *s2, char*s3);
    static int is_lit(char *s);
%}

%error-verbose

/* Use variable or self-defined structure to represent
 * nonterminal and token type
 */
%union {
    int i_val;
    float f_val;
    char *s_val;
}

/* Token without return */
%token INT FLOAT BOOL STRING SEMICOLON TRUE FALSE 
%token OR AND EQL NEQ LEQ GEQ INC DEC
%token ADD_ASSIGN SUB_ASSIGN MUL_ASSIGN QUO_ASSIGN REM_ASSIGN
%token PRINT RETURN IF ELSE FOR WHILE CONTINUE BREAK VOID 
%token '+' '-' '*' '/' '%' '>' '<' '=' '(' ')' '[' ']' '{' '}' '!'

/* Token with return, which need to sepcify type */
%token <i_val> INT_LIT
%token <f_val> FLOAT_LIT
%token <s_val> STRING_LIT IDENT

/* Nonterminal with return, which need to sepcify type */
%type <s_val> Expression Expression1 Expression2 Expression3 Expression4
%type <s_val> TypeName Literal BOOL_LIT UnaryExpr PrimaryExpr IndexExpr
%type <s_val> cmp_op add_op mul_op unary_op assign_op Operand

/* Yacc will start at this nonterminal */
%start Program

/* Grammar section */
%%

Program
    : StatementList { ind = 0; dump(); }
;

TypeName
    : INT       { $$ = "int";  }
    | FLOAT     { $$ = "float"; }
    | STRING    { $$ = "string"; }
    | BOOL      { $$ = "bool"; }   
;

Expression
    : Expression OR Expression1 { check_error($1, "OR", $3); printf("%s\n", "OR"); $$ = $1; } 
    | Expression1
;

Expression1
    : Expression1 AND Expression2 { check_error($1, "AND", $3); printf("%s\n", "AND"); $$ = $1; } 
    | Expression2
;

Expression2
    : Expression2 cmp_op Expression3 { printf("%s\n", $2); $$ = "bool"; }
    | Expression3
;

Expression3 
    : Expression3 add_op Expression4 { check_error($1, $2, $3); printf("%s\n", $2); $$ = $1; }
    | Expression4
;

Expression4 
    : Expression4 mul_op UnaryExpr { check_error($1, $2, $3); printf("%s\n", $2); $$ = $1; }
    | UnaryExpr
;

UnaryExpr
    : PrimaryExpr           { $$ = $1; }
    | unary_op UnaryExpr    { printf("%s\n", $1); $$ = $2; }
;

cmp_op
    : EQL   { $$ = "EQL"; }
    | NEQ   { $$ = "NEQ"; }
    | '<'   { $$ = "LSS"; }
    | LEQ   { $$ = "LEQ"; }
    | '>'   { $$ = "GTR"; }
    | GEQ   { $$ = "GEQ"; }
;

add_op
    : '+'   { $$ = "ADD"; }
    | '-'   { $$ = "SUB"; }
;

mul_op
    : '*'   { $$ = "MUL"; }
    | '/'   { $$ = "QUO"; }
    | '%'   { $$ = "REM"; }
;

unary_op
    : '+'   { $$ = "POS"; }
    | '-'   { $$ = "NEG"; }
    | '!'   { $$ = "NOT"; }
;

PrimaryExpr
    : Operand   { $$ = $1; }
    | IndexExpr { $$ = $1; }
    | ConversionExpr
;

Operand
    : Literal   { $$ = $1; }
    | IDENT {
        $$ = $1;            //can = "int_lit" or "float_lit" etc and use strncmp(,,) #include <string.h>
        if(lookup($1)) printf("IDENT (name=%s, address=%d)\n", $1, lookup($1)->address);
        else printf("error:%d: undefined: %s\n", yylineno, $1);
    }
    | '(' Expression ')'    { $$ = $2; }
;

Literal
    : INT_LIT               { $$ = "int"; printf("INT_LIT %d\n", $<i_val>1); }
    | FLOAT_LIT             { $$ = "float"; printf("FLOAT_LIT %f\n", $<f_val>1); }
    | '\"' STRING_LIT '\"'  { $$ = "string"; printf("STRING_LIT %s\n", $<s_val>2); }
    | BOOL_LIT              { $$ = $1; }
;

BOOL_LIT
    : TRUE  { $$ = "bool"; printf("TRUE\n"); }
    | FALSE { $$ = "bool"; printf("FALSE\n"); }

IndexExpr
    : PrimaryExpr '[' Expression ']'    { $$ = $1; }
;

ConversionExpr
    : '(' TypeName ')' Expression { 
        char* first;
        if(strcmp($4, "int") == 0) first = "I";
        else if (strcmp($4, "float") == 0) first = "F";
        else first = (lookup($4)->type == "int") ? "I" : "F";
        printf("%s to %s\n", first, (strcmp($2, "int") == 0) ? "I" : "F"); 
    }  
;

Statement
    : /* empty */
    | DeclarationStmt
    | AssignmentStmt
    | IncDecStmt
    | Block
    | IfStmt
    | WhileStmt
    | ForStmt
    | PrintStmt
    | Expression SEMICOLON
;

DeclarationStmt
    : TypeName IDENT SEMICOLON                      { insert($2, $1, "-"); }
    | TypeName IDENT '=' Expression SEMICOLON       { insert($2, $1, "-"); }
    | TypeName IDENT '[' Expression ']' SEMICOLON   { insert($2, "array", $1); }
;

AssignmentExpr
    : Expression assign_op Expression { 
        if(lookup($1) && lookup($3)) check_error($1, $2, $3);
        if(is_lit($1) == 1) printf("error:%d: cannot assign to %s\n", yylineno, $1);
        printf("%s\n", $2);
    }  
;

AssignmentStmt
    : AssignmentExpr SEMICOLON
;

assign_op
    : '='           { $$ = "ASSIGN"; }
    | ADD_ASSIGN    { $$ = "ADD_ASSIGN"; }
    | SUB_ASSIGN    { $$ = "SUB_ASSIGN"; }
    | MUL_ASSIGN    { $$ = "MUL_ASSIGN"; }
    | QUO_ASSIGN    { $$ = "QUO_ASSIGN"; }
    | REM_ASSIGN    { $$ = "REM_ASSIGN"; }
;

IncDecExpr
    : Expression INC    { printf("INC\n"); } 
    | Expression DEC    { printf("DEC\n"); } 
;

IncDecStmt
    : IncDecExpr SEMICOLON
;

Block
    : '{' { create(); } StatementList '}' { ind = 0; dump(); }
;

StatementList
    : Statement
    | StatementList Statement
;

IfStmt
    : IF Condition Block
    | IF Condition Block ELSE IfStmt
    | IF Condition Block ELSE Block
;

Condition
    : Expression {
        if(strcmp($1, "bool") != 0) 
            if(is_lit($1) == 0 && lookup($1)) printf("error:%d: non-bool (type %s) used as for condition\n", yylineno + 1, lookup($1)->type);
            else printf("error:%d: non-bool (type %s) used as for condition\n", yylineno + 1, $1);
    }
;

WhileStmt 
    : WHILE '(' Condition ')' Block
;

ForStmt
    : FOR '(' ForClause ')' Block
;

ForClause
    : InitStmt SEMICOLON Condition SEMICOLON PostStmt
;

InitStmt
    : SimpleExpr
;

PostStmt
    : SimpleExpr
;

SimpleExpr
    : AssignmentExpr
    | Expression
    | IncDecExpr
;

PrintStmt
    : PRINT '(' Expression ')' SEMICOLON { 
        if(is_lit($3) == 0) printf("PRINT %s\n", (lookup($3)->type == "array") ? lookup($3)->elementType : lookup($3)->type);
        else printf("PRINT %s\n", $3);
    }
;

%%

static void insert(char *name, char *type, char *elementType) {
    for(node *tn = sym_ta[sco]; tn; tn = tn->next) {
        if(strcmp(tn->name, name) == 0) {
            printf("error:%d: %s redeclared in this block. previous declaration at line %d\n", yylineno, name, tn->lineno);
            return;
        }
    }
    node *new = malloc(sizeof(node));
    new->name = name;
    new->type = type;
    new->address = addr++;
    new->lineno = yylineno;
    new->elementType = elementType;
    new->next = NULL;
    if(sym_ta[sco]) {
        node *tn = sym_ta[sco];
        while(tn->next) tn = tn->next;
        tn->next = new;
    }
    else sym_ta[sco] = new;
    printf("> Insert {%s} into symbol table (scope level: %d)\n", name, sco);
}

static node* lookup(char *name) {
    int s = sco;
    while (s >= 0) {
        node *tn = sym_ta[s--];
        while (tn) {
            if (strcmp(tn->name, name) == 0) return tn;    
            tn = tn->next;
        }
    }
    return NULL;
}

static void dump() {
    printf("> Dump symbol table (scope level: %d)\n", sco);
    printf("%-10s%-10s%-10s%-10s%-10s%s\n", "Index", "Name", "Type", "Address", "Lineno", "Element type");
    node *tn = sym_ta[sco];
    for(node *tn = sym_ta[sco]; tn; tn = tn->next)
        printf("%-10d%-10s%-10s%-10d%-10d%s\n", ind++, tn->name, tn->type, tn->address, tn->lineno, tn->elementType);
    sym_ta[sco--] = NULL;
}

static void check_error(char *s1, char *s2, char *s3) {
    int flag = -1;
    if(strcmp(s2, "REM") == 0)  { flag = 1; }
    if(strcmp(s2, "AND") == 0)  { flag = 2; }
    if(strcmp(s2, "OR") == 0)   { flag = 3; }
    switch(flag)
    {
        case 1:
            if((lookup(s1) && strcmp(lookup(s1)->type, "float") == 0) || (lookup(s3) && strcmp(lookup(s3)->type, "float") == 0))
                printf("error:%d: invalid operation: (operator REM not defined on float)\n", yylineno);
            break;
        case 2:
            if(strcmp(s1, "int") == 0 || strcmp(s3, "int") == 0)
                printf("error:%d: invalid operation: (operator AND not defined on int)\n", yylineno);
            break;
        case 3:
            if(strcmp(s1, "int") == 0 || strcmp(s3, "int") == 0)
                printf("error:%d: invalid operation: (operator OR not defined on int)\n", yylineno);
            break;
        case -1:
            if(lookup(s1) && lookup(s3) && strcmp(lookup(s1)->type, lookup(s3)->type) != 0)
                printf("error:%d: invalid operation: %s (mismatched types %s and %s)\n", yylineno, s2, lookup(s1)->type, lookup(s3)->type);
            if(!lookup(s1) && !lookup(s3) && strcmp(s1, s3) != 0 && strcmp(s1, "bool") != 0 && strcmp(s3, "bool") != 0)
                printf("error:%d: invalid operation: %s (mismatched types %s and %s)\n", yylineno, s2, s1, s3);
    }
}

static int is_lit(char *s) {
    if(strcmp(s, "int") != 0 && strcmp(s, "float") != 0 && strcmp(s, "bool") != 0 && strcmp(s, "string") != 0) return 0;
    else return 1;
}

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