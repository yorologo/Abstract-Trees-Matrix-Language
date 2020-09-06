#ifndef node_h
#define node_h

#include "matrix.h"

typedef enum
{
    _sum,
    _dif,
    _mul,
    _div,
    _neg,
    _mat
} tnode;

typedef struct x
{
    tnode type;        // Node type ('+', '-', '*' or 'M')
    matrix *M;       // Matrix associated to the node
    struct x* lft;   // Link to left sub-tree
    struct x* rgt;   // Link to right sub-tree
} node;

#endif