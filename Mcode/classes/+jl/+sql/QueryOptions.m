classdef QueryOptions
    % Options for the behavior of SQL queries that return results
    
    properties
        % Format to return text (char/varchar) columns in. May be 'string',
        % 'cellstr', 'categorical', or 'symbol'.
        textReturnFormat = 'string'
    end
    
    methods
        function this = QueryOptions(arg)
            % QueryOptions construct a new object
            %
            % obj = QueryOptions()
            % obj = QueryOptions(arg)
            %
            % arg may be one of:
            %   - a struct
            %   - a cellrec or cell vector of name/value pairs
            %   - empty
            %   - a QueryOptions object
            % In the case of a struct or cell, the names or field names are
            % taken to be property names and their values are applied on top of
            % the default values.
            if nargin == 0
                return
            end
            if isa(arg, 'jl.sql.QueryOptions')
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
                error('jl:InvalidInput', ['Invalid input to QueryOptions(): '...
                    'Expected struct or cell, got a %s'], class(arg));
            end
        end
    end
    
end