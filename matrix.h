#ifndef matrix_h
#define matrix_h

#include <map>

typedef std::map<int,float> datos;
typedef std::map<int,datos> tabla;

typedef struct
{
    int n, m;   	// Number of rows and columns
    tabla data;		// Content of the matrix
} matrix;

#endif
