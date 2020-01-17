classdef ConformOptions
  % ConformOptions Options controlling xarray's conform() behavior
  
  properties
    mode (1,1) string = "union"
    broadcast (1,1) logical = true
    sortLabels (1,1) logical = false
    excludeDims double = []
  end
  
  methods
    
        function this = ConformOptions(arg)
            % ConformOptions construct a new object
            %
            % obj = ConformOptions()
            % obj = ConformOptions(arg)
            %
            % arg may be one of:
            %   - a struct
            %   - a cellrec or cell vector of name/value pairs
            %   - empty
            %   - a ConformOptions object
            % In the case of a struct or cell, the names or field names are
            % taken to be property names and their values are applied on top of
            % the default values.
            if nargin == 0
                return
            end
            if isa(arg, 'jl.sql.ConformOptions')
                this = arg;
                return
            end
            if isempty(arg)
                return;
            end
            if iscell(arg)
                arg = jl.util.parseOpts(arg);
            end
            if isstruct(arg)
                fnames = fieldnames(arg);
                for i = 1:numel(fnames)
                    this.(fnames{i}) = arg.(fnames{i});
                end
            else
                error('jl:InvalidInput', ['Invalid input to ConformOptions(): '...
                    'Expected struct or cell, got a %s'], class(arg));
            end
        end

        function this = set.mode(this, val)
          mustBeString(val);
          mustBeScalar(val);
          mustBeMember(val, ["union" "intersect"]);
          this.mode = val;
        end
    
  end
  
end