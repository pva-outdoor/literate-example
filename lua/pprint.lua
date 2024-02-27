if _ENV.defvar then
       defvar("pprint")
end

      return function(obj, options)
	      local visited = {}
		 local format, find = string.format, string.find
		 local print, getmetatable, type = print, getmetatable, type
		 local sort = table.sort
		 local unpack = table.unpack
		 local EMPTY = {}
		 local INDENTS, BULLETS = {" ", " "}, {" │ ", " ├ ", "   ", " └ "}
		 options = options or EMPTY
		 local name = options.name or "<value>"
		 local out = options.out or io.output()
		 local maxlines = options.maxlines or 24
		 local maxdepth = options.maxdepth or 8
		 local showlineno = options.showlineno
		 local showtypes = options.showtype
		 local midind, midbul, lastind, lastbul = unpack(options.bullets or BULLETS)
		 local leftind, leftbul = unpack(options.indent or INDENTS)
		 local function parse_filter(search)
		        local filter
		        if search then
		 	      name = format("%s filtered with `%s'", name, search)
		 	      local search_type = type(search)
		 	      if "string" == search_type then
		 		 filter = function(x)
		 			return "string" == type(x)
		 			       and nil ~= find(x, search)
		 		 end
		 	      elseif "function" == search_type then
		 		 filter = search
		 	      else
		 		 filter = function(x) return x == search end
		 	      end
		        else
		 	      filter = function() return true end
		        end
		 
		        local function search_pattern_recursive(obj)
		               if nil ~= obj then
		        	      local vis = visited[obj]
		        	      if nil == vis then
		        		 vis = filter(obj)		   
		        		 if "table" == type(obj) then
		        			-- не допустить рекурсию
		        			visited[obj] = vis
		        			       if not vis then
		        			              local __tostring = (getmetatable(obj) or EMPTY).__tostring
		        			              if __tostring and filter(__tostring(obj)) then
		        			       	      vis = true
		        			              end
		        			       end
		        			       for k, v in pairs(obj) do
		        			              local vk, vv =
		        			       	      search_pattern_recursive(k),
		        			       	      search_pattern_recursive(v)
		        			              if vk or vv then vis = true end
		        			       end
		        		 end
		        		 visited[obj] = vis
		        	      end
		        	      return vis
		               end
		        end
		        search_pattern_recursive(obj)
		 end
		 parse_filter(options.search)
		 
		 local depth, lines = 0, 0
		        local function do_pprint(line)
		               lines = lines + 1
		        	      if showlineno then out:write(format("%3d", lines)) end
		        	      out:write(line)
		               if maxlines < lines then
		        	      error("Too many lines, use pprint(x, {maxlines=...}) to override")
		               end
		        end
		        local function pprint(obj, name, indent, bullet)
		               if "table" == type(obj) then
		        	      local vis = visited[obj]
		        	      if "string" == type(vis) then
		        		 obj = vis
		        	      else
		        			local __tostring = (getmetatable(obj) or EMPTY).__tostring
		        			if __tostring then
		        			       obj = __tostring(obj)
		        			       visited[obj] = obj
		        			else
		        			       do_pprint(format("%s%s:\n", bullet, name))
		        			       depth = depth + 1
		        			       if depth <= maxdepth then
		        				      visited[obj] = format("same as %s", name) -- TODO: path
		        					 local keys = {}
		        					 for k, v in pairs(obj) do
		        					        if visited[k] or visited[v] then
		        					 	      keys[1 + #keys] = k
		        					        end
		        					 end
		        					        sort(keys)
		        					        local indent1, bullet1 = indent..midind, indent..midbul
		        					        for i, k in ipairs(keys) do
		        					               if i == #keys then
		        					        	      indent1, bullet1 = indent..lastind, indent..lastbul
		        					               end
		        					               pprint(obj[k], k, indent1, bullet1)
		        					        end
		        			       else
		        				      do_pprint(format("%s   ...\n", indent))
		        			       end
		        			       depth = depth - 1
		        			       return
		        			end
		        	      end
		               end
		        	      if showtypes then
		        	             do_pprint(format("%s%s: (%s) %s\n", bullet, name, type(obj), obj))
		        	      else
		        	             do_pprint(format("%s%s: %s\n", bullet, name, obj))
		        	      end
		        end
		        local ok, err = pcall(pprint, obj, name, leftind, leftbul)
		        if not ok then
		               out:write(err, "\n")
		        end
       end
