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

## Contact
If you have questions, bug reports, suggestions, etc. contact me at smeschia@ucolick.org. 

## Documentation
Full documentation is available at [gsl-lua's website](http://www.stefanom.org/?gsl-lua).