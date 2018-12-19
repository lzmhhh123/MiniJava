%{
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include "node.h"
#include "y.tab.h"

int yylineno;
%}

%%
"class"                       { yylval.node = new_node(yytext, 0); return Class; }
"public"                      { yylval.node = new_node(yytext, 0); return Public; }
"static"                      { yylval.node = new_node(yytext, 0); return Static; }
"void"                        { yylval.node = new_node(yytext, 0); return Void; }
"main"                        { yylval.node = new_node(yytext, 0); return Main; }
"if"                          { yylval.node = new_node(yytext, 0); return If; }
"else"                        { yylval.node = new_node(yytext, 0); return Else; }
"while"                       { yylval.node = new_node(yytext, 0); return While; }
"extends"                     { yylval.node = new_node(yytext, 0); return Extends; }
"int"                         { yylval.node = new_node(yytext, 0); return Integer; }
"boolean"                     { yylval.node = new_node(yytext, 0); return Boolean; }
"string"                      { yylval.node = new_node(yytext, 0); return String; }
"true"                        { yylval.node = new_node(yytext, 0); return True; }
"false"                       { yylval.node = new_node(yytext, 0); return False; }
[a-zA-Z]([a-zA-Z]|[0-9]|"_")* { 
                                char *val = (char*)malloc(strlen("identifier: ")+strlen(yytext));
                                sprint(val, "identifier: %s", val);
                                yylval.node = new_node(val, 0);
                                return Id;
                              }
[1-9]([0-9])*                 { 
                                char *val = (char*)malloc(strlen("IntegerIteral: ")+strlen(yytext));
                                sprint(val, "IntegerIteral: %s", val);
                                yylval.node = new_node(val, 0); 
                                return IntegerIteral;
                              }
("0x"|"0X")([0-9]|[a-fA-F])+  { 
                                char *val = (char*)malloc(strlen("IntegerIteral: ")+strlen(yytext));
                                sprint(val, "IntegerIteral: %s", val);
                                yylval.node = new_node(val, 0); 
                                return IntegerIteral; 
                              }
("0b"|"0B")("0"|"1")+         { 
                                char *val = (char*)malloc(strlen("IntegerIteral: ")+strlen(yytext));
                                sprint(val, "IntegerIteral: %s", val);
                                yylval.node = new_node(val, 0); 
                                return IntegerIteral; 
                              }
"0"([0-8])+                   { 
                                char *val = (char*)malloc(strlen("IntegerIteral: ")+strlen(yytext));
                                sprint(val, "IntegerIteral: %s", val);
                                yylval.node = new_node(val, 0); 
                                return IntegerIteral; 
                              }
"this"                        { yylval.node = new_node(yytext, 0); return This; }
"new"                         { yylval.node = new_node(yytext, 0); return New; }
"System.out.println"          { yylval.node = new_node(yytext, 0); return Println; }
"length"                      { yylval.node = new_node(yytext, 0); return Length; }
"return"                      { yylval.node = new_node(yytext, 0); return Return; }

"&&"  { return And; }
"."   { return '.'; }
"="   { return '='; }
"+"   { return '+'; }
"-"   { return '-'; }
"*"   { return '*'; }
"<"   { return '<'; }
"!"   { return '!'; }

"{"   { yylval.node = new_node(yytext, 0); return '{'; }
"}"   { yylval.node = new_node(yytext, 0); return '}'; }
"["   { yylval.node = new_node(yytext, 0); return '['; }
"]"   { yylval.node = new_node(yytext, 0); return ']'; }
"("   { yylval.node = new_node(yytext, 0); return '('; }
")"   { yylval.node = new_node(yytext, 0); return ')'; }
";"   { yylval.node = new_node(yytext, 0); return ';'; }
","   { yylval.node = new_node(yytext, 0); return ','; }

"//".*"\n"         { yylineno++; }
"/*"(.|"\n")*"*\\" { yylineno++; }
" "|"\t"|"\r"      { /*do nothing*/ }
"\n"               { yylineno++; }
.                  { yyerror("Unkown word."); }

%%
