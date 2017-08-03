classdef mapmatrix
	%MAPMATRIX Array with labeled axis number lines
	%
	% A mapmatrix is a multidimensional array whose dimensions (axes) are labeled
	% with arbitrary values in addition to numeric indexes. This is used to verify
	% matrix alignment for mathematical operations, and to carry around labels for
	% presentation and debugging.
	%
	% The main array of data is referred to as "v" (for "values"). It can be of any
	% type that is well-behaved with respect to indexing operations.
	%
	% Each dimension may have an "axis" of values indicating what each index along
	% that dimension corresponds to, like a number line, or the labels on the axis of
	% a plot. Each axis also has a name.
	% 
	% When an operation is done between two mapmatrixes, their axis labels and values
	% are compared, and it is an error if they do not line up.
	
	properties
		% Number line labels for the axes, stored in an ndims-long cell array. Axes
		% which lack labels are indicated by nil.
		axes      cell = {1, 1};
		% Names for each axis. Axes which lack names are indicated by nil.
		axisNames cell = {'X', 'Y'};
		% The main value array
		v = [];
	end
	
	methods
		function this = mapmatrix(v, axes, axisNames)
		%MAPMATRIX Construct a new mapmatrix
		this.v = v;
		this.axes = axes;
		this.axisNames = axisNames;
		this.validate;
		end
		
		function disp(this)
		%DISP Display object
		dispf('  %s mapmatrix: %s', size2str(size(this)), strjoin(this.axisNames, ' x '));
		end
		
		function out = ndims(this)
		%NDIMS Number of dimensions.
		out = ndims(this.v);
		end
		
		function out = size(this, varargin)
		%SIZE Size of array.
		out = size(this.v, varargin{:});
		end
		
		function out = uitableView(this)
		%UITABLEVIEW View this in a uitable in a new figure.
		%
		% Only works for 2-D mapmatrixes.
		%
		% Returns the figure handle for the new figure.
		if ~ismatrix(this)
			error('uitableView is only supported for 2-D mapmatrixes');
		end
		fig = figure;
		uitable(fig, 'Data',this.v,...
			'RowName', this.axes{1},...
			'ColumnName', this.axes{2});
		out = fig;
		end
		
		function out = isAligned(a, b)
		%ISALIGNED Check alignment of mapmatrix dimensions
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
		%ALIGNEDARITHMETICOP Perform arithmetic function on aligned mapmatrixes
		%
		% The returned result is also wrapped in a mapmatrix.
		if ~isa(b, 'mapmatrix')
			out = a;
			out.v = feval(op, out.v, b);
		elseif ~isa(a, 'mapmatrix')
			out = b;
			out.v = feval(op, out.v, a);
		else
			% Both are mapmatrixes
			if ~isAligned(a, b)
				error('Inconsistent dimensions: a and b are not congruent');
			end
			out = a;
			out.v = feval(op, a.v, b.v);
		end
		end
		
		function validate(this)
		%VALIDATE Validate this' fields against mapmatrix's class invariants
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