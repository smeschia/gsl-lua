if #arg < 2 then
	error("Usage: lua doc.lua doc/undoc source")
end

local fid = io.open(arg[2], "r")
if not fid then error("Could not open " .. arg[2]) end

local matcher = "%-%-%[%[M(.-)%-%-%]%]"
local mode = "lua"
local ext = arg[2]:match("%.(.-)$")

if ext == "c" or ext == "h" or ext == "cpp" or ext == "hpp" or ext == "cc" then
	matcher = "%/%*M(.-)%*%/"
	mode = "c"
end
	
local str = fid:read("*a")

if arg[1] == "undoc" then
	local undoc = str:gsub(matcher, function(cap)
		return cap:gsub("[^\n]", "")
	end)
	print(undoc)
	return
end

local docs = {}
local modules = {}
local function trim(str) 
	return str:match("^[%s\n]*(.-)[%s\n]*$") 
end
local function iff(cond, a, b) 
	if cond then return a else return b end
end
local function copy(iter) 
	local tbl = {}
	for v in iter do 
		tbl[#tbl+1] = v
	end
	return tbl
end
local function keys(t)
  local key, value 
  return function()
    key, value = next(t, key)  
    return key
  end
end

local function buffer()
	local buf = {}
	function buf:append(s)
		buf[#buf+1] = s
		return buf
	end
	function buf:tostring() 
		return table.concat(buf)
	end
	return buf
end

local function opairs(t)
	local tkeys, i
	tkeys = copy(keys(t))
	table.sort(tkeys)
	i = 0
	return function()
		if (i <= #tkeys) then
			i = i+1
			return tkeys[i], t[tkeys[i]]
		end
	end
end

local function max(...)
	local args = {n = select('#', ...), ...}
	local max = -math.huge
	for i = 1, args.n do
		if args[i] ~= nil then max = math.max(args[i], max) end
	end
	return max
end

local function printf(fmt, ...) print(string.format(fmt, ...)) end

local function keywords(str)
	return str:gsub("@example", "###### Example:")
end

local lastmod = "@intro"
local modules = {}


for docsnip in str:gmatch(matcher) do
	docsnip = trim(docsnip)
	
	local modsubs = {}
	
	if docsnip:find("%@module") ~= 1 then
		modsubs[1] = {lastmod, 1}
	end
	
	for mod, pos in docsnip:gmatch("%@module (.-)()\n") do
		modsubs[#modsubs+1] = {mod, pos}
	end
	
	for i = 1, #modsubs do
		local modname = modsubs[i][1]
		local pos = modsubs[i][2]
		local to = (i == #modsubs and #docsnip or modsubs[i+1][2])
		modules[modname] = (modules[modname] or buffer())
		modules[modname]:append(docsnip:sub(pos, to):gsub("%@module(.-)\n", ""))
	end
	
	lastmod = modsubs[#modsubs][1]
end

local totfields = 0
for name, section in pairs(modules) do

	modules[name] = {}
	local fieldsubs = {}
	section = trim(section:tostring())

	if section:find("%@field") ~= 1 then
		fieldsubs[1] = {"@intro", 1}
	end
	if section:find("%@field") then
		for fld, pos in section:gmatch("%@field (.-)()\n") do
			fieldsubs[#fieldsubs+1] = {fld, pos}
		end
	end
	
	for i = 1, #fieldsubs do
		local fldname = fieldsubs[i][1]
		local pos = fieldsubs[i][2]
		local to = (i == #fieldsubs and #section or fieldsubs[i+1][2])
		modules[name][fldname] = trim(section:sub(pos, to):gsub("%@field (.-)\n", ""))

		totfields = totfields + 1
	end
end

if modules["@intro"] then
	if modules["@intro"]["@intro"] then
		printf(modules["@intro"]["@intro"])
	end
	modules["@intro"] = nil
end

local all = {}
printf("\n***********************\n")
printf("## Index\n")

--[[
local len = 0
for modname, fields in opairs(modules) do
	local col = {"**[" .. modname .. "][]**"}
	for fldname, _ in opairs(fields) do
		if not fldname:find("@") then
			if mode == "lua" and trim(modname) ~= "" then
				fldname = modname .. "." .. fldname
			end
			col[#col+1] = string.format("[%s][]", fldname)
			len = math.max(len, #col[#col])
		end
	end
	col[#col+1] = ""
	all[#all+1] = col
end

printf("||  ||")
printf("|:-|:-|:-|")

local fmt = string.rep("|%" .. len .. "s", 3)
for i = 1, #all, 3 do
	all[i+1] = all[i+1] or {}
	all[i+2] = all[i+2] or {}
	local rows = max(#all[i], #all[i+1], #all[i+2])
	for j = 1, rows do 
		printf(string.format(fmt, all[i][j] or "", all[i+1][j] or "", 
			all[i+2][j] or ""), "|")
	end
end
--]]

for modname, fields in opairs(modules) do
	print("**[" .. modname .. "][]**\n")
	for fldname, _ in opairs(fields) do
		if not fldname:find("@") then
			if mode == "lua" and trim(modname) ~= "" then
				fldname = modname .. "." .. fldname
			end
			io.write(string.format(" &bull; [%s][]", fldname))
		end
	end
	io.write("\n\n")
end

printf("\n\n***********************\n")
printf("\n## Reference\n")

for modname, fields in opairs(modules) do
--	printf("<a name=\"module-%s\" />\n", modname)
	printf("### %s", modname, modname)
	
	if modules[modname]["@intro"] then
		print(keywords(modules[modname]["@intro"]), "\n")
	end
	modules[modname]["@intro"] = nil
	
	modname = trim(modname:gsub("%@", ""))
	
	for flname, flbody in opairs(fields) do
		if mode == "lua" and modname ~= "" then flname = modname .. "." .. flname end
		printf("#### %s", flname)
		
		print(keywords(flbody), "\n")
	end
	printf("\n***********************\n")
end