classdef dataarray
	%DATAARRAY Array with labeled axis number lines
	%
	% A dataarray is a multidimensional array whose dimensions (axes) are labeled
	% with arbitrary values in addition to numeric indexes. This is used to verify
	% array alignment for mathematical operations, and to carry around labels for
	% presentation and debugging.
	%
	% The main array of data is referred to as "v" (for "values"). It can be of any
	% type that is well-behaved with respect to indexing operations. It must
	% also support arithmetic operations, if you use them on the containing
	% dataarray object.
	%
	% Each dimension may have an "axis" of values indicating what each index along
	% that dimension corresponds to, like a number line, or the labels on the axis of
	% a plot. Each axis also has a name.
	% 
	% When an operation is done between two dataarrayes, their axis labels and values
	% are compared, and it is an error if they do not line up.
    %
    % CONSTRUCTING DATAARRAYS
    %
    % Typically, you construct a dataarray by supplying the axis values, axis
    % labels, and main values. Alternately, you can create one by converting
    % another type to a dataarray, such as by pivoting a relation
    % object.
    %
    % As a convenience, you can also convert numeric arrays directly to a
    % dataarray. In a standalone context, the axes use a set of default labels
    % ('X', 'Y', 'Z', and TBD...) and default values (1 to the length of the
    % axis. In a two-operand arithmetic context, the raw numeric array is
    % assumed to be aligned with its corresponding dataarray
	
	properties
		% Number line labels for the axes, stored in an ndims-long cell array. Axes
		% which lack labels are indicated by nil.
		axes      cell = {1, 1};
		% Names for each axis. Axes which lack names are indicated by nil.
		axisNames cell = {'X', 'Y'};
		% The main value array
		v = NaN;
	end
	
	methods
		function this = dataarray(varargin)
		%DATAARRAY Construct a new dataarray
        if nargin == 0
            return
        elseif nargin == 1
            x = varargin{1};
            if isa(x, 'dataarray')
                this = x;
            elseif isnumeric(x)
                this = dataarray.ofRawNumericArray(x);
            else
                error('jl:InvalidInput', 'No conversion defined from %s to dataarray', ...
                    class(x));
            end
        elseif nargin == 3
            [v, axes, axisNames] = varargin{:};
            this.v = v;
            this.axes = axes;
            this.axisNames = axisNames;
            this.validate;
        else
            error('jl:InvalidInput', 'Invalid number of inputs');
        end
        end
		
        function out = naxes(this)
        out = NaN(size(this));
        for i = 1:numel(out)
            out(i) = numel(this(i).axes);
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
            out{i} = sprintf('dataarray: %s (%s)', ...
                sizestr(this(i).v), strjoin(this(i).axisNames, ', '));
        end
        end
        
        function prettyprint(this)
        %PRETTYPRINT Pretty-print this' contents
        %
        % Only works on scalars, currently.
        mustBeScalar(this);
        dispf('dataarray:');
        dispf('Axes: %s', strjoin(this.axisNames, ', '));
        for i = 1:naxes(this)
            dispf('  Axis %d: %s: %s', i, this.axisNames{i}, ...
                strjoin(dispstrs(this.axes{i}), ', '));
        end
        dispf('Data:');
        if ismatrix(this.v)
            disp(this.v);
        else
            dispf('  %s %s', sizestr(this.v), class(this.v));
        end
        end
				
		function out = uitableView(this)
		%UITABLEVIEW View this in a uitable in a new figure.
		%
		% Only works for 2-D dataarrayes.
		%
		% Returns the figure handle for the new figure.
		if ~ismatrix(this)
			error('uitableView is only supported for 2-D dataarrayes');
		end
		fig = figure;
		uitable(fig, 'Data',this.v,...
			'RowName', this.axes{1},...
			'ColumnName', this.axes{2});
		out = fig;
		end
		
		function out = isAligned(a, b)
		%ISALIGNED Check alignment of dataarray dimensions
		out = isequal(size(a), size(b)) && isequal(a.axes, b.axes) && isequal(a.axisNames, b.axisNames);
		end
		
		function out = plus(a, b)
		%+ Plus.
		%
		% A + B adds matrices A and B. A and B must have compatible sizes, and if
		% they are mapmatrices, must have compatible axis names and values.
		out = alignedArithmeticOp(@plus, a, b);
		end
		
		function out = minus(a, b)
		%- Minus.
		%
		% A - B subtracts matrix B from A. A and B must have compatible sizes, and if
		% they are mapmatrices, must have compatible axis names and values.
		out = alignedArithmeticOp(@minus, a, b);
		end
		
		function out = times(a, b)
		%.* Array multiply.
		%
		% A .* B does element-by-element multiplication. A and B must have compatible
		% sizes, and if they are mapmatrices, must have compatible axis names and
		% values.
		out = alignedArithmeticOp(@times, a, b);
		end
		
		function out = rdivide(a, b)
		%./ Right array divide.
		%
		% A ./ B does element-by-element division. A and B must have compatible
		% sizes, and if they are mapmatrices, must have compatible axis names and
		% values.
		out = alignedArithmeticOp(@rdivide, a, b);
		end
	end
	
	methods (Access = private)
		
		function out = alignedArithmeticOp(op, a, b)
		%ALIGNEDARITHMETICOP Perform arithmetic function on aligned dataarrayes
		%
		% The returned result is also wrapped in a dataarray.
		if ~isa(b, 'dataarray')
			out = a;
			out.v = feval(op, out.v, b);
		elseif ~isa(a, 'dataarray')
			out = b;
			out.v = feval(op, out.v, a);
		else
			% Both are dataarrayes
			if ~isAligned(a, b)
				error('jl:InconsistenDims', 'Inconsistent dimensions: a and b are not congruent');
			end
			out = a;
			out.v = feval(op, a.v, b.v);
		end
		end
		
		function validate(this)
		%VALIDATE Validate this' fields against dataarray's class invariants
		if ~iscell(this.axes) || ~isvector(this.axes)
			error('Axes must be a cell vector; got a %s %s', size2str(size(this.axes)), class(this.axes));
		end
		if ~isequal(ndims(this.v), numel(this.axes), numel(this.axisNames))
			error('Inconsistent dimensions: got %d-dim values but %d-long axes and %d-long axisNames',...
				ndims(this.v), numel(this.axes), numel(this.axisNames));
		end
		for i = 1:numel(this.axes)
			if numel(this.axes{i}) ~= size(this.v, i)
				error('Inconsistent dimensions: axis %d is %d long, but values dimension %d is %d long',...
					i, numel(this.axes{i}), i, size(this.v, i));
			end
		end
		end
		
	end
	
end