%{
#include <stdio.h>
#include "node.h"

extern int yylineno;

int yylex();
void yyerror(char *s);
%}

%union {
    struct Node* node;
    double d;
}

%token <node> Class Public Static Void Main If Else While Extends
%token <node> Integer Boolean String True False Id IntegerIteral
%token <node> And This New Println Length Return 
%token <node> Rbrace Raccess LBracket RBracket
%token <node> Semicolon Comma
%type <node> Goal MainClass ExtendOpt Identifier Type
%type <node> ClassDeclarations ClassDeclarationList ClassDeclaration
%type <node> VarDeclarations VarDeclaration
%type <node> MethodDeclarations MethodDeclarationList MethodDeclaration
%type <node> TypeIdentifiers TypeIdentifierList TypeIdentifier
%type <node> Statements StatementList Statement
%type <node> Expressions ExpressionList Expression

%left Laccess Lbrace
%right '='
%left '.'
%left '*'
%left '+' '-'
%left And '<'
%right '!'

%start Goal

%%
Goal:
    MainClass ClassDeclarations 
    {
        $$ = new_node("Goal", 2, $1, $2);
        $$->line = yylineno;
        if (check($$))) {
            printf("Syntax tree:\n");
            Print($$, 0);
        }
    }
    ;

MainClass:
    Class Identifier Lbrace Public Static Void Main LBracket String Laccess Raccess Identifier RBracket Lbrace Statement Rbrace Rbrace
    {
        $$ = new_node("MainClass", 17, $1, $2, new_node("{", 0), $4, $5,
                                       $6, $7, $8, $9, new_node("[", 0), $11,
                                       $12, $13, new_node("{", 0), $15, $16,
                                       $17);
        $$->line = yylineno;
    }
    ;

ClassDeclarationList:
    ClassDeclaration 
    {
        $$ = new_node("ClassDeclarationList", 1, $1);
        $$->line = yylineno;
    }
|   ClassDeclarationList ClassDeclaration
    {
        $$ = new_node("ClassDeclarationList", 2, $1, $2);
        $$->line = yylineno;
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
        $$->line = yylineno;
    }
    ;

ClassDeclaration:
    Class Identifier ExtendOpt Lbrace VarDeclarations MethodDeclarations Rbrace
    {
        $$ = new_node("ClassDeclaration", 7, $1, $2, $3, new_node("{", 0),
                                             $5, $6, $7);
        $$->line = yylineno;
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
        $$->line = yylineno;
    }
    ;

VarDeclarations:
    /* empty */
    {
        $$ = NULL;
    }
|   VarDeclarations VarDeclaration
    {
        $$ = new_node("VarDeclarations", 1, $1);
        $$->line = yylineno;
    }
    ;

VarDeclaration:
    Type Identifier Semicolon
    {
        $$ = new_node("VarDeclaration", 3, $1, $2, $3);
        $$->line = yylineno;
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
        $$->line = yylineno;
    }
    ;

MethodDeclarationList:
    MethodDeclaration
    {
        $$ = new_node("MethodDeclarationList", 1, $1);
        $$->line = yylineno;
    }
|   MethodDeclarationList MethodDeclaration
    {
        $$ = new_node("MethodDeclarationList", 2, $1, $2);
        $$->line = yylineno;
    }
    ;

MethodDeclaration:
    Public Type Identifier LBracket TypeIdentifiers RBracket Lbrace VarDeclarations Statements Return Expression Semicolon Rbrace
    {
        $$ = new_node("MethodDeclaration", 13, $1, $2, $3, $4,
                                               $5, $6, new_node("{", 0),
                                               $8, $9, $10, $11,
                                               $12, $13);
        $$->line = yylineno;
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
        $$->line = yylineno;
    }
    ;

TypeIdentifierList:
    TypeIdentifier
    {
        $$ = new_node("TypeIdentifierList", 1, $1);
        $$->line = yylineno;
    }
|   TypeIdentifierList Comma TypeIdentifier
    {
        $$ = new_node("TypeIdentifierList", 3, $1, $2, $3);
        $$->line = yylineno;
    }
    ;

TypeIdentifier:
    Type Identifier
    {
        $$ = new_node("TypeIdentifer", 2, $1, $2);
        $$->line = yylineno;
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
        $$->line = yylineno;
    }
    ;

StatementList:
    Statement
    {
        $$ = new_node("StatementList", 1, $1);
        $$->line = yylineno;
    }
|   StatementList Statement
    {
        $$ = new_node("StatementList", 2, $1, $2);
        $$->line = yylineno;
    }
    ;

Type:
    Integer
    {
        $$ = new_node("Type", 1, $1);
        $$->line = yylineno;
    }
|   Integer Laccess Raccess
    {
        $$ = new_node("Type", 3, $1, new_node("[", 0), $3);
        $$->line = yylineno;
    }
|   Boolean
    {
        $$ = new_node("Type", 1, $1);
        $$->line = yylineno;
    }
|   Identifier
    {
        $$ = new_node("Type", 1, $1);
        $$->line = yylineno;
    }
    ;

Statement:
    Lbrace Statements Rbrace
    {
        $$ = new_node("Statement", 3, new_node("{", 0), $2, $3);
        $$->line = yylineno;
    }
|   If LBracket Expression RBracket Statement Else Statement
    {
        $$ = new_node("Statement", 7, $1, $2, $3, $4,
                                      $5, $6, $7);
        $$->line = yylineno;
    }
|   While LBracket Expression RBracket Statement
    {
        $$ = new_node("Statement", 5, $1, $2, $3, $4,
                                      $5);
        $$->line = yylineno;
    }
|   Println LBracket Expression RBracket Semicolon
    {
        $$ = new_node("Statement", 5, $1, $2, $3, $4,
                                      $5);
        $$->line = yylineno;
    }
|   Identifier '=' Expression Semicolon
    {
        $$ = new_node("Statement", 4, $1, new_node("=", 0), $3, $4);
        $$->line = yylineno;
    }
|   Identifier Laccess Expression Raccess '=' Expression Semicolon
    {
        $$ = new_node("Statement", 7, $1, new_node("[", 0), $3, $4,
                                      new_node("=", 0), $6, $7);
        $$->line = yylineno;
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
        $$->line = yylineno;
    }
    ;

ExpressionList:
    Expression
    {
        $$ = new_node("ExpressionList", 1, $1);
        $$->line = yylineno;
    }
|   ExpressionList Comma Expression
    {
        $$ = new_node("ExpressionList", 3, $1, $2, $3);
        $$->line = yylineno;
    }
    ;

Expression:
    Expression And Expression
    {
        $$ = new_node("Expression", 3, $1, new_node("$$", 0), $3);
        $$->line = yylineno;
    }
|   Expression '<' Expression
    {
        $$ = new_node("Expression", 3, $1, new_node("<", 0), $3);
        $$->line = yylineno;
    }
|   Expression '+' Expression
    {
        $$ = new_node("Expression", 3, $1, new_node("+", 0), $3);
        $$->line = yylineno;
    }
|   Expression '-' Expression
    {
        $$ = new_node("Expression", 3, $1, new_node("-", 0), $3);
        $$->line = yylineno;
    }
|   Expression '*' Expression
    {
        $$ = new_node("Expression", 3, $1, new_node("*", 0), $3);
        $$->line = yylineno;
    }
|   Expression Laccess Expression Raccess
    {
        $$ = new_node("Expression", 4, $1, new_node("[", 0), $3, $4);
        $$->line = yylineno;
    }
|   Expression '.' Length
    {
        $$ = new_node("Expression", 3, $1, new_node(".", 0), $3);
        $$->line = yylineno;
    }
|   Expression '.' Identifier LBracket Expressions RBracket
    {
        $$ = new_node("Expression", 6, $1, new_node(".", 0), $3,
                                       $4, $5, $6);
        $$->line = yylineno;
    }
|   True
    {
        $$ = new_node("Expression", 1, $1);
        $$->line = yylineno;
    }
|   False
    {
        $$ = new_node("Expression", 1, $1);
        $$->line = yylineno;
    }
|   Identifier
    {
        $$ = new_node("Expression", 1, $1);
        $$->line = yylineno;
    }
|   This
    {
        $$ = new_node("Expression", 1, $1);
        $$->line = yylineno;
    }
|   New Integer Laccess Expression Raccess
    {
        $$ = new_node("Expression", 5, $1, $2, new_node("[", 0), $4, $5);
        $$->line = yylineno;
    }
|   New Identifier LBracket RBracket
    {
        $$ = new_node("Expression", 4, $1, $2, $3, $4);
        $$->line = yylineno;
    }
|   '!' Expression
    {
        $$ = new_node("Expression", 2, new_node("!", 0), $2);
        $$->line = yylineno;
    }
|   LBracket Expression RBracket
    {
        $$ = new_node("Expression", 3, $1, $2, $3);
        $$->line = yylineno;
    }
|   IntegerIteral
    {
        $$ = new_node("Expression", 1, $1);
        $$->line = yylineno;
    }
    ;

Identifier:
    Id
    {
        $$ = new_node("Expression", 1, $1);
        $$->line = yylineno;
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
