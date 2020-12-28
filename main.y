%{
    #include "common.h"
    #define YYSTYPE TreeNode *  
    TreeNode* root;
    extern int lineno;
    int yylex();
    int yyerror( char const * );
%}


%start program

%token MAIN

%token PRINTF SCANF

%token PRINTF_TEXT

%token SPF_TYPE_1_d

%token GUIDE

%token T_CHAR T_INT T_STRING T_BOOL T_VOID

%token ASSIGN  ADD_ASSIGN SUB_ASSIGN SELF_ADD SELF_SUB

%token IDENTIFIER INTEGER CHAR BOOL STRING

%left OR

%left AND

%token TRUE FALSE

%token IF ELSE WHILE FOR

%left EQ UNEQ BIGGER SMALLER BIGGER_EQ SMALLER_EQ

%left ADD SUB 

%left MUL DIV MODULA

%left UN

%token LPAREN RPAREN LSB RSB LBRACE RBRACE  SEMICOLON COMMA

%token NEXT_LINE

%token DOUBLE_MARK

%nonassoc LOWER_THEN_ELSE
%nonassoc ELSE



%%


program
: statements {root = new TreeNode(1, NODE_PROG); root->addChild($1);}
;

statements
:  statement {$$=$1;}
|  statements statement {$$=$1; $$->addSibling($2);}
;

statement
: SEMICOLON  {$$ = new TreeNode(lineno, NODE_STMT); $$->stype = STMT_SKIP;}
| declaration {$$ = $1;}
| if_statement {$$=$1;}
| while_statement {$$=$1;}
| for_statement {$$=$1;}
| LBRACE statements RBRACE {$$=$2;}
| printf {$$=$1;}
| scanf  {$$=$1;}
;

scanf
: SCANF LPAREN DOUBLE_MARK SPF_TYPE_1_d DOUBLE_MARK COMMA GUIDE IDENTIFIER RPAREN SEMICOLON{
	TreeNode *node=new TreeNode($1->lineno,NODE_STMT);
    node->stype=STMT_SCANF;
	node->addChild($4);
    node->addChild($8);
	$$=node;
}
;

/*
printf
: PRINTF_TEXT DOUBLE_MARK COMMA IDENTIFIER RPAREN SEMICOLON{
	TreeNode *node=new TreeNode($1->lineno,NODE_STMT);
	node->stype=STMT_PRINTF;
	node->addChild($4);
	$$=node;
}
*/

printf
:  NEXT_LINE DOUBLE_MARK  COMMA IDENTIFIER RPAREN SEMICOLON{
	TreeNode *node=new TreeNode($1->lineno,NODE_STMT);
    node->stype=STMT_PRINTF;
    node->addChild($1);
 	$$=node;
}
;




if_statement
:  IF bool_statement statement ELSE statement{
	TreeNode *node=new TreeNode($1->lineno,NODE_STMT);
    node->stype=STMT_IF;
    node->addChild($2);
    node->addChild($3);
    node->addChild($5);
    $$=node;
}
|IF bool_statement statement %prec LOWER_THEN_ELSE{
    TreeNode *node=new TreeNode($1->lineno,NODE_STMT);
    node->stype=STMT_IF;
    node->addChild($2);
    node->addChild($3);
    $$=node;
}
;

while_statement
: WHILE bool_statement statement {
    TreeNode *node=new TreeNode($1->lineno,NODE_STMT);
    node->stype=STMT_WHILE;
    node->addChild($2);
    node->addChild($3);
    $$=node;
}
;

/*
for_statement
: FOR  declaration  statement{
	TreeNode *node=new TreeNode($1->lineno,NODE_STMT);
	node->stype=STMT_FOR;
	node->addChild($2);
	node->addChild($3);
	$$=node;
}
*/

//这里declaration最后跟着分号，因此没有SEMICOLON
for_statement
: FOR LPAREN declaration  bool_expr SEMICOLON self_assign RPAREN statement {
	TreeNode *node=new TreeNode($1->lineno,NODE_STMT);
    node->stype=STMT_FOR;
   	node->addChild($3);
   	node->addChild($4);
	node->addChild($6);
	node->addChild($8);
    $$=node;
}



/*
for_bool_statement
:  bool_expr {
	TreeNode *node=new TreeNode($1->lineno,NODE_STMT);
    node->stype=STMT_FOR_BOOL;
    node->addChild($2);
    //node->addChild($4);
	node->addChild($5);
    $$=node;
}
*/

self_assign
: IDENTIFIER SELF_ADD{
	TreeNode *node=new TreeNode($1->lineno,NODE_STMT);
    node->stype=STMT_SELF;
    node->addChild($1);
    $$=node;
}
| IDENTIFIER SELF_SUB {
	TreeNode *node=new TreeNode($1->lineno,NODE_STMT);
	node->stype=STMT_SELF;
    node->addChild($1);
	$$=node;
}
| SELF_ADD IDENTIFIER{
	TreeNode *node=new TreeNode($1->lineno,NODE_STMT);
    node->stype=STMT_SELF;
    node->addChild($1);
    $$=node;	
}
| SELF_SUB IDENTIFIER{
	TreeNode *node=new TreeNode($1->lineno,NODE_STMT);
    node->stype=STMT_SELF;  
    node->addChild($1);
    $$=node;
}



bool_statement
:  LPAREN bool_expr RPAREN {$$=$2;}
;

printf
: PRINTF LPAREN expr RPAREN {
    TreeNode *node=new TreeNode($1->lineno,NODE_STMT);
    node->stype=STMT_PRINTF;
    node->addChild($3);
    $$=node;
}
;
scanf
: SCANF LPAREN expr RPAREN {
    TreeNode *node=new TreeNode($1->lineno,NODE_STMT);
    node->stype=STMT_SCANF;
    node->addChild($3);
    $$=node;
}
;


declaration
: T IDENTIFIER ASSIGN expr SEMICOLON{  // declare and init
    TreeNode* node = new TreeNode($1->lineno, NODE_STMT);
    node->stype = STMT_DECL;
    node->addChild($1);
    node->addChild($2);
    node->addChild($4);
    $$ = node;   
} 
| T IDENTIFIER SEMICOLON{
    TreeNode* node = new TreeNode($1->lineno, NODE_STMT);
    node->stype = STMT_DECL;
    node->addChild($1);
    node->addChild($2);
    $$ = node;   
}
| T IDENTIFIERS SEMICOLON{
	TreeNode *node=new TreeNode($1->lineno,NODE_STMT);
    node->stype=STMT_DECL;
    node->addChild($1);
    node->addChild($2);
    $$=node; 
}
| IDENTIFIER ASSIGN expr SEMICOLON{
	TreeNode *node=new TreeNode($1->lineno,NODE_STMT);
    node->stype=STMT_ASSIGN;
    node->addChild($1);
    node->addChild($3);
    $$=node;  
}
| IDENTIFIER ADD_ASSIGN expr SEMICOLON{
	TreeNode *node=new TreeNode($1->lineno,NODE_STMT);
    node->stype=STMT_ASSIGN;
    node->addChild($1);
    node->addChild($3);
    $$=node;
}
| IDENTIFIER SUB_ASSIGN expr SEMICOLON{
	TreeNode *node=new TreeNode($1->lineno,NODE_STMT);
    node->stype=STMT_ASSIGN;
    node->addChild($1);
    node->addChild($3);
    $$=node;  
}
;



IDENTIFIERS
: IDENTIFIER COMMA IDENTIFIERS{
    TreeNode *node=new TreeNode($1->lineno,NODE_VAR);
    //node->vartype=VAR_ID;
    node->addChild($1);
    node->addChild($3);
    $$=node; 
}
| IDENTIFIER{
    $$=$1;
    //TreeNode* node = new TreeNode($1->lineno, NODE_VAR);
    //node->vartype=VAR_ID;
    //node->addSibling($1);
    //$$ = node;
}
;




bool_expr
: TRUE {$$=$1;}
| FALSE {$$=$1;}

/*
| bool_expr EQ bool_expr{
	TreeNode *node=new TreeNode($1->lineno,NODE_OP);
    node->optype=OP_EQ;
    node->addChild($1);
    node->addChild($3);
    $$=node;  
}
*/

| expr EQ expr {
    TreeNode *node=new TreeNode($1->lineno,NODE_OP);
    node->optype=OP_EQ;
    node->addChild($1);
    node->addChild($3);
    $$=node;
}
| UN bool_expr {
 	TreeNode *node=new TreeNode($1->lineno,NODE_OP);
    node->optype=OP_UN;
    node->addChild($2);
    $$=node;
}
| bool_expr AND bool_expr {
	TreeNode *node=new TreeNode($1->lineno,NODE_OP);
	node->optype=OP_AND;    
	node->addChild($1);
    node->addChild($3);
    $$=node;
}
| bool_expr OR bool_expr {    
	TreeNode *node=new TreeNode($1->lineno,NODE_OP);
    node->optype=OP_OR;
    node->addChild($1);
    node->addChild($3);
    $$=node;
}
| expr UNEQ expr {
    TreeNode *node=new TreeNode($1->lineno,NODE_OP);
    node->optype=OP_UNEQ;
    node->addChild($1);
    node->addChild($3);
    $$=node;
}
| expr BIGGER expr {
    TreeNode *node=new TreeNode($1->lineno,NODE_OP);
    node->optype=OP_BIGGER;
    node->addChild($1);
    node->addChild($3);
    $$=node;
}
| expr SMALLER expr {
    TreeNode *node=new TreeNode($1->lineno,NODE_OP);
    node->optype=OP_SMALLER;
    node->addChild($1);
    node->addChild($3);
    $$=node;
}
| expr SMALLER_EQ expr {
    TreeNode *node=new TreeNode($1->lineno,NODE_OP);
    node->optype=OP_SMALLER_EQ;
    node->addChild($1);
    node->addChild($3);
    $$=node;
}
| expr BIGGER_EQ expr {
    TreeNode *node=new TreeNode($1->lineno,NODE_OP);
    node->optype=OP_BIGGER_EQ;
    node->addChild($1);
	node->addChild($3);
	$$=node;
}
;

expr
: expr ADD expr {
	TreeNode* node = new TreeNode($1->lineno, NODE_EXPR);
	node->optype=OP_ADD;
    node->addChild($1);
    node->addChild($3);
    $$ = node;

}
|expr SUB expr {
	TreeNode* node = new TreeNode($1->lineno, NODE_EXPR);
    node->optype=OP_SUB;
    node->addChild($1);
    node->addChild($3);
    $$ = node;

}
| expr MUL expr {
	TreeNode* node = new TreeNode($1->lineno, NODE_EXPR);
    node->optype=OP_MUL; 
    node->addChild($1);
    node->addChild($3);
    $$ = node;

}
| expr DIV expr {
	TreeNode* node = new TreeNode($1->lineno, NODE_EXPR);
    node->optype=OP_DIV; 
    node->addChild($1);
    node->addChild($3);
    $$ = node;

}
| expr MODULA expr {
    TreeNode *node = new TreeNode($1->lineno,NODE_EXPR);
    node->optype=OP_MODULA;
    node->addChild($1);
    node->addChild($3);
    $$=node;
}
| UN expr {
	TreeNode* node = new TreeNode($1->lineno, NODE_EXPR);
	node->optype=OP_UN;
	node->addSibling($2);
	$$ = node;
}
|SUB expr{
	TreeNode* node = new TreeNode($1->lineno, NODE_EXPR);     
	node->optype=OP_SUB;
    node->addSibling($2);
    $$ = node;

}
/*
| expr EQ expr {
	TreeNode* node = new TreeNode($1->lineno, NODE_EXPR);
	node->optype=OP_EQ;
	node->addChild($1);
	node->addChild($3);
	$$ = node;
}
*/
| IDENTIFIER {
    $$ = $1;
    //TreeNode* node = new TreeNode($1->lineno, NODE_VAR);
    //node->vartype=VAR_ID;
    //node->addChild($1);
    //$$ = node;
}
| INTEGER {
    $$ = $1;
    //TreeNode* node = new TreeNode($1->lineno, NODE_CONST);
    //node->contype=CON_INT;
    //node->addChild($1);
    //$$ = node;
}
| CHAR {
    $$ = $1;
    //TreeNode* node = new TreeNode($1->lineno, NODE_CONST);
    //node->contype=CON_CHAR;
    //node->addChild($1);
    //$$ = node;
}
| STRING {
    $$ = $1;
    //TreeNode* node = new TreeNode($1->lineno, NODE_CONST);
    //node->contype=CON_STRING;
    //node->addChild($1);
    //$$ = node;
}
;

T: T_INT {$$ = new TreeNode(lineno, NODE_TYPE); $$->type = TYPE_INT;} 
| T_CHAR {$$ = new TreeNode(lineno, NODE_TYPE); $$->type = TYPE_CHAR;}
| T_BOOL {$$ = new TreeNode(lineno, NODE_TYPE); $$->type = TYPE_BOOL;}
| T_VOID {$$ = new TreeNode(lineno, NODE_TYPE); $$->type = TYPE_VOID;}
;


 

%%

int yyerror(char const* message)
{
  cout << message << " at line " << lineno << endl;
  return -1;
}
