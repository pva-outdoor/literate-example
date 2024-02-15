local rawget = rawget
_ENV.defvar = true

setmetatable(
   _ENV, {
	  __newindex = function (_, n, val)
		 error("attempt to write to undeclared variable "..n, 2)
	  end,
	  __index = function (_, n)
		 print("attempt to read undeclared variable "..n)
		 return nil
	  end
})

return function(name, initval)
       local declared = rawget(_ENV, name)
       if nil ~= declared then
	      print(string.format("warning: Redeclaration of %s (which is %s).", name, declared))
       end
       rawset(_G, name, initval or false)
end
