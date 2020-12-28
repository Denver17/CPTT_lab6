#include "tree.h"
//#include "type.h"
void TreeNode::addChild(TreeNode* child) {
	if(this->child == nullptr) 
		this->child = child;
    else 
		this->child->addSibling(child);
}

void TreeNode::addSibling(TreeNode* sibling){
	if(this->sibling == nullptr) 
		this->sibling = sibling;
    else 
		this->sibling->addSibling(sibling);
}

TreeNode::TreeNode(int lineno, NodeType type) {
	this->lineno=lineno;
	this->nodeType=type;
}

void TreeNode::genNodeId(int& num) {

	this->nodeID = num;
	num++;
   	if(this->child != nullptr) 
   	{
    	this->child->genNodeId(num);
   	}
   	if(this->sibling != nullptr)
   	{
       this->sibling->genNodeId(num);
   	}

}

void TreeNode::printNodeInfo() {
	//cout<<this->lineno<<"\t";
	string nodetype;
	string var;
	string stmt;
	string op;
	string con;
    switch(this->nodeType)
    {
    case NODE_CONST: nodetype = "const"; break;
    case NODE_BOOL: nodetype = "bool"; break;
    case NODE_VAR: nodetype = "variable"; break;
    case NODE_EXPR: nodetype = "expression"; break;
    case NODE_TYPE: nodetype = "type"; break;
    case NODE_STMT: nodetype = "statement"; break;
    case NODE_PROG: nodetype = "program"; break;
    case NODE_OP: nodetype = "operator"; break;
    }
    cout<<"  "<<this->nodeID<<"\t"<<nodetype;

	/*
	if(nodetype=="type")
	{
	switch(this->type)
	{
	case TYPE_INT: cout<<"\t"<<"int"<<"\t";break;
	}
	}
	*/
	
	if(nodetype=="const")
	{
	switch(this->contype)
	{
	case CON_INT: con="int";
		cout<<"\t"<<"\t"<<con<<"\t"<<int_val<<"\t";
		break;
	case CON_CHAR: con="char";
		cout<<"\t"<<"\t"<<con<<"\t"<<ch_val<<"\t";
		break;
	case CON_STRING: con="string";
		cout<<"\t"<<"\t"<<con<<"\t"<<b_val<<"\t";
		break;
	//case CON_VOID: con="void";break;
	}
	//cout<<"\t"<<"\t"<<con<<"\t";
	}
	

	if(nodetype=="variable")
	{
	switch(this->vartype)
	{
	case VAR_ID: var="id";break;
	//case VAR_INTEGER: var="int";break;
	//case VAR_VOID: var="void";break;
	//case VAR_CHAR: var="char";break;
	//case VAR_STRING: var="string";break;
	}
	cout<<"\t"<<var<<"\t"<<this->var_name<<"\t";
	}

	if(nodetype=="statement")
	{
    switch(this->stype)
    {
		/*
		case STMT_SKIP:stmt="skip";
			break;
		*/
    	case STMT_PRINTF:stmt="ptintf";
    		break;
    	case STMT_SCANF:stmt="scanf";
    		break;
    	case STMT_DECL:stmt="decl";
    		break;
    	case STMT_ASSIGN:stmt="assign";
    		break;
    	case STMT_IF:stmt="if";
    		break;
    	case STMT_WHILE:stmt="while";
    		break;
    	case STMT_FOR:stmt="for";
    		break;
		case STMT_SELF:stmt="self";
			break;
		case STMT_FOR_BOOL:stmt="for_bool";
			break;   		
    }
    cout<<"\t"<<stmt<<"\t"<<"\t";
	}

	if(nodetype=="operator")
	{
	switch(this->optype)
	{
		case OP_EQ:op="EQ";
			break;
		case OP_ADD:op="ADD";
			break;
		case OP_SUB:op="SUB";
			break;
		case OP_MUL:op="MUL";
			break;
		case OP_DIV:op="DIV";
			break;
		case OP_UN:op="UN";
			break;
		case OP_MODULA:op="MOUDLA";
			break;
		case OP_BIGGER:op="BIGGER";
			break;
		case OP_SMALLER:op="SMALLER";
			break;
		case OP_BIGGER_EQ:op="BIGGER_EQ";
			break;
		case OP_SMALLER_EQ:op="SMALLER_EQ";
			break;
		case OP_AND:op="AND";
			break;
		case OP_OR:op="OR";
			break;
		case OP_UNEQ:op="UNEQ";
			break;
	}
	cout<<"\t"<<op<<"\t"<<"\t";
	}
}

void TreeNode::printChildrenId() {


}

void TreeNode::printAST() {

	 //cout<<this->nodeID;
     //printSpecialInfo();
	 //cout<<"\t"<<"child:";
     //printChildrenId();
	
	printNodeInfo();
	cout<<"\t"<<"child:";
    TreeNode* ptr = this->child;
    while(ptr != nullptr)
    {
        cout<<"\t"<<ptr->nodeID;
        ptr = ptr->sibling;
    }
    //printNodeConnection();
    cout<<endl;
    if(this->sibling != nullptr) this->sibling->printAST();
    if(this->child != nullptr) this->child->printAST();

}


// You can output more info...
void TreeNode::printSpecialInfo() {
    switch(this->nodeType){
	case NODE_PROG:cout<<"program"<<"\t";
	    break;
        case NODE_CONST:cout<<"const"<<"\t";
            break;
        case NODE_VAR:cout<<"variable"<<"\t";
            break;
        case NODE_EXPR:cout<<"expression"<<"\t";
            break;
        case NODE_STMT:cout<<"statement"<<"\t";
            break;
        case NODE_TYPE:cout<<"type"<<"\t"<<"\t";
            break;
        default:
            break;
    }
    switch(this->stype){
    	case STMT_PRINTF:cout<<"ptintf"<<"\t";
    		break;
    	case STMT_SCANF:cout<<"scanf"<<"\t";
    		break;
    	case STMT_DECL:cout<<"decl"<<"\t";
    		break;
    	case STMT_ASSIGN:cout<<"assign"<<"\t";
    		break;
    	default:
    		break;
    }
}

/*
string TreeNode::sType2String(StmtType type) {
    return "?";
}


string TreeNode::nodeType2String (NodeType type){
    return "<>";
}
*/

