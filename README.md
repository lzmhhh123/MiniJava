# MiniJava
MiniJava compiler built by yacc &amp; lex.

```bash
sudo apt-get install bison flex
yacc -d parser.y
lex lexer.l
gcc node.c parser.tab.c lex.yy.c
```
