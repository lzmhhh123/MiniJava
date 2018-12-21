# MiniJava
MiniJava compiler built by yacc &amp; lex.

```bash
sudo apt-get install bison flex
yacc -d parser.y
lex lexer.l
gcc node.c parser.tab.c lex.yy.c
```
To run example: `cat example.minijava | ./a.out`

The syntax tree is printed as follow:
```
Syntax tree:
Goal
  MainClass
    class
    Expression
      identifier: MainClass
    {
    public
    static
    void
    main
    (
    String
    [
    ]
    Expression
      identifier: args
    )
    {
    Statement
      System.out.println
      (
      Expression
        IntegerIteral: 0
      )
      ;
    }
    }
  ClassDeclarations
    ClassDeclarationList
      ClassDeclarationList
        ClassDeclaration
          class
          Expression
            identifier: CC
          {
          VarDeclarations
            VarDeclarations
          MethodDeclarations
            MethodDeclarationList
              MethodDeclarationList
                MethodDeclaration
                  public
                  Type
                    int
                  Expression
                    identifier: method1
                  (
                  TypeIdentifiers
                    TypeIdentifierList
                      TypeIdentifierList
                        TypeIdentifierList
                          TypeIdentifer
                            Type
                              int
                            Expression
                              identifier: i1
                        ,
                        TypeIdentifer
                          Type
                            int
                          Expression
                            identifier: i2
                      ,
                      TypeIdentifer
                        Type
                          boolean
                        Expression
                          identifier: b
                  )
                  {
                  VarDeclarations
                    VarDeclarations
                      VarDeclarations
                        VarDeclarations
                          VarDeclarations
                  Statements
                    StatementList
                      StatementList
                        StatementList
                          StatementList
                            StatementList
                              StatementList
                                Statement
                                  Expression
                                    identifier: arr
                                  =
                                  Expression
                                    new
                                    int
                                    [
                                    Expression
                                      IntegerIteral: 5
                                    ]
                                  ;
                              Statement
                                Expression
                                  identifier: arr
                                [
                                Expression
                                  IntegerIteral: 2
                                ]
                                =
                                Expression
                                  Expression
                                    Expression
                                      Expression
                                        identifier: arr
                                    [
                                    Expression
                                      IntegerIteral: 1
                                    ]
                                  +
                                  Expression
                                    IntegerIteral: 1
                                ;
                            Statement
                              if
                              (
                              Expression
                                !
                                Expression
                                  false
                              )
                              Statement
                                {
                                Statements
                                  StatementList
                                    StatementList
                                      Statement
                                        Expression
                                          identifier: b
                                        =
                                        Expression
                                          false
                                        ;
                                    Statement
                                      Expression
                                        identifier: rv
                                      =
                                      Expression
                                        IntegerIteral: 1
                                      ;
                                }
                              else
                              Statement
                                {
                                Statements
                                  StatementList
                                    StatementList
                                      StatementList
                                        Statement
                                          Expression
                                            identifier: rv
                                          =
                                          Expression
                                            Expression
                                              IntegerIteral: 2
                                            +
                                            Expression
                                              IntegerIteral: 3
                                          ;
                                      Statement
                                        Expression
                                          identifier: rv
                                        =
                                        Expression
                                          Expression
                                            true
                                          +
                                          Expression
                                            IntegerIteral: 1
                                        ;
                                    Statement
                                      Expression
                                        identifier: b
                                      =
                                      Expression
                                        Expression
                                          Expression
                                            identifier: b
                                        $$
                                        Expression
                                          true
                                      ;
                                }
                          Statement
                            if
                            (
                            Expression
                              Expression
                                identifier: b
                            )
                            Statement
                              Expression
                                identifier: rv
                              =
                              Expression
                                IntegerIteral: 1
                              ;
                            else
                            Statement
                              Expression
                                identifier: rv
                              =
                              Expression
                                IntegerIteral: 2
                              ;
                        Statement
                          while
                          (
                          Expression
                            Expression
                              true
                            $$
                            Expression
                              false
                          )
                          Statement
                            {
                            Statements
                              StatementList
                                StatementList
                                  Statement
                                    Expression
                                      identifier: rv
                                    =
                                    Expression
                                      IntegerIteral: 2
                                    ;
                                Statement
                                  Expression
                                    identifier: rv
                                  =
                                  Expression
                                    Expression
                                      Expression
                                        identifier: arr
                                    .
                                    length
                                  ;
                            }
                      Statement
                        while
                        (
                        Expression
                          Expression
                            IntegerIteral: 5
                          <
                          Expression
                            IntegerIteral: 10
                        )
                        Statement
                          Expression
                            identifier: rv
                          =
                          Expression
                            Expression
                              Expression
                                identifier: rv
                            +
                            Expression
                              IntegerIteral: 1
                          ;
                  return
                  Expression
                    Expression
                      identifier: rv
                  ;
                  }
              MethodDeclaration
                public
                Type
                  int
                Expression
                  identifier: desugarme
                (
                )
                {
                VarDeclarations
                  VarDeclarations
                    VarDeclarations
                      VarDeclarations
                        VarDeclarations
                Statements
                  StatementList
                    Statement
                      Expression
                        identifier: x
                      =
                      Expression
                        Expression
                          Expression
                            identifier: x
                        *
                        Expression
                          Expression
                            Expression
                              Expression
                                Expression
                                  identifier: y
                              +
                              Expression
                                IntegerIteral: 1
                            +
                            Expression
                              Expression
                                identifier: z
                          +
                          Expression
                            IntegerIteral: 010
                      ;
                return
                Expression
                  IntegerIteral: 0
                ;
                }
          }
      ClassDeclaration
        class
        Expression
          identifier: CCC
        ExtendOpt
          extends
          Expression
            identifier: CC
        {
        VarDeclarations
        }
```
