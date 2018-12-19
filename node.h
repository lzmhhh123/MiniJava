#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <stdarg.h>

struct node {
    char *val;
    node **children;
};

node* new_node(char *s, int children_size, ...) {
    node *r = (node*)malloc(sizeof(node));
    r->val = (char*)malloc(sizeof(s)+1);
    strcpy(r->val, s);
    r->children = (node**)malloc(sizeof(node*)*children_size);
    int i;
    va_list list;
    va_start(list, children_size);
    for (i = 0; i < children_size; i++) {
        r->children[i] = va_arg(list, struct node*);
    }
    return r;
}