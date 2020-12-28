#ifndef TREE_H
#define TREE_H

enum NodeType
{
	NODE_PROG,
    NODE_CONST, 
    NODE_VAR,
    NODE_EXPR,
    NODE_TYPE,
	NODE_OP,
	NODE_BOOL,

    NODE_STMT,
    //NODE_PROGRAM,
};

enum OPType
{
    OP_EQ,  // ==
	OP_ADD, //+
	OP_SUB, //-
	OP_MUL, //*
	OP_DIV, ///
	OP_UN, //!
	OP_MODULA,//%
	OP_BIGGER,//>
	OP_SMALLER,//<
	OP_SMALLER_EQ,//<=
	OP_BIGGER_EQ,//>=
	OP_AND,//&&
	OP_OR,//||
	OP_UNEQ//!=
};


enum StmtType {
    STMT_SKIP,
    STMT_DECL,	
	STMT_IF,	//if
	STMT_WHILE,	//while
	STMT_FOR,	//for
	STMT_FOR_BOOL,//for中的判断语句
    STMT_ASSIGN,//=
    STMT_PRINTF,//printf
    STMT_SCANF,//scanf
	STMT_SELF,//++ --
}
;

enum VarType{
    VAR_INTEGER,
    VAR_VOID,
    //VAR_FLOAT,
    VAR_CHAR,
    VAR_STRING,
    VAR_ID
};


#define MAX_CHILDREN 4


// union NodeAttr {
// 	int op;
// 	int vali;
// 	char valc;
// 	int symtbl_seq;
	
// 	NodeAttr(void) { op = 0; }
// 	NodeAttr(int i)	{ op = i; }
// 	NodeAttr(char c) { valc = c; }
// };

// struct Label {
// 	string true_label;
// 	string false_label;
// 	string begin_label;
// 	string next_label;
// };

// struct Node
// {
// 	struct Node *children[MAX_CHILDREN];
// 	struct Node *sibling;
// 	int lineno;
// 	int kind;
// 	int kind_kind;
// 	NodeAttr attr;
// 	int type;
// 	int seq;
// 	int temp_var;
// 	Label label;

// 	void output(void);
// };


class TreeNode {
public:
    int nodeID;  // 用于作业的序号输出
    int lineno;
    NodeType nodeType;
    
    VarType vartype;
    ConstType contype;

    TreeNode* child = nullptr;
    TreeNode* sibling = nullptr;

    void addChild(TreeNode*);
    void addSibling(TreeNode*);
    
    void printNodeInfo();
    void printChildrenId();

    void printAST(); // 先输出自己 + 孩子们的id；再依次让每个孩子输出AST。
    //void printSpecialInfo();

    void genNodeId(int& num);

//public:
    OperatorType optype;  // 如果是表达式
    Type* type;  // 变量、类型、表达式结点，有类型。
    StmtType stype;
    int int_val;
    char ch_val;
    bool b_val;
    string str_val;
    string var_name;
// public:
//     static string nodeType2String (NodeType type);
//     static string opType2String (OperatorType type);
//     static string sType2String (StmtType type);

public:
    TreeNode(int lineno, NodeType type);
};




// class tree
// {
// private:
// 	Node *root;
// 	int node_seq = 0;
// 	int temp_var_seq = 0;
// 	int label_seq = 0;

// private:
// 	void type_check(Node *t);
// 	void get_temp_var(Node *t);
// 	string new_label(void);
// 	void recursive_get_label(Node *t);
// 	void stmt_get_label(Node *t);
// 	void expr_get_label(Node *t);
// 	void gen_header(ostream &out);
// 	void gen_decl(ostream &out, Node *t);
// 	void recursive_gen_code(ostream &out, Node *t);
// 	void stmt_gen_code(ostream &out, Node *t);
// 	void expr_gen_code(ostream &out, Node *t);

// public:
// 	Node *NewRoot(int kind, int kind_kind, NodeAttr attr, int type,
// 		Node *child1 = NULL, Node *child2 = NULL, Node *child3 = NULL, Node *child4 = NULL);
// 	void get_label(void);
// 	void gen_code(ostream &out);
// };




#endif