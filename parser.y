%{

//  win_bison -d parser.y -o parser.cpp

#include <stdio.h>
#include <iostream>
#include <map>
#include "node.h"
#include "matrix.h"

extern int yylex();
extern int line_count;

typedef std::map<int,float> datos;
typedef std::map<int,datos> tabla;

int contA, contB;
datos x;
tabla y;
node* root = NULL;
std::map<std::string, matrix*> dual;

node* createNode(tnode, node*, node*);
node* createNode(tnode, node*);
node* createNode(matrix*);

matrix* createMatrix(tabla);
matrix* evaluate(node*);
matrix* add(matrix*, matrix*);
matrix* subs(matrix*, matrix*);
matrix* mult(matrix*, matrix*);

void show(matrix*);
int yyerror(const char*);

%}

%union{
	float val;
  char* str_id;
  matrix* matr;
  node* p;
}

%token THROW

%token <val> NUM
%token <str_id> ID;

%type <p> mfact mterm mexp
%type <matr> mdef throwing
%type <val> fact term exp

%start main

%%

main:
  stseq '.'
  ;

stseq:
  stseq ';' st
  | st
  ;

st:
  assign 
  | throwing
  ;

assign:
  ID ':' mexp { dual[$1] = evaluate($3); }
  ;

throwing:
  THROW mexp { show(evaluate($2)); }
  ;

mexp:
  mexp '+' mterm { $$ = createNode(_sum, $1, $3); }
  | mexp '-' mterm { $$ = createNode(_dif, $1, $3); }
  | mterm { $$ = $1; }
  ;

mterm:
  mterm '*' mfact { $$ = createNode(_mul, $1, $3); }
  | mfact { $$ = $1; }
  ;

mfact:
  '(' mexp ')' { $$ = $2; }
  | mdef { $$ = createNode($1); }
  | ID { $$ = createNode(dual[$1]); }
  ;

mdef:
  '[' rowseq ']' { $$ = createMatrix(y); }
  ;

rowseq:
  rowseq ';' row  { contA++;  y[contA] = x; }
  | row { y.clear(); contA = 1; y[contA] = x; }
  ;

row:
  row ',' exp { contB++; x[contB] = $3; }
  | exp { x.clear(); contB = 1; x[contB] = $1; }
  ; 

exp:
  exp '+' term { $$ = $1 + $3; }
  | exp '-' term { $$ = $1 - $3; }
  | term { $$ = $1; }
  ;

term:
  term '*' fact { $$ = $1*  $3; }
  | term '/' fact { $$ = $1 / $3; }
  | fact { $$ = $1; }
  ;

fact:
  '-' fact { $$ = 0 - $2; }
  | '(' exp ')' { $$ = $2; }
  | NUM { $$ = $1; }
  ;

%%

/***********************************************
Funciones de Nodos
***********************************************/

node* createNode(tnode t, node* l, node* r){
  node* p = new node;

  p -> type = t;
  p -> M = NULL;
  p -> lft = l;
  p -> rgt = r;

  return p;
}

node* createNode(tnode t, node* l){
  node* p = new node;

  p -> type = t;
  p -> M = NULL;
  p -> lft = l;
  p -> rgt = NULL;

  return p;
}

node* createNode(matrix* x){
  node* p = new node;

  p -> type = _mat;
  p -> M = x;
  p -> lft = NULL;
  p -> rgt = NULL;

  return p;
}

/***********************************************
Funciones de Matrices
***********************************************/


matrix* evaluate(node* p){

  switch(p->type){
    case _sum: return add(evaluate(p -> lft), evaluate(p -> rgt));
    case _dif: return subs(evaluate(p -> lft), evaluate(p -> rgt));
    case _mul: return mult(evaluate(p -> lft), evaluate(p -> rgt));
    case _mat: return p->M;
  }

  return NULL;

}

matrix* createMatrix(tabla x){
  matrix* p = new matrix;

  p -> n = x.size();
  p -> m = x[1].size();

  p->data = x;

  return p;
}

matrix* add(matrix* a, matrix* b){
  if(a -> n == b -> n && a -> m == b -> m)
  {
    for(int i = 1; i <= a -> n; i++)
      for(int j = 1; j <= a -> m; j++)
        a -> data[i][j] += b -> data[i][j];

    return a;
  }
  return NULL;
}

matrix* subs(matrix* a, matrix* b){
  if(a -> n == b -> n && a -> m == b -> m)
  {
    for(int i = 1; i <= a -> n; i++)
      for(int j = 1; j <= a -> m; j++)
        a -> data[i][j] -= b -> data[i][j];

    return a;
  }
  return NULL;
}

matrix* mult(matrix* a, matrix* b){
  if(a -> m == b -> n)
  {
    matrix* p = new matrix;

    p -> n = a -> n;
    p -> m = b -> m;
    for(int i = 1; i <= p -> n; i++)
      for(int j = 1; j <= p -> m; j++){
        p -> data[i][j] = 0;
        for(int k = 1; k <= a -> m; k++)
          p -> data[i][j] += a -> data[i][k] * b -> data[k][j];
      }
    return p;
  }
  return NULL;
}

/***********************************************
Funciones
***********************************************/
void show(matrix* p){
  printf("{\n");
  for(int i = 1; i <= p -> n; i++){
    for(int j = 1; j <= p -> m; j++){
      printf("%6.2f%s", p -> data[i][j], (j != p -> m)?", ":";\n");
    }
  }
  printf("}\n");
}

int yyerror(const char* mssg){
	printf("Error in line %i: %s\n", line_count, mssg);

	return 0;
}
