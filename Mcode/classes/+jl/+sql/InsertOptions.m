classdef InsertOptions
    
    properties
        % Whether column names in the generated SQL statement should be quoted
        % This is off by default because using quoted column names can make
        % the insert logic stricter and cause breakage with Postgres.
        quoteColumnNames logical = false
    end
    
    methods
        function obj = InsertOptions(arg)
            % InsertOptions construct a new object
            %
            % obj = InsertOptions()
            % obj = InsertOptions(arg)
            %
            % arg may be one of:
            %   - a struct
            %   - a cellrec or cell vector of name/value pairs
            %   - empty
            %   - an InsertOptions object
            % In the case of a struct or cell, the names or field names are
            % taken to be property names and their values are applied on top of
            % the default values.
            if nargin == 0
                return
            end
            if isa(arg, 'jl.sql.InsertOptions')
                obj = arg;
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
                    obj.(fnames{i}) = arg.(fnames{i});
                end
            else
                error('jl:InvalidInput', ['Invalid input to InsertOptions(): '...
                    'Expected struct or cell, got a %s'], class(arg));
            end
        end

    end
end