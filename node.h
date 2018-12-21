#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <stdarg.h>

struct Node {
    char *val;
    int children_size;
    struct Node **children;
};

struct Node* new_node(char *s, int children_size, ...);

void DFS(struct Node *r, int level);

