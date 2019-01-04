%{
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include "node.h"
#include "parser.tab.h"

int yylineno;
%}

%option noyywrap

%%
"class"                       { yylval.node = new_node(yytext, 0); yylval.node->line = yylineno; return Class; }
"public"                      { yylval.node = new_node(yytext, 0); yylval.node->line = yylineno; return Public; }
"static"                      { yylval.node = new_node(yytext, 0); yylval.node->line = yylineno; return Static; }
"void"                        { yylval.node = new_node(yytext, 0); yylval.node->line = yylineno; return Void; }
"main"                        { yylval.node = new_node(yytext, 0); yylval.node->line = yylineno; return Main; }
"if"                          { yylval.node = new_node(yytext, 0); yylval.node->line = yylineno; return If; }
"else"                        { yylval.node = new_node(yytext, 0); yylval.node->line = yylineno; return Else; }
"while"                       { yylval.node = new_node(yytext, 0); yylval.node->line = yylineno; return While; }
"extends"                     { yylval.node = new_node(yytext, 0); yylval.node->line = yylineno; return Extends; }
"int"                         { yylval.node = new_node(yytext, 0); yylval.node->line = yylineno; return Integer; }
"boolean"                     { yylval.node = new_node(yytext, 0); yylval.node->line = yylineno; return Boolean; }
"String"                      { yylval.node = new_node(yytext, 0); yylval.node->line = yylineno; return String; }
"true"                        { yylval.node = new_node(yytext, 0); yylval.node->line = yylineno; return True; }
"false"                       { yylval.node = new_node(yytext, 0); yylval.node->line = yylineno; return False; }
"this"                        { yylval.node = new_node(yytext, 0); yylval.node->line = yylineno; return This; }
"new"                         { yylval.node = new_node(yytext, 0); yylval.node->line = yylineno; return New; }
"System.out.println"          { yylval.node = new_node(yytext, 0); yylval.node->line = yylineno; return Println; }
"length"                      { yylval.node = new_node(yytext, 0); yylval.node->line = yylineno; return Length; }
"return"                      { yylval.node = new_node(yytext, 0); yylval.node->line = yylineno; return Return; }
[a-zA-Z]([a-zA-Z]|[0-9]|"_")* { 
                                char *val = (char*)malloc(strlen("identifier: ")+strlen(yytext)+10);
                                sprintf(val, "identifier: %s", yytext);
                                yylval.node = new_node(val, 0);
                                yylval.node->line = yylineno;
                                return Id;
                              }
[1-9]([0-9])*                 { 
                                char *val = (char*)malloc(strlen("IntegerIteral: ")+strlen(yytext)+10);
                                sprintf(val, "IntegerIteral: %s", yytext);
                                yylval.node = new_node(val, 0); 
                                yylval.node->line = yylineno;
                                return IntegerIteral;
                              }
("0x"|"0X")([0-9]|[a-fA-F])+  { 
                                char *val = (char*)malloc(strlen("IntegerIteral: ")+strlen(yytext)+10);
                                sprintf(val, "IntegerIteral: %s", yytext);
                                yylval.node = new_node(val, 0); 
                                yylval.node->line = yylineno;
                                return IntegerIteral; 
                              }
("0b"|"0B")("0"|"1")+         { 
                                char *val = (char*)malloc(strlen("IntegerIteral: ")+strlen(yytext)+10);
                                sprintf(val, "IntegerIteral: %s", yytext);
                                yylval.node = new_node(val, 0); 
                                yylval.node->line = yylineno;
                                return IntegerIteral; 
                              }
"0"([0-8])*                   { 
                                char *val = (char*)malloc(strlen("IntegerIteral: ")+strlen(yytext)+10);
                                sprintf(val, "IntegerIteral: %s", yytext);
                                yylval.node = new_node(val, 0); 
                                yylval.node->line = yylineno;
                                return IntegerIteral; 
                              }

"&&"  { return And; }
"."   { return '.'; }
"="   { return '='; }
"+"   { return '+'; }
"-"   { return '-'; }
"*"   { return '*'; }
"<"   { return '<'; }
"!"   { return '!'; }

"{"   { return Lbrace; }
"}"   { yylval.node = new_node(yytext, 0); yylval.node->line = yylineno; return Rbrace; }
"["   { return Laccess; }
"]"   { yylval.node = new_node(yytext, 0); yylval.node->line = yylineno; return Raccess; }
"("   { yylval.node = new_node(yytext, 0); yylval.node->line = yylineno; return LBracket; }
")"   { yylval.node = new_node(yytext, 0); yylval.node->line = yylineno; return RBracket; }
";"   { yylval.node = new_node(yytext, 0); yylval.node->line = yylineno; return Semicolon; }
","   { yylval.node = new_node(yytext, 0); yylval.node->line = yylineno; return Comma; }

"//".*"\n"         { yylineno++; }
"/*"(.|"\n")*"*\\" { yylineno++; }
" "|"\t"|"\r"      { /*do nothing*/ }
"\n"               { yylineno++; }
.                  { fprintf(stderr, "Unkown word."); }

%%
