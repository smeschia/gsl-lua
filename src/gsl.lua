


require 'alien'
local gsl = {}

local ext = ".so"
if alien.platform == "darwin" then ext = ".dylib" end
	
local GSL_cblas_lib = alien.load("libgslcblas"..ext)
local GSL_lib = alien.load("libgsl"..ext)
gsl.support = alien.load("gslsupport" .. ext)

local GSL = {}
setmetatable(GSL, {__index = GSL_lib})

local mt_gsl
mt_gsl = {
	__register = function(name, types)
		local lib = GSL_lib
		return pcall(function() lib[name]:types(types); GSL[name] = lib[name] end)
	end
}
mt_gsl.__index = mt_gsl
setmetatable(gsl, mt_gsl)

require 'GSLdefs2'

local function buffer()
	local buf = {}
	function buf:append(...)
		local arg = {...}
		for i = 1, #arg do
			buf[#buf+1] = arg[i]
		end
		return buf
	end
	function buf:appendf(fmt, ...)
		buf[#buf+1] = string.format(fmt, ...)
		return buf
	end
	function buf:tostring() 
		return table.concat(buf)
	end
	function buf:clear()
		for i = 1, #buf do buf[i] = nil end
	end
	return buf
end

local ASSERT = function(cond, str)
	if gsl.fast then return 
	elseif not cond then error(str) end
end

local ASSERTLIM = function(idx, min, max)
	if gsl.fast then return 
	elseif idx < min or idx > max then error(string.format("Index %d outside range (%d, %d)", idx, min, max)) end
end

local function ttype(v)
	if getmetatable(v) then
		if getmetatable(v).__type then return getmetatable(v).__type end
	else
		return type(v)
	end
end

local function is_functor(f)
	if type(f) == "function" then return true end
	if type(f) == "table" and getmetatable(f) and ttype(f) ~= "matrix" then
		return getmetatable(f).__call ~= nil
	else
		return false
	end
end

local function is_int(n)
	if type(n) ~= "number" then 
		return false
	else
		return n % 1 == 0
	end
end

local function is_number(n)
	return type(n) == "number"
end


local function switch(v, ...)
	local args = {n = select('#', ...), ...}
	
	for i = 1, args.n, 2 do
		if v == args[i] then
			return args[i+1]
		end
	end
	return nil
end


local function swapargs(a, b)
	if ttype(a) == "number" and ttype(b) ~= "number" then
		return b, a
	end
	return a, b
end

local function checkargs(...)
	if gsl.fast then return end
	local args = {n = select('#', ...), ...}
	
	for i = 1, args.n, 2 do
		local v = args[i]
		local typ = args[i+1]
		local nullable = false
		if typ:find("%*") then nullable = true; typ = typ:gsub("%*", "") end

		if v ~= nil or (not nullable and v == nil) then
			 if not (ttype(v) == typ or (typ == "int" and is_int(v))) then
				error(string.format("Input #%d should be a %s (got a %s instead); from %s",
				(i+1)/2, typ, ttype(v), debug.traceback()))
			end
		end
	end
end

-- MARSHALING AND ENCAPSULATION OF DATA

local function wrap(userdata, mt, tbl)
	tbl = tbl or {}
		
	tbl.handle = userdata
	if mt.__type then
		tbl.whandle = alien.wrap("gsl_" .. mt.__type, tbl.handle)
	end	

	setmetatable(tbl, mt)
	return tbl
end

local function wrapf_1(f)
	return function(a)
		return f(a.handle)
	end
end

local function wrapf_1_2(f, v1, isvoid)
	return function(a)
		if isvoid then
			return select(2, f(a.handle, v1))
		else
			return f(a.handle, v1)
		end
	end
end

local function wrapf_1_3(f, v1, v2, isvoid)
	return function(a)
		if isvoid then
			return select(2, f(a.handle, v1, v2))
		else
			return f(a.handle, v1, v2)
		end
	end
end



local gsl_function_struct = alien.defstruct{{"function", "callback"}, {"params", "pointer"}}
local gsl_vector_struct = alien.defstruct{{"size", "uint"}, {"stride", "uint"},
	{"data", "pointer"}, {"block", "pointer"}, {"owner", "int"}}
local gsl_permutation_struct = alien.defstruct{{"size", "uint"}, {"data", "pointer"}}
local gsl_interp_type_struct = alien.defstruct{{"name", "pointer"}, {"min_size", "int"},
	{"alloc", "pointer"}, {"init", "pointer"}, {"eval", "pointer"}, {"eval_deriv", "pointer"},
	{"eval_deriv2", "pointer"}, {"eval_integ", "pointer"}, {"eval_free", "pointer"}}

gsl.tofunc = function(f)
	 ASSERT(type(f) == "function", "Input should be a function")
	local cb_f = gsl_function_struct:new()
	cb_f["function"] = alien.callback(f, "double", "double", "pointer")
	cb_f["params"] = nil
	return cb_f
end



function gsl.import()
	for k, v in gsl do
		if type(v) == "function" then
			_G[k] = gsl[k]
		end
	end
end








local function default_handler(reason, file, line, errno)
	error(string.format("%s [%d]: %s (%d)", file, line, reason, errno or 0))
end
function gsl.seterrorfnc(f)
	local cb_f = alien.callback(f, {ret = "void", "string", "string", "int", "int"})
	GSL.gsl_set_error_handler(cb_f)
end
gsl.seterrorfnc(default_handler)



function gsl.kron(i, j)
	return i == j and 1 or 0
end


function gsl.isnan(a)
	return a ~= a
end

-- PERMUTATIONS
local tag_permutation = alien.tag("gsl_permutation")
tag_permutation.__gc = function(obj)
		local o = alien.unwrap("gsl_permutation", obj)
		GSL.gsl_permutation_free(o)
	end
local mt_permutation
mt_permutation = {
	__type = "permutation",
	__index = function(v, n)
		if type(n) == "number" then
			return GSL.gsl_permutation_get(v.handle, n-1)
		else
			return getmetatable(v)[n]
		end
	end,
	size = function(v) 
		return v.__size
	end,
	__tostring = function(v)
		local buf = buffer()
		for k = 1, v:size() do
			buf:appendf(gsl.number_format, v[k])
		end
		buf:append("\n")
		return buf:tostring()
	end
}

function gsl.permutation(len)
	 ASSERT(type(len) == "number" and len >= 1)
	local p = wrap(GSL.gsl_permutation_calloc(len),
		mt_permutation, {__size = len})
	return p
end

-- VECTORS
local tag_vector = alien.tag("gsl_vector")
tag_vector.__gc = function(obj)
		local o = alien.unwrap("gsl_vector", obj)
		GSL.gsl_vector_free(o)
	end



gsl.vector = {
	__type = "vector", 
	__index = function(v, n)
		if type(n) == "number" then
			return GSL.gsl_vector_get(v.handle, n-1)
		elseif getmetatable(v)[n] then
			return getmetatable(v)[n]
		else
			return v:map(n)
		end
	end,
	__newindex = function(v, n, e)
		if type(n) == "number" then
			ASSERT(is_int(n), "Index should be integer")
			GSL.gsl_vector_set(v.handle, n-1, e)
		else
			local f = gsl.util.compile(n)
			
			if type(e) == "number" then
				for i = 1, v:length() do				
					if f(v, i) then
						GSL.gsl_vector_set(v.handle, i-1, e)
					end
				end
			else
				e = gsl.util.compile(e)
				for i = 1, v:length() do
					if f(v, i) then
						GSL.gsl_vector_set(v.handle, i-1, e(v, i))
					end
				end
			end
		end
	end,
	__op = function(a, b, gslopv, gslops, inv)
		a, b = swapargs(a, b)
		if ttype(a) == "vector" and ttype(b) == "vector" then
			local v = gsl.Vector(a)
			gslopv(v.handle, b.handle)
			return v
		elseif ttype(a) == "vector" and ttype(b) == "number" then
			local v = gsl.Vector(a)
			if inv == 1 then b = -b end
			if inv == 2 then b = 1./b end
			
			gslops(v.handle, b)
			return v
		end
	end,
	__op_in_place = function(a, b, gslopv, gslops, inv)
		if ttype(b) == "vector" then
			gslopv(a.handle, b.handle)
			return a
		elseif ttype(b) == "number" then
			if inv == 1 then b = -b end
			if inv == 2 then b = 1./b end
			
			gslops(a.handle, b)
			return a
		end
	end,
	__tostring = function(v)
		local buf = buffer()
		for k = 1, v:length() do
			buf:appendf(gsl.number_format, v[k])
		end
		buf:append("\n")
		return buf:tostring()
	end,
	__data = function(v)
		local arr = alien.array("double", v:length())
		for i = 1, v:length() do
			arr[i] = v[i]
		end
		return arr
	end,
	length = function(self)
		return self.__length
	end,
	copy = function(self)
		return gsl.Vector(self)
	end,
	last = function(self)
		return self[self:length()]
	end,
	set_all = wrapf_1(GSL.gsl_vector_set_all),
	set_zero = wrapf_1(GSL.gsl_vector_set_zero),
	max = wrapf_1(GSL.gsl_vector_max),
	min = wrapf_1(GSL.gsl_vector_min),
	minmax = wrapf_1_3(GSL.gsl_vector_minmax, 0, 0, true),
	min_index = wrapf_1(GSL.gsl_vector_min_index),	
	max_index = wrapf_1(GSL.gsl_vector_max_index),	
	minmax_index = wrapf_1_3(GSL.gsl_vector_minmax_index, 0, 0, true)
}

gsl.vector.__add = function(a, b) return gsl.vector.__op(a, b, GSL.gsl_vector_add,
	GSL.gsl_vector_add_constant) end
gsl.vector.__sub = function(a, b) return gsl.vector.__op(a, b, GSL.gsl_vector_sub,
	GSL.gsl_vector_add_constant, 1) end
gsl.vector.__mul = function(a, b) return gsl.vector.__op(a, b, GSL.gsl_vector_mul,
	GSL.gsl_vector_scale) end
gsl.vector.__div = function(a, b) return gsl.vector.__op(a, b, GSL.gsl_vector_div,
	GSL.gsl_vector_scale, 2) end
gsl.vector.__unm = function(a, b) return gsl.vector.__op(a, -1, nil,
	GSL.gsl_vector_scale, 2) end
	


gsl.vector.add = function(a, b) return gsl.vector.__op_in_place(a, b, GSL.gsl_vector_add,
	GSL.gsl_vector_add_constant) end
gsl.vector.sub = function(a, b) return gsl.vector.__op_in_place(a, b, GSL.gsl_vector_sub,
	GSL.gsl_vector_add_constant, 1) end
gsl.vector.mul = function(a, b) return gsl.vector.__op_in_place(a, b, GSL.gsl_vector_mul,
	GSL.gsl_vector_scale) end
gsl.vector.div = function(a, b) return gsl.vector.__op_in_place(a, b, GSL.gsl_vector_div,
	GSL.gsl_vector_scale, 2) end
	
	

gsl.vector.dot = function(a, b)
	checkargs(a, "vector", b, "vector")
	local ret = 0
	for i = 1, a:length() do
		ret = ret + a[i]*b[i]
	end
	return ret
end
gsl.vector.norm = function(v) 
	checkargs(v, "vector")
	return GSL.gsl_blas_dnrm2(v.handle)
end
gsl.vector.asum = function(v)
	checkargs(v, "vector")
	return GSL.gsl_blas_dasum(v.handle)
end
gsl.vector.sum = function(v)
	local ret = 0
	for i = 1, v:length() do
		ret = ret + v[i]
	end
	return ret
end
gsl.vector.table = function(v)
	local tbl = {}
	for i = 1, v:length() do
		tbl[i] = v[i]
	end
	return tbl
end




gsl.vector.map = function(v, cond, repl)
	if not repl then
		local cond = gsl.util.compile(cond)
		local t = {}
		for i = 1, v:length() do
			local vv = GSL.gsl_vector_get(v.handle, i-1)
			if cond(v, i) then
				t[#t+1] = vv
			end
		end
		return gsl.Vector(t)
	elseif type(repl) == "number" then
		local t = {}
		cond = gsl.util.compile(cond)

		for i = 1, v:length() do
			if cond(v, i) then
				t[#t+1] = repl
			end
		end
		return gsl.Vector(t)		
	else
		local t = {}
		cond = gsl.util.compile(cond)
		repl = gsl.util.compile(repl)

		for i = 1, v:length() do
			if cond(v, i) then
				t[#t+1] = repl(v, i)
			end
		end
		
		return gsl.Vector(t)
	end
end

gsl.vector.iter = function(v, f)
	if not f then
		local i = 0
		return function()
			i = i + 1
			if i > v:length() then return nil else return i, v[i] end
		end
	else
		f = gsl.util.compile(f)
		local i = 0
		return function()
			i = i + 1
			if i > v:length() then return nil end
			
			while not f(v, i) do
				i = i + 1
				if i > v:length() then return nil end
			end
			return i, v[i]
		end
	end	
end



function gsl.Vector(numel, len)
	if is_int(numel) then
		ASSERT(numel >= 1, "Vector must be at least 1 element")		
		local v = wrap(GSL.gsl_vector_calloc(numel),
			gsl.vector, {__length = numel})
		return v
	elseif ttype(numel) == "vector" then
		local v = wrap(GSL.gsl_vector_calloc(numel.__length),
			gsl.vector, {__length = numel.__length})
		GSL.gsl_vector_memcpy(v.handle, numel.handle)
		return v
	elseif is_functor(numel) then
		ASSERT(is_int(len), "Length should be an integer")
		local v = gsl.Vector(len)
		local f = numel
		
		for i = 1, len do
			v[i] = f(i)
		end
		return v
	elseif type(numel) == "table" then
		local n = numel.length and numel:length() or #numel
		
     	ASSERT(n >= 1, "Table must be at least 1 element")
		local v = gsl.Vector(n)
		for i = 1, n do
			 ASSERT(type(numel[i]) == "number", "Element " .. i .. " is nil")
			v[i] = numel[i]
		end
		return v
	else
		error(string.format("Using wrong parameter types for gsl.Vector"))
	end
end


-- MATRICES
local tag_matrix = alien.tag("gsl_matrix")
tag_matrix.__gc = function(obj)
		local o = alien.unwrap("gsl_matrix", obj)
		GSL.gsl_matrix_free(o)
	end



gsl.matrix = {
	__type = "matrix", 
	row = function(m, row)
		local v = {ncols = function(self) return m.__ncols end}
		v.length = v.ncols
		setmetatable(v, {
			__index = function(v, col)
				ASSERT(is_int(col), "Index should be integer")			
				ASSERTLIM(col, 1, m.__ncols)																			
				return GSL.gsl_matrix_get(m.handle, row-1, col-1)
			end,
			__newindex = function(v, col, val)
				ASSERT(is_int(col), "Index should be integer")
				ASSERT(is_number(val), "Value should be real")
				ASSERTLIM(col, 1, m.__ncols)															
				GSL.gsl_matrix_set(m.handle, row-1, col-1, val)
			end,
			__tostring = gsl.vector.__tostring		
		})
		
		return v
	end,
	col = function(m, col)
		local v = {nrows = function(self) return m.__nrows end}
		v.length = v.nrows
		setmetatable(v, {
			__index = function(v, row)
				ASSERT(is_int(row), "Index should be integer")
				ASSERT(row, 1, m.__nrows)
				return GSL.gsl_matrix_get(m.handle, row-1, col-1)
			end,
			__newindex = function(v, row, val)
				ASSERT(is_int(row), "Index should be integer")			
				ASSERT(is_number(val), "Value should be number")
				ASSERTLIM(row, 1, m.__nrows)											
				GSL.gsl_matrix_set(m.handle, row-1, col-1, val)
			end,
			__tostring = gsl.vector.__tostring
		})
		return v
	end,
	__index = function(m, n)
		if type(n) == "number" then
			return getmetatable(m).row(m, n)
		elseif getmetatable(m)[n] == nil then
			local f = gsl.util.compile(n)
			local ret = {}
			
			for i = 1, m:nrows() do
				if f(m, i, -1) then
					ret[#ret+1] = i
				end
			end
			local nr = #ret
			
			local mm = gsl.Matrix(nr, m:ncols())
			for i = 1, #ret do
				for j = 1, m:ncols() do
					mm(i, j, m(ret[i], j))
				end
			end
			return mm
		else
			return getmetatable(m)[n]
		end
	end,
	__newindex = function(m, n, v)
		checkargs(v, "vector")
		 ASSERT(v:length() == m:nrows(), "Vector length == # matrix rows")
		GSL.gsl_matrix_set_row(m.handle, n-1, v.handle)
	end,
	__call = function(m, i, j, v)
		if is_int(i) then
			checkargs(i, "int", j, "int")
			ASSERTLIM(i, 1, m.__nrows)
			ASSERTLIM(j, 1, m.__ncols)		
			if v == nil then
				return GSL.gsl_matrix_get(m.handle, i-1, j-1)
			else
				GSL.gsl_matrix_set(m.handle, i-1, j-1, v)
			end
		else
			return gsl.matrix.map(m, i, j, m)
		end
	end,
	__op = function(a, b, gslopv, gslops, inv)
		a, b = swapargs(a, b)
		if ttype(a) == "matrix" and ttype(b) == "matrix" then
			ASSERT(a.__nrows == b.__nrows and a.__ncols == b.__ncols, "Matrices must be the same size")
			local v = gsl.Matrix(a)
			gslopv(v.handle, b.handle)
			return v
		elseif ttype(a) == "matrix" and ttype(b) == "number" then
			local v = gsl.Matrix(a)
			if inv == 1 then b = -b end
			if inv == 2 then b = 1./b end
			
			gslops(v.handle, b)
			return v
		end
	end,
	__op_in_place = function(a, b, gslopv, gslops, inv)	
		if ttype(b) == "matrix" then
			ASSERT(a.__nrows == b.__nrows and a.__ncols == b.__ncols, "Matrices must be the same size")			
			gslopv(a.handle, b.handle)
			return a
		elseif ttype(b) == "number" then
			if inv == 1 then b = -b end
			if inv == 2 then b = 1./b end
			
			gslops(a.handle, b)
			return a
		end
	end,
	nrows = function(self)
		return self.__nrows
	end,
	ncols = function(self)
		return self.__ncols
	end,
	__tostring = function(v)
		local buf = buffer()

		for i = 1, v:nrows() do
			for j = 1, v:ncols() do
				buf:appendf(gsl.number_format, v(i, j))
			end
			buf:append("\n")
		end
		return buf:tostring()
	end
}



gsl.matrix.__add = function(a, b) return gsl.matrix.__op(a, b, GSL.gsl_matrix_add,
	GSL.gsl_matrix_add_constant) end
gsl.matrix.__mul = function(a, b) return gsl.matrix.__op(a, b, GSL.gsl_matrix_mul_elements,
	GSL.gsl_matrix_scale) end
gsl.matrix.__div = function(a, b) return gsl.matrix.__op(a, b, GSL.gsl_matrix_div_elements,
	GSL.gsl_matrix_scale, 2) end
gsl.matrix.__sub = function(a, b) return gsl.matrix.__op(a, b, GSL.gsl_matrix_sub,
	GSL.gsl_matrix_add_constant, 1) end
gsl.matrix.__unm = function(a, b) return gsl.matrix.__op(a, -1, nil,
	GSL.gsl_matrix_scale) end

gsl.matrix.add = function(a, b) return gsl.matrix.__op_in_place(a, b, GSL.gsl_matrix_add,
	GSL.gsl_matrix_add_constant) end
gsl.matrix.sub = function(a, b) return gsl.matrix.__op_in_place(a, b, GSL.gsl_matrix_sub,
	GSL.gsl_matrix_add_constant, 1) end
gsl.matrix.mul = function(a, b) return gsl.matrix.__op_in_place(a, b, GSL.gsl_matrix_mul_elements,
	GSL.gsl_matrix_scale) end
gsl.matrix.div = function(a, b) return gsl.matrix.__op_in_place(a, b, GSL.gsl_matrix_div_elements,
	GSL.gsl_matrix_scale, 2) end



gsl.matrix.solve = function(self, b, algo)
	algo = algo or "lu"
	local scratch = gsl.Matrix(self)
	if algo == "lu" then
		local p, signum = gsl.lu(scratch)
		local x = gsl.lusolve(scratch, p, b)
		return x
	elseif algo == "svd" then
		local U, V, S = gsl.svd(scratch)
		local x = gsl.svdsolve(U, V, S, b)
		return x
	else
		error("Unknown algo " .. algo)
	end
end



gsl.matrix.invert = function(self, algo)
	algo = algo or "lu"
	local scratch = gsl.Matrix(self)
	if algo == "lu" then
		p, signum = gsl.lu(scratch)
		local inverse = gsl.luinvert(scratch, p)
		return inverse
	else
		error("Unsupported algorithm ".. algo)
	end
end



gsl.matrix.det = function(self, algo)
	algo = algo or "lu"
	local scratch = gsl.Matrix(self)

	if algo == "lu" then
		p, signum = gsl.lu(scratch)
		return gsl.ludet(scratch, signum)
	end
end



gsl.matrix.transpose = function(self)
	local scratch = gsl.Matrix(self)
	return gsl.transpose(scratch)
end



gsl.matrix.table = function(m)
	local tbl = {}
	for i = 1, m:nrows() do
		tbl[i] = {}
		for j = 1, m:ncols() do
			tbl[i][j] = m(i, j)
		end
	end
	return tbl
end



gsl.matrix.mmul = function(m1, m2)
	local scratch = gsl.Matrix(m1)
	return gsl.mmul(scratch, m2)
end



gsl.matrix.map = function(m, cond, val, to)
	ASSERT(m, "Matrix cannot be nil")
	cond = gsl.util.compile(cond)	
	
	if not val then
		local tbl = {}
		local minr = math.huge
		local maxr = 0
		local minc = math.huge
		local maxc = 0
		
		for i = 1, m:nrows() do
			for j = 1, m:ncols() do
				if cond(m, i, j) then
					minr = math.min(minr, i)
					minc = math.min(minc, j)
					maxr = math.max(maxr, i)
					maxc = math.max(maxc, j)
					tbl[i] = tbl[i] or {}
					tbl[i][j] = m(i, j)
				end
			end 
		end
		
		local nr = maxr - minr + 1
		local nc = maxc - minc + 1	
		local m2 = gsl.Matrix(nr, nc)

		for i = 1, m2:nrows() do
			for j = 1, m2:ncols() do
				m2(i, j, gsl.nan)
			end
		end
		
		for i = minr, maxr do
			for j = minc, maxc do
				if tbl[i] and tbl[i][j] then
					m2(i - minr + 1, j - minc + 1, tbl[i][j])
				end
			end
		end
		
		return m2
	else
		to = to or gsl.Matrix(m)
		
		if is_functor(val) then
			val = gsl.util.compile(val)
			
			for i = 1, m:nrows() do
				for j = 1, m:ncols() do
					if cond(m, i, j) then
						to(i, j, val(m, i, j))
					end
				end 
			end
			
			return to
		else
			for i = 1, m:nrows() do
				for j = 1, m:ncols() do
					if cond(m, i, j) then
						to(i, j, val)
					end
				end 
			end
			
			return to
		end
	end
end



function gsl.Matrix(p1, p2, p3)
	if ttype(p1) == "number" then
		checkargs(p1, "int", p2, "int")
		local nrows, ncols = p1, p2
		local m = wrap(GSL.gsl_matrix_calloc(nrows, ncols),
			gsl.matrix, {__nrows = nrows, __ncols = ncols})
		return m
	elseif ttype(p1) == "matrix" then
		local clone = p1
		local m = wrap(GSL.gsl_matrix_calloc(clone.__nrows, clone.__ncols),
			gsl.matrix, {__nrows = clone.__nrows, __ncols = clone.__ncols})
		GSL.gsl_matrix_memcpy(m.handle, clone.handle)
		return m
	elseif ttype(p1) == "table" then
		local tbl = p1
		local nrows = #tbl
		local ncols = #tbl[1]
		ASSERT(nrows >= 1 and ncols >= 1, "Table must be at least 1x1 element")
		local m = gsl.Matrix(nrows, ncols)
		for i = 1, nrows do
			for j = 1, ncols do
				m(i, j, tbl[i][j])
			end
		end
		return m
	elseif is_functor(p1) then
		local f = p1
		local nrows = p2
		local ncols = p3

		local m = gsl.Matrix(nrows, ncols)
		for i = 1, nrows do
			for j = 1, ncols do
				m(i, j, f(i, j))
			end
		end
		return m
	else
		error(string.format("Using wrong parameter types for gsl.Matrix"))
	end
end

-- BLAS

gsl.blas = {}
-- GSL.gsl_blas_dgemm
function gsl.blas.dgemm(transA, transB, alpha, A, B, beta, C)
	checkargs(transA, "int", transB, "int", alpha, "number", A, "matrix", B,  "matrix", beta, "number*", C, "matrix*")
	beta = beta or 0
	
	local m = A:nrows()
	local n = B:ncols()
	C = C or gsl.Matrix(m, n)
	
	GSL.gsl_blas_dgemm(transA, transB, alpha, A.handle, B.handle, beta, C.handle)
	return C
end

-- Linear algebra


-- GSL.gsl_matrix_transpose
function gsl.transpose(matrix)
	checkargs(matrix, "matrix")
	GSL.gsl_matrix_transpose(matrix.handle)
	return matrix	
end	


function gsl.mmul(A, B)
	checkargs(A, "matrix", B, "matrix")
	return gsl.blas.dgemm(gsl.consts.CblasNoTrans, gsl.consts.CblasNoTrans, 1, A, B)
end


-- GSL.gsl_linalg_LU_decomp
function gsl.lu(matrix)
	checkargs(matrix, "matrix")
	local p = gsl.permutation(matrix:ncols())
	local _, signum = GSL.gsl_linalg_LU_decomp(matrix.handle, p.handle, 1)
	return p, signum
end


-- GSL.gsl_linalg_LU_solve
function gsl.lusolve(lumatrix, permutation, b)
	checkargs(lumatrix, "matrix", permutation, "permutation",
		b, "vector")
	local x = gsl.Vector(lumatrix:nrows())
	GSL.gsl_linalg_LU_solve(lumatrix.handle, permutation.handle, b.handle,
		x.handle)
	return x
end


-- GSL.gsl_linalg_LU_invert
function gsl.luinvert(lumatrix, permutation)
	checkargs(lumatrix, "matrix", permutation, "permutation")
	local inverse = gsl.Matrix(lumatrix)
	GSL.gsl_linalg_LU_invert(lumatrix.handle, permutation.handle, inverse.handle)
	return inverse
end


-- GSL.gsl_LU_det
function gsl.ludet(lumatrix, signum)
	checkargs(lumatrix, "matrix", signum, "int")
	local det = GSL.gsl_linalg_LU_det(lumatrix.handle, signum)
	return det
end


-- GSL.gsl_LU_det
function gsl.lulndet(lumatrix)
	checkargs(lumatrix, "matrix")
	local det = GSL.gsl_linalg_LU_lndet(lumatrix.handle)
	return det
end

-- GSL.gsl_linalg_SV_decomp
function gsl.svd(matrix)
	checkargs(matrix, "matrix")
	local V = gsl.Matrix(matrix:ncols(), matrix:ncols())
	local S = gsl.Vector(matrix:ncols())
	local work = gsl.Vector(matrix:ncols())
	GSL.gsl_linalg_SV_decomp(matrix.handle, V.handle, S.handle,
		work.handle)
	return matrix, V, S
end

-- GSL.gsl_linalg_SV_solve
function gsl.svdsolve(U, V, S, b)
	checkargs(U, "matrix", V, "matrix", S, "vector", b, "matrix")
	local x = gsl.Vector(lumatrix:ncols())
	GSL.gsl_linalg_SV_solve(U.handle, V.handle, S.handle, b.handle, x.handle)
	return x
end

-- GSL.gsl_eigen_symm
function gsl.eigen_symm(matrix)
	checkargs(matrix, "matrix")
	local eval = gsl.Vector(matrix:nrows())
	local work = GSL.gsl_eigen_symm_alloc(matrix:nrows())
	GSL.gsl_eigen_symm(matrix.handle, eval.handle, work)
	GSL.gsl_eigen_symm_free(work)
	return eval
end

-- GSL.gsl_eigen_symmv
function gsl.eigen_symmv(matrix)
	checkargs(matrix, "matrix")
	local eval = gsl.Vector(matrix:nrows())
	local evec = gsl.Matrix(matrix:nrows(), matrix:nrows())
	local work = GSL.gsl_eigen_symmv_alloc(matrix:nrows())
	GSL.gsl_eigen_symmv(matrix.handle, eval.handle, evec.handle, work)
	GSL.gsl_eigen_symmv_free(work)
	return eval, evec
end

-- INTEGRATION
function gsl.integrate(f, a, b, opts)
	checkargs(f, "function", a, "number", b, "number",
		opts, "table*")
	opts = opts or {}
	opts.algo = opts.algo or "qng"
	opts.epsabs = opts.epsabs or 1e-3
	opts.epsrel = opts.epsrel or 1e-3
	
	local cb_f = gsl.tofunc(f)

	if opts.algo == "qng" then
		_, result, abserr, neval = GSL.gsl_integration_qng(cb_f(),
			a, b, opts.epsabs, opts.epsrel, 0, 0, 0)
		return result, abserr, neval
	else
		opts.intervals = opts.intervals or 50
		opts.key = opts.key or 1
		local work = GSL.gsl_integration_workspace_alloc(opts.intervals)			
		local args
		
		if opts.algo == "qag" then 
			args = {cb_f(), a, b, opts.epsabs, opts.epsrel, opts.intervals,
				opts.key, work, 0, 0}
		elseif opts.algo == "qags" then
			args = {cb_f(), a, b, opts.epsabs, opts.epsrel, opts.intervals,
				work, 0, 0}
		elseif opts.algo == "qagp" then
			 ASSERT(ttype(opts.points) == "vector", "qagp requires a point vector")
			args = {cb_f(), opts.points:__data().buffer, opts.points:length(),
				opts.epsabs, opts.epsrel, opts.intervals, work, 0, 0}
		elseif opts.algo == "qagi" then
			 ASSERT(a == -gsl.inf or b == gsl.inf, "One of the limits should be infinite for algorithm qagi")
			if a == - gsl.inf and b ~= gsl.inf then
				opts.algo = "qagil"
				args = {cb_f(), b, opts.epsabs, opts.epsrel, 	
					opts.intervals, work, 0, 0}				
			elseif a ~= - gsl.inf and b == gsl.inf then
				opts.algo = "qagiu"
				args = {cb_f(), a, opts.epsabs, opts.epsrel, 	
					opts.intervals, work, 0, 0}				
			else
				args = {cb_f(), opts.epsabs, opts.epsrel, 	
					opts.intervals, work, 0, 0}
			end
		else
			error("Unsupported algorithm " .. opts.algo)
		end
		
		_, result, abserr = GSL['gsl_integration_' .. opts.algo](unpack(args))
		GSL.gsl_integration_workspace_free(work)
		return result, abserr
	end
end

-- INTERPOLATION
local tag_interpolation = alien.tag("gsl_interpolation")
tag_interpolation.__gc = function(obj)
		local o = alien.unwrap("gsl_interpolation", obj)
		GSL.gsl_interp_free(o)
	end
	
local mt_interpolation = {
	__type = "interpolation",
	__call = function(tbl, x)
		local _, y = GSL.gsl_interp_eval_e(tbl.handle, tbl.__x.buffer,
			tbl.__y.buffer, x, nil, 0)
		return y
	end,
	deriv = function(tbl, x)
		local _, y = GSL.gsl_interp_eval_deriv_e(tbl.handle, tbl.__x.buffer,
			tbl.__y.buffer, x, nil, 0)
		return y
	end,
	deriv2 = function(tbl, x)
		local _, y = GSL.gsl_interp_eval_deriv2_e(tbl.handle, tbl.__x.buffer,
			tbl.__y.buffer, x, nil, 0)
		return y
	end,
	integ = function(tbl, a, b)
		local _, y = GSL.gsl_interp_eval_integ_e(tbl.handle, tbl.__x.buffer,
			tbl.__y.buffer, a, b, nil, 0)
		return y
	end
}


function gsl.interpolate(x, y, method)
	if type(x) == "table" then x = gsl.Vector(x) end
	if type(y) == "table" then y = gsl.Vector(y) end
	 ASSERT(x:length() == y:length(), "Length mismatch")
	
	method = method or "linear"
	
	local itype = switch(method, 
		"linear", 0,
		"polynomial", 1,
		"cspline", 2,
		"cspline_periodic", 3,
		"akima", 4,
		"akima_periodic", 5)

	itype = gsl.support.gsl_get_interp_type(itype)
	local arrx = x:__data()
	local arry = y:__data()
	
	local it = wrap(GSL.gsl_interp_alloc(itype, x:length()),
		mt_interpolation, {__x = arrx, __y = arry})
		
	GSL.gsl_interp_init(it.handle, arrx.buffer, arry.buffer, x:length())
	
	return it
end

-- Least squares fitting
gsl.fit = {
	__type = "fit",
	__call = function(tbl, x, fittype)
		fittype = fittype or tbl.fittype
		if fittype == "linear" then
			checkargs(x, "number")
			local _, y, yerr = GSL.gsl_fit_linear_est(x, tbl.c0, tbl.c1,
				tbl.cov00, tbl.cov01, tbl.cov11, 0.0, 0.0)
			return y, yerr
		elseif fittype == "multi" then
			checkargs(x, "vector")
			local _, y, yerr = GSL.gsl_multifit_linear_est(x.handle, tbl.c.handle,
				tbl.cov.handle, 0, 0)
			return y, yerr
		elseif fittype == "fmulti" then
			checkargs(x, "number")
			local npars = tbl.c:length()
			local xx = gsl.Vector(npars)
			for i = 1, npars do
				xx[i] = tbl.fun(x, i)
			end
			return tbl:est(xx, "multi")
		end
	end,
	
	coeffs = function(tbl)
		return tbl.c
	end,
	
	chisq = function(tbl)
		return tbl.chi
	end,
	
	__index = function(tbl, n)
		if is_int(n) then
			return tbl.c[n]
		else
			return getmetatable(tbl)[n]
		end
	end,
	
	__tostring = function(tbl)
		return buffer():appendf("chisq = %.2e\ncoeffs = %s", tbl:chisq(), 
			tostring(tbl.c)):tostring()
	end
}
gsl.fit.est = gsl.fit.__call

function gsl.lsfit(x, y, w, algo)
	local ret = {}
	setmetatable(ret, gsl.fit)	
	local _	

	if algo == "linear" then
		checkargs(x, "vector", y, "vector", w, "vector*")
		
		if not w then
			_, ret.c0, ret.c1, ret.cov00, ret.cov01, ret.cov11, ret.chi = 	
				GSL.gsl_fit_linear(x:__data().buffer, 1, y:__data().buffer, 1, x:length(),
				0, 0, 0, 0, 0, 0)
		else
			_, ret.c0, ret.c1, ret.cov00, ret.cov01, ret.cov11, ret.chi = 
				GSL.gsl_fit_wlinear(x:__data().buffer, 1, w:__data().buffer, 1, 
				y:__data().buffer, 1, x:length(), 0, 0, 0, 0, 0, 0)
		end
		ret.c = gsl.Vector{ret.c0, ret.c1}
		ret.fittype = algo		
		return ret
	elseif algo == "multi" then
		checkargs(x, "matrix", y, "vector", w, "vector*")
		local nobs = x:nrows()
		local npars = x:ncols()
		
		local c = gsl.Vector(npars)
		local cov = gsl.Matrix(npars, npars)
		local work = GSL.gsl_multifit_linear_alloc(nobs, npars)
		if not w then
			_, ret.chi = GSL.gsl_multifit_linear(x.handle,
				y.handle, c.handle, cov.handle, 0, work)
		else
			_, ret.chi = GSL.gsl_multifit_wlinear(x.handle,
				w.handle, y.handle, c.handle, cov.handle, 0, work)
		end
		ret.c = c; ret.cov = cov;			
		GSL.gsl_multifit_linear_free(work)
		ret.fittype = algo		
		return ret
	elseif algo == "fmulti" then
		checkargs(x, "table", y, "vector", w, "vector*")

		local f = x[2]
		ASSERT(is_functor(f), "Use with {x, f} where f is a function")
				
		local x = x[1]
		local nobs = x:length()
		local npars = f()

		ASSERT(is_int(npars), "Function should return an integer corresponding to the number of parameters")
		
		local X = gsl.Matrix(nobs, npars)
		for i = 1, nobs do
			for j = 1, npars do
				X(i, j, f(x[i], j))
			end
		end
			
		ret = gsl.lsfit(X, y, w, "multi")
		ret.fittype = algo
		ret.fun = f
		return ret
	else
		error("Algorithm should be one of: linear, multi, fmulti")
	end
end

function gsl.fit.poly(n)
	return function(x, i)
		if x then return x^(i-1) else return n end
	end
end

-- Misc functions

gsl.__NIL = {}
gsl.__F = function(arg)
	if arg ~= gsl.__NIL then return arg end
end

local function is_quote(c)
	if c == "\"" or c == "'" then return c else return nil end
end

gsl.util = {}
function gsl.util.wrap(f)
	return function(x, ...)
		if ttype(x) == "vector" then
			local ret = gsl.Vector(x:length())
			for i = 1, x:length() do
				ret[i] = f(x[i], ...)
			end
			return ret
		elseif ttype(x) == "matrix" then
			local ret = gsl.Matrix(x:nrows(), x:ncols())
			for i = 1, x:nrows() do
				for j = 1, x:ncols() do
					ret(i, j, f(x(i, j), ...))
				end
			end
			return ret
		else
			return f(x, ...)
		end
	end
end

function gsl.util.process(str, opts) 
	local quoted = {}
	opts = opts or {}
	opts.func = opts.func or ""
	
	if str:find("[%`%|%?]") then
		local buf = buffer()
		local qbuf = buffer()
		
		local prev = str:sub(1, 1)
		local quote = is_quote(prev)
		buf:append(prev)
		for i = 2, str:len() do
			local cur = str:sub(i, i)
			if is_quote(cur) and quote == cur and prev ~= "\\" then
				quote = nil
				quoted[#quoted+1] = qbuf:tostring()
				buf:appendf("\"\"cap%d\"\"", #quoted)
				buf:append(cur)
				qbuf:clear()
			elseif is_quote(cur) and quote == nil then
				quote = cur
				buf:append(cur)				
			elseif quote then
				qbuf:append(cur)
			else
				buf:append(cur)
			end
			prev = cur
		end
		str = buf:tostring()
		
		local subs = 2
		local terns = 0
		
		-- Light function syntax:
		-- `{ x + 1 - z } => function(x,y,z) return x+1-z end (x, y and z are implicitly defined)
		-- `{(a, b, c) a + b - c } => function(a, b, c) return a + b - c end
		while (subs > 0) do
			str, subs = str:gsub("%`(%b{})", function(cap)
				cap = cap:sub(2, -2):trim()
				if cap:find("%(.-%).-") == 1 then
					local args, body = cap:match("^%((.-)%)(.-)$")
					return string.format("%s(function(%s)\n return %s\n end)", opts.func, args, body)
				else
					return string.format("%s(function(x,y,z)\n return %s\n end)", opts.func, cap)
				end
			end)
		end

		-- Ternary operator: `( cond ? a : b )
		subs = 2
		while subs > 1 do
			str, subs = str:gsub("`(%b())", function(cap) 
				local cond, a, b = cap:match("%(([^%?^:]+)%?([^%?%:].+)%:([^%?%:]+)%)")

				if cond then
					return string.format("gsl.__F((%s) and (true and (%s) or (gsl.__NIL)) or (%s))", cond, a, b)
				else
					error("Error parsing ternary expression `" .. cap)
					return nil
				end
			end)
		end

		-- Vector syntax: 
		-- |a, b, c, ..., z | creates a gsl.Vector with those elements
		-- Matrix syntax:
		-- 
		str = str:gsub("%|%|(.-)%|%|", function(cap)
			cap = "|" .. cap .. "|"
			local buf = buffer()
			local state = false
			for i = 1, #cap do
				local cur = cap:sub(i, i)
				if cur == "|" then 
					state = not state 
					buf:append(state and "{" or "}")
				else
					buf:append(cur)
				end
			end

			return "gsl.Matrix{" .. buf:tostring() .. "}"
		end):gsub("%|(.-)%|", "gsl.Vector({%1})")
		
		str = str:gsub("%*%*", "^"):gsub("(\"\"cap%d-\"\")", function(cap)
			return quoted[tonumber(cap:match("%d+"))]
		end)
	end
	
	return str
end

local compiled = {}
function gsl.util.compile(f, fun)
	if is_functor(f) then
		return f
	elseif type(f) == "string" then
		if compiled[f] then
			return compiled[f]
		else
			fun = fun or loadstring("local function _f(_v, i, j) return " ..
				f:gsub("%@", "_v") .. " end; return _f")()
			compiled[f] = fun
			return fun
		end
	else
		error("String or function expected")
	end
end

gsl.util.compile("*", function() return true end)
	

gsl.consts = {}
gsl.consts.CblasNoTrans=111
gsl.consts.CblasTrans=112
gsl.consts.CblasConjTrans=113
gsl.consts.CblasRowMajor=101
gsl.consts.CblasColMajor=102
gsl.consts.CblasLeft=141
gsl.consts.CblasRight=142
gsl.consts.CblasNonUnit=131
gsl.consts.CblasUnit=132
gsl.consts.CblasUpper=121
gsl.consts.CblasLower=122

gsl.consts.PREC_DOUBLE = 0
gsl.consts.PREC_SINGLE = 1
gsl.consts.PREC_APPROX = 2

-- DEFAULTS
gsl.number_format = "%20.3e"
gsl.fast = false
gsl.prec = gsl.consts.DOUBLE

gsl.nan = 0./0.
gsl.inf = 1./0.
