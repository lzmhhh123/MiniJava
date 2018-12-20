%{
#include <stdio.h>
#include "node.h"

extend int yylineno;

void yylex(void);
void yyerror(char *s);
%}

%token <node> Class Public Static Void Main If Else While Extends
%token <node> Integer Boolean String True False Id IntegerIteral
%token <node> And This New Println Length Return 
%token <node> Rbrace Raccess LBracket RBracket
%token <node> Semicolon Comma
%type <node> Goal MainClass ExtendOpt Identifier Type
%type <node> ClassDeclarations ClassDeclarationList ClassDeclaration
%type <node> VarDeclarations VarDeclarationList VarDeclaration
%type <node> MethodDeclarations MethodDeclarationList MethodDeclaration
%type <node> TypeIdentifiers TypeIdentifierList TypeIdentifier
%type <node> Statements StatementList Statement
%type <node> Expressions ExpressionList Expression

%left Laccess, Lbrace
%right '='
%left '.'
%left '*'
%left '+' '-'
%left And '<'
%right '!'

%%
Goal:
    MainClass ClassDeclarations 
    {
        $$ = new_node("Goal", 2, $1, $2);
    }
    ;

MainClass:
    Class Identifier Lbrace Public Static Void Main LBracket String Laccess Raccess Identifier RBracket Lbrace Statement Rbrace Rbrace
    {
        $$ = new_node("MainClass", 17, $1, $2, new_node("{", 0), $4, $5,
                                       $6, $7, $8, $9, new_node("[", 0), $11,
                                       $12, $13, new_node("{", 0), $15, $16,
                                       $17);
    }
    ;

ClassDeclarationList:
    ClassDeclaration 
    {
        $$ = new_node("ClassDeclarationList", 1, $1);
    }
|   ClassDeclarationList ClassDeclaration
    {
        $$ = new_node("ClassDeclarationList", 2, $1, $2);
    }
    ;

ClassDeclarations:
    /* empty */
    {
        $$ = NULL;
    }
|   ClassDeclarationList
    {
        $$ = new_node("ClassDeclarations", 1, $1);
    }
    ;

ClassDeclaration:
    Class Identifier ExtendOpt Lbrace VarDeclarations MethodDeclarations Rbrace
    {
        $$ = new_node("ClassDeclaration", 7, $1, $2, $3, new_node("{", 0),
                                             $5, $6, $7);
    }
    ;

ExtendOpt:
    /* empty */
    {
        $$ = NULL;
    }
|   Extends Identifier
    {
        $$ = new_node("ExtendOpt", 2, $1, $2);
    }
    ;

VarDeclarations:
    /* empty */
    {
        $$ = NULL;
    }
|   VarDeclarationList
    {
        $$ = new_node("VarDeclarations", 1, $1);
    }
    ;

VarDeclarationList:
    VarDeclaration
    {
        $$ = new_node("VarDeclarationList", 1, $1);
    }
|   VarDeclarationList VarDeclaration
    {
        $$ = new_node("VarDeclarationList", 2, $1, $2);
    }
    ;

VarDeclaration:
    Type Identifier Semicolon
    {
        $$ = new_node("VarDeclaration", 3, $1, $2, $3);
    }
    ;

MethodDeclarations:
    /* empty */
    {
        $$ = NULL;
    }
|   MethodDeclarationList
    {
        $$ = new_node("MethodDeclarations", 1, $1);
    }
    ;

MethodDeclarationList:
    MethodDeclaration
    {
        $$ = new_node("MethodDeclarationList", 1, $1);
    }
|   MethodDeclarationList MethodDeclaration
    {
        $$ = new_node("MethodDeclarationList", 2, $1, $2);
    }
    ;

MethodDeclaration:
    Public Type Identifier LBracket TypeIdentifiers RBracket Lbrace VarDeclarations Statements Rbrace Return Expression Semicolon Rbrace
    {
        $$ = new_node("MethodDeclaration", 14, $1, $2, $3, $4,
                                               $5, $6, new_node("{", 0),
                                               $8, $9, $10, $11,
                                               $12, $13, $14);
    }
    ;

TypeIdentifiers:
    /* empty */
    {
        $$ = NULL;
    }
|   TypeIdentifierList
    {
        $$ = new_node("TypeIdentifiers", 1, $1);
    }
    ;

TypeIdentifierList:
    TypeIdentifier
    {
        $$ = new_node("TypeIdentifierList", 1, $1);
    }
|   TypeIdentifierList Comma TypeIdentifier
    {
        $$ = new_node("TypeIdentifierList", 3, $1, $2, $3);
    }
    ;

TypeIdentifier:
    Type Identifier
    {
        $$ = new_node("TypeIdentifer", 2, $1, $2);
    }
    ;

Statements:
    /* empty */
    {
        $$ = NULL;
    }
|   StatementList
    {
        $$ = new_node("Statements", 1, $1);
    }
    ;

StatementList:
    Statement
    {
        $$ = new_node("StatementList", 1, $1);
    }
|   StatementList Statement
    {
        $$ = new_node("StatementList", 2, $1, $2);
    }
    ;

Type:
    Integer
    {
        $$ = new_node("Type", 1, $1);
    }
|   Integer Laccess Raccess
    {
        $$ = new_node("Type", 3, $1, new_node("[", 0), $3);
    }
|   Boolean
    {
        $$ = new_node("Type", 1, $1);
    }
|   Identifier
    {
        $$ = new_node("Type", 1, $1);
    }
    ;

Statement:
    Lbrace Statements Rbrace
    {
        $$ = new_node("Statement", 3, new_node("{", 0), $2, $3);
    }
|   If LBracket Expression RBracket Statement Else Statement
    {
        $$ = new_node("Statement", 7, $1, $2, $3, $4,
                                      $5, $6, $7);
    }
|   While LBracket Expression RBracket Statement
    {
        $$ = new_node("Statement", 5, $1, $2, $3, $4,
                                      $5);
    }
|   Println LBracket Expression RBracket Semicolon
    {
        $$ = new_node("Statement", 5, $1, $2, $3, $4,
                                      $5);
    }
|   Identifier '=' Expression Semicolon
    {
        $$ = new_node("Statement", 4, $1, new_node("=", 0), $3, $4);
    }
|   Identifier Laccess Expression Raccess '=' Expression Semicolon
    {
        $$ = new_node("Statement", 7, $1, new_node("[", 0), $3, $4,
                                      new_node("=", 0), $6, $7);
    }
    ;

Expressions:
    /* empty */
    {
        $$ = NULL;
    }
|   ExpressionList
    {
        $$ = new_node("Expressions", 1, $1);
    }
    ;

ExpressionList:
    Expression
    {
        $$ = new_node("ExpressionList", 1, $1);
    }
|   ExpressionList Comma Expression
    {
        $$ = new_node("ExpressionList", 3, $1, $2, $3);
    }
    ;

Expression:
    Expression And Expression
    {
        $$ = new_node("Expression", 3, $1, new_node("$$", 0), $3);
    }
|   Expression '<' Expression
    {
        $$ = new_node("Expression", 3, $1, new_node("<", 0), $3);
    }
|   Expression '+' Expression
    {
        $$ = new_node("Expression", 3, $1, new_node("+", 0), $3);
    }
|   Expression '-' Expression
    {
        $$ = new_node("Expression", 3, $1, new_node("-", 0), $3);
    }
|   Expression '*' Expression
    {
        $$ = new_node("Expression", 3, $1, new_node("*", 0), $3);
    }
|   Expression Laccess Expression Raccess
    {
        $$ = new_node("Expression", 4, $1, new_node("[", 0), $3, $4);
    }
|   Expression '.' Length
    {
        $$ = new_node("Expression", 3, $1, new_node(".", 0), $3);
    }
|   Expression '.' Identifier LBracket Expressions RBracket
    {
        $$ = new_node("Expression", 6, $1, new_node(".", 0), $3.
                                       $4, $5, $6);
    }
|   True
    {
        $$ = new_node("Expression", 1, $1);
    }
|   False
    {
        $$ = new_node("Expression", 1, $1);
    }
|   Identifier
    {
        $$ = new_node("Expression", 1, $1);
    }
|   This
    {
        $$ = new_node("Expression", 1, $1);
    }
|   New Integer Laccess Expression Raccess
    {
        $$ = new_node("Expression", 5, $1, $2, new_node("[", 0), $4, $5);
    }
|   New Identifier LBracket RBracket
    {
        $$ = new_node("Expression", 4, $1, $2, $3, $4);
    }
|   '!' Expression
    {
        $$ = new_node("Expression", 2, new_node("!", 0), $2);
    }
|   LBracket Expression RBracket
    {
        $$ = new_node("Expression", 3, $1, $2, $3);
    }
|   IntegerIteral
    {
        $$ = new_node("Expression", 1, $1);
    }
    ;

Identifier:
    Id
    {
        $$ = new_node("Expression", 1, $1);
    }
    ;

%%
void yyerror(char *s) {
    fprintf(stderr, "line %d: %s \n", yylineno, s);
}

int main(void) {
    yyparse();
    return 0;
}
