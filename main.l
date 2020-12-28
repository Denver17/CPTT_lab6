%option nounput
%{
#include "common.h"
#include "main.tab.h"  // yacc header
#include <iostream>
using namespace std;
int lineno=1;
%}

MAIN void\ main()

EOL	(\r\n|\r|\n)
WHILTESPACE [[:blank:]]

INTEGER [0-9]+|-[0-9]+

CHAR \'.?\'
STRING \".+\"


IDENTIFIER [[:alpha:]_][[:alpha:][:digit:]_]*

printf_text_begin "printf(\""
printf_text_element .
printf_text_end "%d"
%x PRINTF_TEXT

commentbegin "/*"
commentelement .|\n
commentend "*/"
%x COMMENT

linecommentbegin "//"
linecommentelement .
linecommentend \n
%x LINECOMMENT

%%
 

"int" return T_INT;
"bool" return T_BOOL;
"char" return T_CHAR;
"void" return T_VOID;

"if" return IF;
"else" return ELSE;
"while" return WHILE;
"for" return FOR;

"=" return ASSIGN;
"+=" return ADD_ASSIGN;
"-=" return SUB_ASSIGN;

"++" return SELF_ADD;
"--" return SELF_SUB;

"==" return EQ;
"!=" return UNEQ;
">" return BIGGER;
">=" return BIGGER_EQ;
"<=" return SMALLER_EQ;
"<" return SMALLER;
"&&" return AND;
"||" return OR;

"+" return ADD;
"-" return SUB;
"*" return MUL;
"/"	return DIV;
"%" return MODULA;

"(" return LPAREN;
")" return RPAREN;
"[" return LSB;
"]" return RSB;
"{" return LBRACE;
"}" return RBRACE;

"!" return UN;

"&" return GUIDE;


";" return  SEMICOLON;
"," return COMMA;
\"  return DOUBLE_MARK;

\\n return NEXT_LINE;

"printf" return PRINTF;
"scanf" return SCANF;

"%d" return SPF_TYPE_1_d;



"void main()" {
    cout<<"main"<<endl;
}



"true" {
    TreeNode *node = new TreeNode(lineno,NODE_BOOL);
    node->b_val = true;
    yylval = node;
    return TRUE;
}
"false" {
    TreeNode *node = new TreeNode(lineno,NODE_BOOL);
    node->b_val = false;
    yylval = node;
    return FALSE;
}


{INTEGER} {
    TreeNode* node = new TreeNode(lineno, NODE_CONST);
    node->varType = VAR_INTEGER;
    node->int_val = atoi(yytext);
    yylval = node;
    return INTEGER;
}



{CHAR} {
    TreeNode* node = new TreeNode(lineno, NODE_CONST);
    node->type = TYPE_CHAR;
    node->ch_val = yytext[1];
    yylval = node;
    return CHAR;
}



{IDENTIFIER} {
    TreeNode* node = new TreeNode(lineno, NODE_VAR);
    node->var_name = string(yytext);
    node->vartype=VAR_ID;
    yylval = node;
    return IDENTIFIER;
}

{WHILTESPACE} /* do nothing */

{EOL} {
	lineno++;	  
}

{printf_text_begin} {BEGIN PRINTF_TEXT;}
<PRINTF_TEXT>{printf_text_element} {}
<PRINTF_TEXT>{printf_text_end} {
	//cout<<PRINTF_TEXT<<endl;
	//return PRINTF_TEXT;
	BEGIN INITIAL;
}

{commentbegin} {BEGIN COMMENT;}
<COMMENT>{commentelement} {}
<COMMENT>{commentend} {BEGIN INITIAL;}

{linecommentbegin} {BEGIN LINECOMMENT;}
<LINECOMMENT>{linecommentelement} {}
<LINECOMMENT>{linecommentend} {BEGIN INITIAL;}


%%
