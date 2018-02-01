classdef UUID
    %UUID Universally-Unique IDentifier (aka GUID)
    %
    % UUID objects contain UUID values.
    %
    % The implementation is a wrapper around the Java UUID class, so this isn't
    % going to be very fast. But that shouldn't matter because UUIDs aren't used
    % for much besides equality comparison.
    
    properties (Constant, Hidden)
        J_ZERO = java.util.UUID(0, 0);
    end
	properties
		jval = jl.util.UUID.J_ZERO;
	end
	
	methods
        
        function this = UUID(x)
        %UUID Construct a new UUID
        if nargin == 0
            return;
        end
        if isa(x, 'jl.util.UUID')
            this = x;
        elseif isa(x, 'java.util.UUID')
            this.jval = x;
        elseif isa(x, 'java.util.UUID[]')
            this = repmat(this, size(x));
            for i = 1:numel(this)
                this(i).jval = x(i);
            end
        elseif ischar(x) || iscellstr(x) || isstring(x)
            x = cellstr(x);
            this = repmat(this, size(x));
            for i = 1:numel(this)
                this(i).jval = java.util.UUID.fromString(x{i});
            end
        else
            error('jl:InvalidInput', 'Invalid input type: %s', class(x));
        end
        end
        
        function out = toJavaArray(this)
        out = javaArray('java.util.UUID', numel(this));
        for i = 1:numel(this)
            out(i) = this(i).jval;
        end
        end
        
        function disp(this)
        %DISP Custom display
        disp(dispstr(this));
        end
        
        function out = dispstr(this)
        %DISPSTR Custom display string
        if ~isscalar(this)
            out = sprintf('%s %s', sizestr(this), class(this));
            return;
        end
        strs = dispstrs(this);
        out = strs{1};
        end
        
        function out = dispstrs(this)
        %DISPSTRS Custom display strings
        out = cell(size(this));
        for i = 1:numel(this)
            out{i} = char(this(i).jval.toString());
        end
        end
        
        function out = eq(a, b)
        a = jl.util.UUID(a);
        b = jl.util.UUID(b);
        [a,b] = scalarexpand(a, b);
        out = false(size(a));
        for i = 1:numel(a)
            out(i) = a(i).jval.equals(b(i).jval);
        end
        end
		
    end
    
    methods (Static)
        function out = ofLongHiAndLow(x)
        %OFLONGHIANDLOW Construct UUIDs from high/low bit values
        %
        % out = ofLongHiAndLow(x)
        %
        % X is an n-by-2 uint64 array that contains the most significant bits in
        % column 1 and the least significant bits in column 2.
        if ~isnumeric(x) || ~ismatrix(x) || size(x,2) ~= 2
            error('jl:InvalidInput', 'x must be n-by-2 numeric; got %s %s', ...
                sizestr(x), class(x));
        end
        x = uint64(x);
        out = repmat(jl.util.UUID, [size(x,1) 1]);
        for i = 1:size(x, 1)
            out(i).jval = java.util.UUID(x(i,1), x(i,2));
        end
        end
        
        function out = randomUUID()
        %RANDOMUUID Generate a random UUID.
        %
        % This uses Java's java.util.UUID.randomUUID() to implement the
        % generation.
        out = jl.util.UUID(java.util.UUID.randomUUID());
        end
    end

end