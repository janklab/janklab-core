classdef struct2
    %STRUCT2 A struct that can have any strings as field names
    %
    % STRUCT2 behaves like a normal struct, except that it can have any arbitrary
    % string as a field name, not just valid Matlab identifiers.
    
    properties (Access = private)
        s           struct = struct
        otherNames  cell = {}
        otherValues cell
        % List of all field names, for maintaining ordering
        allFields   cell = {}
    end
    
    methods
        function this = struct2(varargin)
            %STRUCT2 Construct a struct2
            args = varargin;
            if isempty(args)
                return;
            end
            % Special calling forms
            if numel(args) == 1
                arg = args{1};
                if isstruct(arg)
                    this.s = arg;
                    this.allFields = fieldnames(s);
                else
                    error('jl:InvalidInput', 'Cannot convert a ''%s'' to a struct2',...
                        class(arg));
                end
                return
            end
            % Name/value pairs
            if ~mod(numel(args), 2) == 0
                error('jl:InvalidInput', 'struct2() must have an even number of arguments; got %d',...
                    numel(args));
            end
            for i = 1:2:numel(args)
                [key, value] = args{i:i+1};
                if ~ischar(key)
                    error('Odd-numbered arguments must be char, but arg %d was a %s',...
                        i, class(key));
                end
                if isvarname(key)
                    this.s.(key) = value;
                else
                    this.otherNames{end+1} = key;
                    this.otherValues{end+1} = value;
                end
                this.allFields{end+1} = key;
            end
        end
        
        function disp(this)
            %DISP Custom display
            if ~isscalar(this)
                fprintf('%s %s\n', size2str(size(this)), class(this));
            else
                fprintf('  %s with fields:\n', class(this));
                width = max(strlen(this.allFields));
                for i = 1:numel(this.allFields)
                    value = this.getfield(this.allFields{i});
                    fprintf('  %*s: %s\n', width, this.allFields{i}, dispstr(value));
                end
            end
        end
        
        function out = subsref(this, s)
            %SUBSREF Subscripted reference
            % Base case
            switch s(1).type
                case '()'
                    out = this(s(1).subs{:});
                case '{}'
                    error('jl:BadOperation',...
                        '{}-subscripting is not supported for class %s... yet', class(this));
                case '.'
                    out = this.getField(s(1).subs);
            end
            
            % Chained reference
            if numel(s) > 1
                out = subsref(out, s(2:end));
            end
        end
        
        function this = subsasgn(this, s, b)
            %SUBSASGN Subscripted assignment
            
            % Chained subscripts
            if numel(s) > 1
                rhs_in = subsref(this, s(1));
                rhs = subsasgn(rhs_in, s(2:end), b);
            else
                rhs = b;
            end
            
            % Base case
            switch s(1).type
                case '()'
                    if ~isa(rhs, class(this))
                        error('jl:TypeMismatch', 'Cannot assign %s in to a %s',...
                            class(rhs), class(this));
                    end
                    this(s(1).subs{:}) = rhs;
                case '{}'
                    error('jl:BadOperation',...
                        '{}-subscripting is not supported for class %s', class(this));
                case '.'
                    this = this.setfield(s(1).subs, rhs);
            end
        end
        
        function this = setfield(this, name, value)
            if isvarname(name)
                needToAdd = ~isfield(this.s, name);
                this.s.(name) = value;
                if needToAdd
                    this.allFields{end+1} = name;
                end
            else
                [tf,loc] = ismember(name, this.otherNames);
                if tf
                    this.otherValues{loc} = value;
                else
                    this.otherNames{end+1} = name;
                    this.otherValues{end+1} = value;
                    this.allFields{end+1} = name;
                end
            end
        end
        
        function out = getfield(this, name)
            if isvarname(name)
                out = this.s.(name);
            else
                [tf,loc] = ismember(name, this.otherNames);
                if ~tf
                    error('Reference to non-existent field ''%s''.', name);
                end
                out = this.otherValues{loc};
            end
        end
    end
    
end