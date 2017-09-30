classdef strings
    %STRINGS A collection of string utility functions
    
	methods (Static = true)
		
		function out = strlen(str)
			%STRLEN Length of strings
			%
			% out = jl.strutil.strlen(str)
			%
			% Returns the length in characters of each string in the given
			% array.
			%
			% Str may be char or cellstr. If it is char, it is interpreted as a
			% 2-D char array of strings. This means trailing whitespace is
			% ignored in char inputs, even for a single string as char.
			if ischar(str)
				if isempty(str) && size(str,1) > 1
					out = zeros(size(str,1), 1);
				else
					out = jl.strutil.strlen(cellstr(str));
				end
			elseif iscellstr(str)
				out = cellfun('length', str);
			else
				error('jl:InvalidInput', 'Unsupported type: strlen requires char or cellstr input; got %s', class(str));
			end
		end
    end
    
    methods (Access = private)
        function obj = strings
            %STRINGS Private constructor to suppress helptext
        end
    end
	
 end

