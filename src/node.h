#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <stdarg.h>

struct Node {
    char *val;
    int children_size;
    int line;
    struct Node **children;
};

struct Node* new_node(char *s, int children_size, ...);

void Print(struct Node *r, int level);

int check(struct Node *r);
