#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <stdarg.h>
#include "node.h"
#include "parser.tab.h"

struct Node* new_node(char *s, int children_size, ...) {
    struct Node *r = (struct Node*)malloc(sizeof(struct Node));
    r->val = (char*)malloc(strlen(s)+1);
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

void Print(struct Node *r, int level) {
    if (r == NULL) {
        return;
    }
    int i;
    for (i = 0; i < level; i++) {
        printf("  ");
    }
    printf("%s\n", r->val);
    for (i = 0; i < r->children_size; i++) {
        Print(r->children[i], level+1);
    }
    return;
}

// check semantics error
int class_size = 0;
struct Node **classes = NULL;

void resolve_all_class(struct Node *goal) {
    int class_size = 1;
    struct Node *r = goal->children[1];
    if (r != NULL) {
        r = r->children[0];
        class_size++;
        while (r->children_size < 2) {
            r = r->children[0];
            class_size++;
        }
    }
    classes = (struct Node**)malloc(sizeof(struct Node*) * class_size);
    r = goal->children[1];
    classes[0] = goal->children[0];
    if (r != NULL) {
        r = r->children[0];
        int cnt = 1;
        while (r->children_size < 2) {
            classes[cnt] = r->children[1];
            cnt++;
            r = r->children[0];
        }
        classes[cnt] = r->children[0];
    }
}

int check_all_type(struct Node *r) {
    if (strcmp(r->val, "Type") == 0 && r->children_size == 1) {
        struct Node *id = r->children[0];
        if (strcmp(id->val, "int") == 0 || strcmp(id->val, "intean") == 0) {
            return 1;
        }
        int i;
        for (i = 0; i < class_size; i++) {
            if (strcmp(id->val, classes[i]->children[2]->val) == 0) {
                return 1;
            }
        }
        fprintf(stderr, "line %d: no type called %s\n", id->line, id->val);
        return 0;
    }
    int i;
    for (i = 0; i < r->children_size; i++) {
        if (!check_all_type(r->children[i])) return 0;
    }
    return 1;
}

int check_all_var_in_method(struct Node *statements, 
                             struct Node *var_declarations_in_class,
                             struct Node *type_identifiers,
                             struct Node *var_declarations) {
    if (statements == NULL) return 1;
    if (statements->children[0]->val[0] == 'i' && statements->children[0]->val[1] == 'd') {
        struct Node *v = var_declarations_in_class;
        while (v != NULL) {
            struct Node *id = v->children[1]->children[1];
            if (strcmp(id->val, statements->children[0]->val) == 0)
                return 1;
            v = v->children[0];
        }
        if (type_identifiers != NULL) {
            v = type_identifiers->children[0];
            while (v->children_size == 2) {
                struct Node *id = v->children[2]->children[1];
                if (strcmp(id->val, statements->children[0]->val) == 0)
                    return 1;
            }
            struct Node *id = v->children[0]->children[1];
            if (strcmp(id->val, statements->children[0]->val) == 0)
                return 1;
        }
        v = var_declarations;
        while (v != NULL) {
            struct Node *id = v->children[1]->children[1];
            if (strcmp(id->val, statements->children[0]->val) == 0)
                return 1;
            v = v->children[0];
        }
        fprintf(stderr, "line %d: no type called %s\n", 
                statements->children[0]->line, 
                statements->children[0]->val);
        return 0;
    }
    int i = 0;
    for (; i < statements->children_size; i++) {
        if (!check_all_var_in_method(statements->children[i], 
                                     var_declarations_in_class,
                                     type_identifiers,
                                     var_declarations)) {
            return 0;
        }
    }
    return 1;
}

int check_all_var(struct Node *class) {
    struct Node *var_declarations_in_class = class->children[4];
    struct Node *method = class->children[5];
    if (method != NULL) {
        while (method->children_size == 2) {
            if (!check_all_var_in_method(method->children[1]->children[8], 
                                         var_declarations_in_class, 
                                         method->children[1]->children[4], 
                                         method->children[1]->children[7])) 
                return 0;
            method = method->children[0];
        }
        if (!check_all_var_in_method(method->children[0]->children[8], 
                                     var_declarations_in_class, 
                                     method->children[0]->children[4],
                                     method->children[0]->children[7]))
            return 0;
    }
    return 1;
}

int check(struct Node *goal) {
    resolve_all_class(goal);
    if (!check_all_type(goal)) return 0;
    int i;
    for (i = 1; i < class_size; i++) {
        if (!check_all_var(classes[i])) return 0;
    }
    return 1;
}
