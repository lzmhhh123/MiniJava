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
%type <node> Goal MainClass ExtendOpt Identifier
%type <node> ClassDeclarations ClassDeclarationList ClassDeclaration
%type <node> VarDeclarations VarDeclarationList VarDeclaration
%type <node> MethodDeclarations MethodDeclarationList MethodDeclaration
%type <node> TypeIdentifiers TypeIdentifierList TypeIdentifier
%type <node> Statements StatementList Statement
%type <node> Expressions ExpressionList Expression


%right '='
%left '.'
%left '+', '-', '*'
%left And, '<'
%right '!'

%%
Goal:
    MainClass ClassDeclarations 
    {
        $$ = new_node("Goal", 2, $1, $2);
    }
    ;

MainClass:
    Class Identifier '{' Public Static Void Main '(' String '[' ']' Identifier ')' '{' Statement '}' '}'
    {
        $$ = new_node("MainClass", 17, $1, $2, $3, $4, $5,
                                       $6, $7, $8, $10, $11,
                                       $12, $13, $14, $15, $16,
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
    Class Identifier ExtendOpt '{' VarDeclarations MethodDeclarations '}'
    {
        $$ = new_node("ClassDeclaration", 7, $1, $2, $3, $4,
                                             $5, $6, $7);
    }
    ;

ExtendOpt:
    /* empty */
    {
        $$ = NULL;
    }
|   Extend Identifier
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
    Type Identifier ';'
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
    Public Type Identifier '(' TypeIdentifiers ')' '{' VarDeclarations Statements '}' Return Expression ';' '}'
    {
        $$ = new_node("MethodDeclaration", 14, $1, $2, $3, $4,
                                               $5, $6, $7, $7,
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
|   TypeIdentifierList ',' TypeIdentifier
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
|   Integer '[' ']'
    {
        $$ = new_node("Type", 3, $1, $2, $3);
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
    '{' Statements '}'
    {
        $$ = new_node("Statement", 3, $1, $2, $3);
    }
|   If '(' Expression ')' Statement Else Statement
    {
        $$ = new_node("Statement", 7, $1, $2, $3, $4,
                                      $5, $6, $7);
    }
|   While '(' Expression ')' Statement
    {
        $$ = new_node("Statement", 5, $1, $2, $3, $4,
                                      $5);
    }
|   Println '(' Expression ')' ';'
    {
        $$ = new_node("Statement", 5, $1, $2, $3, $4,
                                      $5);
    }
|   Identifier '=' Expression ';'
    {
        $$ = new_node("Statement", 4, $1, $2, $3, $4);
    }
|   Identifier '[' Expression ']' '=' Expression ';'
    {
        $$ = new_node("Statement", 7, $1, $2, $3, $4,
                                      $5, $6, $7);
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
|   ExpressionList ',' Expression
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
|   Expression '[' Expression ']'
    {
        $$ = new_node("Expression", 4, $1, $2, $3, $4);
    }
|   Expression '.' Length
    {
        $$ = new_node("Expression", 3, $1, new_node(".", 0), $3);
    }
|   Expression '.' Identifier '(' Expressions ')'
    {
        $$ = new_node("Expression", 6, $1, new_node("<", 0), $3.
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
|   New Integer '[' Expression ']'
    {
        $$ = new_node("Expression", 5, $1, $2, $3, $4, $5);
    }
|   New Identifier '(' ')'
    {
        $$ = new_node("Expression", 4, $1, $2, $3, $4);
    }
|   '!' Expression
    {
        $$ = new_node("Expression", 2, $1, $2);
    }
|   '(' Expression ')'
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