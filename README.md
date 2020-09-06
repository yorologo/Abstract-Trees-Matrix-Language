# Abstract Trees, Matrix Language
Language for solving matrix calculation problems created from lexical and syntactic analyzer generators.

## Requirements

- _Lex_ or _Flex_
- _Yacc_ or _Bison_
- _C++_ compiler

## Instructions for use

1.  Execute _Lex_ or _Flex_ with the arguments `-o scanner.cpp scanner.l`
2.  Execute _Yacc_ or _Bison_ with the argument `-d parser.y -o parser.cpp`
3.  Compile the _main.cpp_ file
4.  Edit the _test.txt_ file, write here the matrix operation you want to perform respecting the grammar below
5.  Ejecuta el programa

## Grammar of atributes

| Produccion             | Regla Semantica                                  |
| ---------------------- | ------------------------------------------------ |
| main = stseq .         | main :                                           |
| stseq = stseq ; st     | stseq :                                          |
| stseq = st             | stseq :                                          |
| st = assign            | st :                                             |
| st = throwing          | st :                                             |
| assign = id : mexp     | assign := dual[ID.str_id] = evaluate(mexp.p.val) |
| throwing = throw mexp  | throwing.matriz : show(evaluate(mexp.p))         |
| mexp = mexp + mexp     | mexp.p := createNode(\_sum, mexp.p, mexp.p)      |
| mexp = mexp - mterm    | mexp.p := createNode(\_dif, mexp.p, mterm.p)     |
| mexp = mterm           | mexp.p := mterm.p                                |
| mterm = mterm \* mfact | mterm.p := createNode(\_mul, mterm.p, mfact.p)   |
| mterm = mfact          | mterm.p := mfact.p                               |
| mfact = ( mexp )       | mfact.p := mexp.p                                |
| mfact = mdef           | mfact.p := createNode(mdef.matriz)               |
| mfact = id             | mfact.p := createNode(dual[ID.str_id])           |
| mdef = [ rowseq ]      | mdef.matriz := createMatrix(y)                   |
| rowseq = rowseq ; row  | rowseq : contA++; y[contA] = x                   |
| rowseq = row           | rowseq : y.clear(); contA = 1; y[contA] = x      |
| row = row , exp        | row : contB++; x[contB] = exp.val                |
| row = exp              | row : x.clear(); contB = 1; x[contB] = exp.val   |
| exp = exp + term       | exp.val := exp.val + term.val                    |
| exp = exp - term       | exp.val := exp.val - term.val                    |
| exp = term             | exp.val := term.val                              |
| term = term \* fact    | term.val := term.val \* fact.val                 |
| term = term / fact     | term.val := term.val / fact.val                  |
| term = fact            | term.val := fact.val                             |
| fact = - fact          | fact.val := 0 - fact.val                         |
| fact = ( exp )         | fact.val := exp.val                              |
| fact = num             | fact.val := NUM.val                              |
