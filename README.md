# gsl-lua: A Lua binding for the GLS library
## Introduction
**gsl-lua** is a numerical package based on the [GSL library](http://www.gnu.org/software/gsl/). It exposes a simple interface to some of the GSL library routines and data types. 

GSL data types are integrated by providing wrapper objects that can be naturally operated upon from Lua. For instance, it supports arithmetic operators on vectors and matrices, interpolating and fitting functors, and more. Therefore, code such as the following can be written:

	-- Creates two vectors with the given elements
	x = gsl.Vector{1, 2, 5, 9, 15}
	y = gsl.Vector{5, 6, 7, 8, 10}
	print(x[1], x[4]) -- prints 1, 9
	
	-- Vector operations
	a = x + y			-- a = |6, 8, 12, 17, 25|
	b = x * y			-- b = |5, 12, 35, 72, 150|
	print(gsl.Vector{3, 4}:norm())	-- prints 5
	c = a['@[i] > 15']	-- c = |17, 25|; selects all elements larger than 15
	d = a:map('i <= 3', '@[i]^2')	-- d = |36, 64, 144|; selects first 3 elements and square them
	
	-- Fits 
	poly3 = gsl.fit.poly(3)				-- a third degree polynomial
	fit = gsl.lsfit({x, poly3}, y, nil, "fmulti") -- fits x and y with poly3
	print(fit:coeffs(), fit:chisq())	-- |4.887, 4.180e-1, -5.387e-3|    2.52e-1

Currently, it includes support for vectors and matrices, 
numerical integration, interpolation and least-squares fitting. The GSL library functions are called using the [Alien](http://alien.luaforge.net), and the large majority of the library is written in Lua and easy to extend.

gsl-lua has been tested with Lua 5.1.4 and LuaJIT 2.0 (beta 6).

## Installation
This module requires the following libraries to be installed in the Lua module searchpath:

* [Alien](http://alien.luaforge.net/) (installable through [LuaRocks](http://luarocks.org/))
* [GSL](http://www.gnu.org/software/gsl/) (through your package manager, or MacPorts for Mac OS X)

Run the make.lua script to compile the library and install it. 

## License
gsl-lua is a wrapper for GSL, therefore inherits the [GPL licence](http://www.gnu.org/copyleft/gpl.html).

***********************

## Index

**[gsl][]**

 &bull; [gsl.Matrix(fun, nrows, ncols)][] &bull; [gsl.Matrix(mat)][] &bull; [gsl.Matrix(nrows, ncols)][] &bull; [gsl.Vector(fun, len)][] &bull; [gsl.Vector(len)][] &bull; [gsl.Vector(tbl)][] &bull; [gsl.Vector(vec)][] &bull; [gsl.fast][] &bull; [gsl.import()][] &bull; [gsl.isnan(a)][] &bull; [gsl.kron(i, j)][] &bull; [gsl.lu(A)][] &bull; [gsl.ludet(A, signum)][] &bull; [gsl.luinvert(A, p)][] &bull; [gsl.lulndet(A, signum)][] &bull; [gsl.lusolve(A, p, b)][] &bull; [gsl.mmul(A, B)][] &bull; [gsl.number_format][] &bull; [gsl.prec][] &bull; [gsl.seterrorfnc(f)][] &bull; [gsl.transpose(matrix)][]

**[gsl.consts][]**

 &bull; [gsl.consts.PREC_APPROX][] &bull; [gsl.consts.PREC_DOUBLE][] &bull; [gsl.consts.PREC_SINGLE][]

**[gsl.matrix][]**

 &bull; [gsl.matrix.add(a, b) / sub(a, b) / mul(a, b) / div(a, b)][] &bull; [gsl.matrix.det(M, [algo])][] &bull; [gsl.matrix.invert(M, [algo])][] &bull; [gsl.matrix.map(m, cond, [val])][] &bull; [gsl.matrix.mmul(A, B)][] &bull; [gsl.matrix.ncols(m)][] &bull; [gsl.matrix.nrows(m)][] &bull; [gsl.matrix.solve(A, b, [algo])][] &bull; [gsl.matrix.table(M)][] &bull; [gsl.matrix.transpose(M)][]

**[gsl.vector][]**

 &bull; [gsl.vector.add(a, b) / sub(a, b) / mul(a, b) / div(a, b)][] &bull; [gsl.vector.asum(v)][] &bull; [gsl.vector.copy(v)][] &bull; [gsl.vector.dot(a, b)][] &bull; [gsl.vector.iter(vector, [cond])][] &bull; [gsl.vector.length(v)][] &bull; [gsl.vector.map(v, cond, [repl])][] &bull; [gsl.vector.min(v) / max(v) / minmax(v)][] &bull; [gsl.vector.min\_index(v) / max\_index(v) / minmax\_index(v)][] &bull; [gsl.vector.norm(v)][] &bull; [gsl.vector.set_all(v, n)][] &bull; [gsl.vector.set_zero(v)][] &bull; [gsl.vector.sum(v)][] &bull; [gsl.vector.table(v)][]



***********************


## Reference

### gsl
#### gsl.Matrix(fun, nrows, ncols)
Returns a new matrix with *nrows* rows and *ncols* columns, where the elements are set such that m\[i\]\[j\] = fun(i, j).	

#### gsl.Matrix(mat)
Returns a matrix that is a copy of *mat*.	

#### gsl.Matrix(nrows, ncols)
Returns a new matrix with *nrows* rows and *ncols* columns; all elements are set to 0.	

#### gsl.Vector(fun, len)
Returns a new vector object such that v[i] = *fun*(i) for i = 1..*len*. See [gsl.vector][] for more information about vectors.

###### Example:
	quad = function(i) return i^2 end
	print(gsl.Vector(quad, 3))  -- |1, 4, 9|	

#### gsl.Vector(len)
Returns a new vector object of length *len* (elements are zeroed out). See [gsl.vector][] for more information about vectors.

###### Example:
	v = gsl.Vector(4)
	print(v)	-- | 0, 0, 0, 0 |	

#### gsl.Vector(tbl)
Returns a new vector with the same elements as *tbl*. This is a convenient constructor to turn a Lua array into a GSL vector. See [gsl.vector][] for more information about vectors.

###### Example:
	v = gsl.Vector{3, 4, 5}
	print(v)		-- | 3, 4, 12 |
	print(v:norm()) -- 13
	print(v:sum()) 	-- 19	

#### gsl.Vector(vec)
Returns a new vector object that is an independent copy of *vec*. See [gsl.vector][] for more information about vectors.	

#### gsl.fast
When true, disables some of the argument checking for the functions in the gsl.* module.	

#### gsl.import()
Imports all of the gsl functions into the global environment.	

#### gsl.isnan(a)
Returns true if *a* is NaN.	

#### gsl.kron(i, j)
Returns the Kroneker delta (1 if i == j, 0 otherwise). 

###### Example:
	-- Returns 1, 0, 0
	print(gsl.kron(3, 3), gsl.kron(1, 2), gsl.kron(2, 1))
	-- creates a 5x5 identity matrix
	gsl.Matrix(gsl.kron, 5, 5)	

#### gsl.lu(A)
Operates a LU decomposition of *A*, and returns the permutation and sign (uses gsl\_linalg\_LU\_decomp).	

#### gsl.ludet(A, signum)
Given the LU decomposition *A* and sign *signum* (through [gsl.lu][]), returns the determinant of *A*.	

#### gsl.luinvert(A, p)
Given the LU decomposition *A* and permutation *p* (through [gsl.lu][]) returns the inverse of *A*.	

#### gsl.lulndet(A, signum)
Given the LU decomposition *A* and sign *signum* (through [gsl.lu][]), returns the log of the determinant of *A*.	

#### gsl.lusolve(A, p, b)
Given the LU decomposition *A* and permutation *p* (through [gsl.lu][]) and a vector *b*, solves *Ax=b* and returns the vector *x*.	

#### gsl.mmul(A, B)
Stores the result of the matrix multiplication *AB* in *A*.	

#### gsl.number_format
Specifies the number format to use when tostring() is called on an object (e.g. a gsl.vector). The format "%20.3e" is the default.	

#### gsl.prec
Controls the precision at which some operations are executed, such as the accuracy of special functions. Possible values are [gsl.consts.DOUBLE][], [gsl.consts.SINGLE][], or [gsl.consts.APPROX][].	

#### gsl.seterrorfnc(f)
Sets a new error handler function *f*, to be used by the GSL library to signal errors in the input parameters, difficulties in the execution of a numerical algorithm. The default error handler calls *error*. The function receives the following parameters:

* *reason*: error message from the GSL library
* *file*: name of the file where the error occured (GSL source file)
* *line*: number of the source line
* *errno*: the GSL error code

###### Example:
	f = function(reason, file, line, errno)
		print("GSL panicked: ", reason, "in file:", file)
	end
	gsl.seterrorfnc(f)	

#### gsl.transpose(matrix)
Transposes the matrix in-place.	


***********************

### gsl.consts
Contains constants to be used with the GSL library.	

#### gsl.consts.PREC_APPROX
Low-accuracy mode for [gsl.prec][].	

#### gsl.consts.PREC_DOUBLE
Double-precision mode for [gsl.prec][].	

#### gsl.consts.PREC_SINGLE
Single-precision mode for [gsl.prec][].	


***********************

### gsl.matrix
Defines functions that operate on matrix objects (created with [gsl.Matrix][]). These functions can also be called using the matrix:function(...) style. For instance, gsl.matrix.nrows(m) and m:nrows() are equivalent. Most functions in this module return a new matrix containing the result of the operations (i.e. they do not operate in place); analogous functions that operate in-place are available in the [gsl][] module.

A matrix m can be indexed in several ways:

* **m[i]** returns a *view* into the i-th row of the matrix. Changes made to the view are reflected immediately on the matrix. **m\[i\]\[j\]** will access the element (i, j) of the matrix. Row and column views can also be created with the [gsl.matrix.col][] and [gsl.matrix.row][] functions, and can be converted to independent vectors using the [gsl.Vector][] function.
* **m(i, j)** returns the element (i, j) element of the matrix. Access is faster than with the \[\]\[\] syntax since no intermediary views are created. **m(i, j, v)** sets the element (i, j) to *v*.


###### Example:
	m = gsl.Matrix{{1, 2, 3}, {4, 5, 6}, {7, 8, 9}}
	print(m[1])		-- 1, 2 ,3
	print(m:col(2)) -- 2, 5, 8
	print(m(2, 1))	-- 4
	
	n = gsl.Matrix(gsl.kron, 3, 3) -- the 3x3 identity matrix
	print(m + n)	-- element-by-element addition
	print(n:det())	-- 1

Matrices can also be sliced and indexed using a syntax similar to that of vectors.

* **m(cond)** will return a submatrix defined by the range in row and column where *cond* is true. Elements that fall in the submatrix but do not satisfy the condition are set to NaN. *cond* can be either a function or a string (see [gsl.vector][]). The function *cond* will be called with arguments *m, i, j* (the entire matrix, the current row and the current column). In strings, *@(i, j)* represents the current element being worked on. "*" matches all elements.

* **m[cond]** will return all the rows that satisfy the condition *cond* (which can be a function or a string). 

* **m(cond, val)** (where *cond* is a function or a string and *val* is a function, a string or a number) will set the elements for which *cond* is true to the new value *val*. *val* can be a number (in which case all elements will be set to that number), or a function, in which case the elements will be set to the return value of the function (see also [gsl.vector][] and [gsl.vector.map][]). This operation is done in place; for an analogous operation that returns a new matrix, see [gsl.matrix.map][].

###### Example:
	m = gsl.Matrix{{1, 2, 3}, {4, 5, 6}, {7, 8, 9}}
	m('i == 1 and j > 1')	-- {{2, 3}}
	m('i == 1 or i == 3')	-- {{1, 2, 3}, {nan, nan, nan}, {7, 8, 9}}
							-- elements marked as nan do not satisfy the condition
	m['i == 1 or i == 3']	-- {{1, 2, 3}, {7, 8, 9}}
							-- only returns rows where the condition is satisfied
	m('*', '@(i, j)^2')		-- squares all elements
	m('j == 2', math.pi)	-- sets all elements of the second column to pi	

#### gsl.matrix.add(a, b) / sub(a, b) / mul(a, b) / div(a, b)
Executes the operation in-place between matrices *a* and *b*, element-by-element; *a* will contain the result of the operation. *b* can be a scalar, which will operate element-by-element. The same operations are available using Lua's arithmetic operators (+, -, *, /).

###### Example:
	a = gsl.Matrix{{1, 2}, {3, 4}}
	b = gsl.Matrix{{-1, 1}, {1, -1}}
	
	a:add(b)	-- a = ||0, 3|, |4, 3||
	a:mul(5)	-- a = ||0, 15|, |20, 15||	

#### gsl.matrix.det(M, [algo])
Calculates the determinant of the matrix *M* using algorithm *algo* (currently, only "lu"). 

###### Example:
	A = gsl.Matrix{{3, 4}, {1, 2}}
	print(A:det("lu"))	-- 2	

#### gsl.matrix.invert(M, [algo])
Invers the matrix *M* using algorithm *algo* (currently, only "lu"). 

###### Example:
	A = gsl.Matrix{{3, 4}, {1, 2}}
	B = A:invert()		-- ||1, -2|, |-0.5, 1.5||
	print(A:mmul(B))	-- identity matrix	

#### gsl.matrix.map(m, cond, [val])
Changes the matrix *m* according to *val* for elements where *cond* is true.

If *val* is not specified, *map* returns a submatrix for which *cond* is true. Elements that fall in the submatrix but do not satisfy *cond* are set to NaN. *cond* can be a function or a string (similarly to [gsl.vector.map][]). *cond* is passed arguments (m, i, j) (the matrix, current row and current column, respectively). In strings, "@" represents the matrix and "*" will match all elements.

If *val* is specified, then *map* returns a new matrix where the elements are according to *val*. If *val* is a number, then those elements are set to *val*; if *val* is a function or string, *map* will loop over all indices that match *cond* and set the corresponding elements to the return value of *val*.

###### Example:
	m = gsl.Matrix{{1, 2, 3}, {3, 4, 5}}
	
	b = m:map('*', '2 * @(i, j)')	 -- doubles all elements
	b = m:map('i == 2', '@(i, j)^2') -- squares all elements on the second row	

#### gsl.matrix.mmul(A, B)
Returns the matrix C = *A**B* (matrix product).	

#### gsl.matrix.ncols(m)
Returns the number of columns in the matrix *m*.	

#### gsl.matrix.nrows(m)
Returns the number of rows in the matrix *m*.	

#### gsl.matrix.solve(A, b, [algo])
Solves the system *A*x = *b* with algorithm *algo* (one of
"lu" or "svd").

###### Example:
	A = gsl.Matrix{{1, 1}, {1, -2}}
	b = gsl.Vector{3, -3}
	print(A:solve(b))	-- 1.00, 2.00	

#### gsl.matrix.table(M)
Returns a new Lua table where each element corresponds to a row of the matrix.

###### Example:
	tbl = gsl.Matrix(gsl.kron, 3, 3)	-- tbl = {{1, 0, 0}, {0, 1, 0}, {0, 0, 1}}	

#### gsl.matrix.transpose(M)
Returns the transpose matrix of M. 

###### Example:
	M = gsl.Matrix{{1, 2}, {3, 4}}
	print(M:transpose()) -- ||1, 3|, |2, 4||	


***********************

### gsl.vector
Defines functions that operate on vector objects (created with [gsl.Vector][]). These functions can also be called using the vector:function(...) style. For instance, gsl.vector.length(v) and v:length() are equivalent.

Vectors can be indexed with the [] notation, like standard Lua arrays. Their length is given by the length() method.

###### Example:

    a = gsl.Vector{1, 2, 3}
    b = gsl.Vector{4, 1, 2}
    print(gsl.vector.dot(a, b) == a:dot(b)) -- true

As additional "sugar" for vectors, they can also be sliced and with the [] notation (a *vectorized* notation). The user can pass a function which evaluates to true or false. The function is called for each element and is passed the vector and the current element index; elements for which the function evaluates to true are returned in the new array. This corre

###### Example:
	f = function(v, i) return v[i] < 0 end
	a = gsl.Vector{1, 2, -1, 3, 4, -2}
	b = a[f]
	print(b)	-- | -1, -2 |
	
For convenience, functions can be also expressed concisely using strings; in this case, special parameters *@* and *i* represent the vector and current vector index, respectively. Strings are compiled into functions on the fly and memoized for fast reuse. 

###### Example:
	a = gsl.Vector{0.1, 0.5, 0.8, 1, 2, 3, 4}
	b = a['@[i] > 1']			-- returns all elements bigger than 1
								-- | 2, 3, 4 |
	c = a['i >= 2 and i < 4']	-- returns all elements with index >= 2 and  < 4
								-- | 0.8, 1 |
				
The examples above would have required much more code if written out using loops.

It is also possible to assign values to subsets of the vector using the same vectorial notation:
###### Example:
	a = gsl.Vector{-2, -1, -0.5, 1, 2, 3}
	a['@[i] < 0'] = 0		-- | 0, 0, 0, 1, 2, 3 |
	a['i <= 2'] = 9		-- | 9, 9, 0, 1, 2, 3 |

Finally, functions and strings can also be used on the right hand side of assignments, such that *a[f(v, i)] = g(v, i)* where *f(v, i)* evaluates to true. For instance:
###### Example:
	-- squares all even numbers
	a = gsl.Vector{1, 2, 3, 4, 5, 6, 7, 8}
	a['@ % 2 == 0'] = '@^2'		-- |1, 4, 3, 16, 5, 36, 7, 64|
	
which corresponds to
	for i = 1, a:length() do
		if a[i] % 2 == 0 then
			a[i] = a[i]^2
		end
	end
	
Another example: 
###### Example:
	-- returns a difference vector, such that a'[i] = a[i]-a[i-1] for i >= 2.
	a = gsl.Vector{1, 2, 3, 5, 8, 13}
	a['i > 1'] = '@[i]-@[i-1]'	-- | 1, 1, 2, 3, 5, 8 |
	
The function [gsl.vector.map][] can also be used to achieve similar functionality.	

#### gsl.vector.add(a, b) / sub(a, b) / mul(a, b) / div(a, b)
Executes the operation in-place between vectors *a* and *b*, element-by-element; *a* will contain the result of the operation. *b* can be a scalar, which will operate element-by-element.

###### Example:
	a = gsl.Vector{1, 2, 3}
	b = gsl.Vector{3, 4, 5}
	
	-- Using operators, not destructive
	print(a + b) -- |4, 6, 8|
	print(a) -- |1, 2, 3|
	
	-- Adding in-place
	print(a:add(b)) -- |4, 6, 8|
	print(a) -- |4, 6, 8|	

#### gsl.vector.asum(v)
Returns sum(|v_i|).	

#### gsl.vector.copy(v)
Returns a copy of the vector *v* (this may be useful to run destructive functions on a vector you wish to keep).	

#### gsl.vector.dot(a, b)
Returns the dot product between *a* and *b*.	

#### gsl.vector.iter(vector, [cond])
Returns a new iterator over the elements of the vectors. It is similar in operation to ipairs. If *cond* is specified (either as a function or a string), the iterator will only pass over the elements for which *cond* is true (see [gsl.vector.map][] and [gsl.vector][] for more details).

###### Example:
	a = gsl.Vector{3, 4, 5, 6, 7, 8}
	
	for i, v in a:iter() do
		print(i, v)			-- will print all indexes and values 
	end

	for i, v in a:iter('@[i] % 2 == 0') do
		print(i, v)			-- will print indexes and values where values are even
	end	

#### gsl.vector.length(v)
Returns the length of vector *v*.	

#### gsl.vector.map(v, cond, [repl])
Returns a new vector that contains all elements of *v* that passed condition *cond*. The condition *cond* is expressed through a function f(v, i) that evaluates to true for a subset of the elements. If *repl* is specified, then the returned elements will be the result of the function *repl(v, i)*. *cond* and *repl* can also be expressed using strings, where the *@* and *i* symbols represent the vector and the current index, respectively. The special string "\*" can be used to represent all elements (cond always true). *repl* can also be a number, in which case the elements are set to the number.

This is analogous to using the [] indexing with a function (see also [gsl.vector][]); the returned vector is independent of the original vector.

###### Example:
	a = gsl.Vector{3, 4, 5, 6, 7}
	b = a:map(function(v, i) return i > 3 end)	-- | 6, 7 |
	c = a:map('@[i] > 3')						-- | 6, 7 |; equivalent 
	d = a:map('*', '@[i]^2')					-- | 9, 16, 25, 36, 49 |	

#### gsl.vector.min(v) / max(v) / minmax(v)
Returns the minimum/maximum value in vector *v*.	

#### gsl.vector.min\_index(v) / max\_index(v) / minmax\_index(v)
Returns the index of the minimum/maximum value in vector *v*.	

#### gsl.vector.norm(v)
Returns the euclidean norm of *v*.	

#### gsl.vector.set_all(v, n)
Sets all elements of *v* to the number *n*	

#### gsl.vector.set_zero(v)
Sets all elements of *v* to zero.	

#### gsl.vector.sum(v)
Returns the sum of the elements of v.	

#### gsl.vector.table(v)
Converts the vector *v* into a standard Lua table.	


***********************
