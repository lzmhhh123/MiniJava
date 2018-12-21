#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <stdarg.h>
#include "node.h"

struct Node* new_node(char *s, int children_size, ...) {
    struct Node *r = (struct Node*)malloc(sizeof(struct Node));
    r->val = (char*)malloc(sizeof(s)+1);
    strcpy(r->val, s);
    r->children_size = children_size;
    r->children = (struct Node**)malloc(sizeof(struct Node*)*children_size);
    int i;
    va_list list;
    va_start(list, children_size);
    for (i = 0; i < children_size; i++) {
        r->children[i] = va_arg(list, struct Node*);
    }
    return r;
}

void DFS(struct Node *r, int level) {
    if (r == NULL) {
        return;
    }
    int i;
    for (i = 0; i < level; i++) {
        printf("  ");
    }
    printf("%s\n", r->val);
    for (i = 0; i < r->children_size; i++) {
        DFS(r->children[i], level+1);
    }
    return;
}
