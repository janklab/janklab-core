classdef (Sealed) DataArray
  %DataArray A multidimensional array with labeled indexes along its dims
  %
  % An DataArray is a multidimensional array that has coords along its
  % dimensions. This allows you to label the positions along each dimension
  % with significant domain/business values, instead of just using numeric
  % indexes. You can then index into the array using either numeric/logical
  % indexing like a normal Matlab array, or with the dimension coords.
  %
  % DataArray is designed for dealing with multidimensional scientific data.
  %
  % To index into an DataArray using the dimension coords, index using {}
  % instead of (). The () indexing does normal numeric/logical indexing;
  % the {} operator does indexing against the coords for each dimension.
  %
  % Note: As a special case, the value ':', when used for label indexing,
  % always refers to "all elements" along that dimension, instead of those
  % exactly matching a literal ':'. This is for compatibility with how
  % Matlab represents indexes for the special magic colon operator. This
  % effectively means you cannot use ':' as a label.
  %
  % Semantically, an DataArray is similar to a Matlab table array or an SQL
  % table, where a set of variables/columns constitutes the primary key,
  % and there is a single dependent non-key value column. In an DataArray, the
  % key columns are laid out along the dimensions, and the value column is
  % contained in the main N-D array. This is a lot like an OLAP cube from
  % the database world. This layout provides for fast indexing, lookup, and
  % subsetting operations, and compact storage for the case when you have
  % many key columns and a relatively dense "fill factor".
  %
  % Conceptually, DataArray is part of the jl.xmarray package. But I have
  % made it a top-level class to make it easier to reference, because using
  % imports in Matlab is tedious.
  %
  % DataArray is inspired by the Python xarray library
  % (http://xarray.pydata.org/en/stable/). It works in a similar manner.
  % See: Hoyer, S. & Hamman, J., (2017). xarray: N-D labeled Arrays and 
  % Datasets in Python. Journal of Open Research Software. 5(1), p.10.
  % DOI: http://doi.org/10.5334/jors.148
  %
  % Most of the aggregate arithmetic operations (like PROD, DIFF, CUMSUM,
  % and so on) are not implemented yet, because I haven't settled on how to
  % handle the dimension-collapsing behavior that they entail. SUM is
  % currently implemented as an example of what I'm currently thinking for
  % it.
  %
  % DataArray is a work in progress as of January 2020. Feedback is welcome.
  % Also, I don't understand matrix math well enough to know how mldivide(),
  % mrdivide(), and inv() should work here.
  
  % TODO: Broadcasting and scalar expansion! Broadcasting should operate by
  %       dimension name, not position.
  % TODO: groupby
  % TODO: Support dimensions without coordinates?
  % TODO: sortrows, N-D generalization of sortrows
  % TODO: Aggregate arithmetic (prod, min, max) with dim collapsing
  % TODO: Statistics (mean, median, std, etc.)
  %       Note: both agg arith and statistics are probably just special
  %       cases of groupby
  % TODO: Window arithmetic/statistics (cumsum, cumprod, diff)
  % TODO: Matrix division (mldivide, mrdivide)
  % TODO: Matrix inverse (inv). I don't know what the resulting dimensions
  %       should be.
  % TODO: Multi-DataArray structure like xarray's Dataset
  % TODO: NetCDF and HDF5 I/O
  % TODO: DataUnits?
  % TODO: Plotting
  % TODO: Attributes?
  % TODO: Have squeeze accept a list of dims
  
  properties
    % The main N-dimensional array of values. May be any type.
    values = []
    % The list of coordinates for the dimensions of values.
    coords cell = {}
    % Names of the dimensions.
    dims string = string.empty
    % Name for the values.
    valueName (1,1) string = string(missing)
  end
  properties (Dependent = true)
    % Type of underlying values array. This will be the class name of
    % values.
    valueType
  end
  
  methods (Static)
    function out = empty()
      %EMPTY Construct a new empty DataArray
      %
      % out = DataArray.empty()
      %
      % Only the zero-arg version of empty() is supported, because empty
      % DataArrays that are non-zero-long along any dimension require
      % additional information to construct.
      %
      % Returns a 0-D DataArray.
      out = DataArray;
    end
  end
  
  methods
    
    function this = DataArray(values, coords, dims, valueName)
      %DATAARRAY Construct a new object
      %
      % obj = DataArray()
      % obj = DataArray(dataArray)
      % obj = DataArray(values, coords)
      % obj = DataArray(values, coords, dims)
      % obj = DataArray(values, coords, dims, valueName)
      %
      % values is the underlying N-dimensional array you wish to wrap in a
      % data array. It may be of any type that supports normal Matlab array
      % operations. (Which means pretty much any type.)
      %
      % coords (cell) is a list of coordinates to label the dimensions of
      % the DataArray with. It is a cell vector where coords{i} is the
      % coordinates list for dimension i. It must have as many elements as
      % values has dimensions. Each coords{i} must be a vector that is the
      % same length as values is long along that dimension. The individual
      % coords{i} may be of any type that supports normal Matlab array
      % operations.
      %
      % dims (string) is an optional list of dimension names. If supplied,
      % it must be a vector whose length is equal to the number of
      % dimensions in values. It is okay to have missing values for any of
      % the names. If omitted, the dimension names all default to missing.
      %
      % valueName (scalar string) is an optional name for the values array.
      %
      % For the special calling form DataArray(dataArray), when you pass in
      % an existing DataArray, it just returns the input unmodified.
      if nargin < 3 || isempty(dims); dims = string.empty; end
      if nargin < 4 || isempty(valueName); valueName = string.empty; end
      if nargin == 0
        return
      end
      if isa(values, 'DataArray')
        this = values;
        return
      end
      this.values = values;
      this.coords = coords;
      dims = string(dims);
      if isempty(dims)
        dims = repmat(string(missing), [1 ndims(values)]);
      end
      this.dims = dims;
      this.valueName = valueName;
      validate(this);
    end
    
    function out = get.valueType(this)
      out = class(this.values);
    end
    
    function out = vals(this)
      %VALS Get the underlying values array
      %
      % out = vals(obj)
      %
      % This is an alias for obj.values, provided so you can use it in inline
      % expressions.
      %
      % Returns an array of whatever type obj.values is.
      out = this.values;
    end
    
    function validate(this)
      %VALIDATE Validate the object
      %
      % validate(obj)
      %
      % Checks obj's properties for validity and internal consistency.
      % Raises an error if obj is not valid.
      %
      % This is defined as an explicit method instead of being done on any
      % property mutation both for efficiency, and because some
      % modifications to a DataArray require multiple properties to be
      % modified in a manner that cannot be done atomically.
      mustBeA(this.coords, 'cell');
      if ~isequal(numel(this.coords), ndims(this.values))
        error('Inconsistent dimensions: %d dims in values, but %d label lists', ...
          ndims(this.values), numel(this.coords));
      end
      if ~isequal(ndims(this.values), numel(this.dims))
        error('Inconsistent dimensions: %d dims in values, but %d dims', ...
          ndims(this.values), numel(this.dims));
      end
      for i = 1:ndims(this)
        if numel(this.coords{i}) ~= size(this.values, i)
          error('Inconsistent dimensions: values is %d long along dimension %d, but coords{%d} is %d long', ...
            size(this.values, i), i, i, numel(this.coords{i}));
        end
      end
    end
    
    function disp(this)
      %DISP Custom display
      %
      % disp(obj)
      %
      % Displays obj to the Matlab console. The output will include the
      % underlying values if that array is not too large, for some
      % arbitrary value of "too large".
      fprintf('xmarray DataArray: %d-D %s (%s)\n', ndims(this), size2str(size(this)), ...
        this.valueType);
      for i = 1:ndims(this)
        if ismissing(this.dims(i))
          fprintf('  dim %d: %s\n', i, ellipsesOrMissing(this.coords{i}));
        else
          fprintf('  dim %d ("%s"): %s\n', i, this.dims(i), ...
            ellipsesOrMissing(this.coords{i}));
        end
      end
      % If Matlab supported static class properties, that's where I'd put
      % this, so users could configure it. But oh well. I don't want to
      % bother making a persistent method wrapper for it.
      maxDisplaySize = 1000;
      if numel(this) < maxDisplaySize
        disp(this.values);
      end
    end
    
    function out = dispstrs(this)
      %DISPSTRS Display strings for this' underlying values
      %
      % out = dispstrs(obj)
      %
      % Gets display strings for the individual elements of obj's values.
      % Dimension names, coordinates, and valueNames are not included.
      %
      % Returns a cellstr array the same size as this.
      out = dispstrs(this.values);
    end
    
    function out = dispstr(this)
      %DISPSTR Custom display string for array
      %
      % out = dispstr(obj)
      %
      % Gets a display string representing this entire array. This is
      % suitable for debugging output.
      %
      % Returns a charvec.
      
      % TODO: Add dim names
      out = sprintf('DataArray (%s): %s', ...
        this.valueType, size2str(size(this)));
    end
    
    function out = mat2str(this)
      %MAT2STR Generate Matlab code that will reconstruct this object
      %
      % out = mat2str(obj)
      %
      % Generates a Matlab code expression that can be used to reconstruct
      % the value of obj.
      %
      % If any of the values or coords in obj are handle objects, the
      % resulting code will not work right. Requires all coords and values
      % in obj to also support mat2str.
      %
      % Returns a charvec.
      out = sprintf('DataArray(%s, %s, %s, %s)', ...
        mat2str(this.values), mat2str(this.coords), mat2str(this.dims), ...
        mat2str(this.valueName));
    end
    
    function out = ndims(this)
      %NDIMS Number of dimensions
      %
      % out = ndims(obj)
      %
      % Number of dimensions in obj.
      %
      % Unlike most Matlab arrays, ndims() on an DataArray object may return 1
      % or 0.
      out = numel(this.coords);
    end
    
    function out = size(this, varargin)
      %SIZE Array size
      %
      % out = size(obj)
      % out = size(obj, dim)
      %
      % Get the size of this array. This is the same as the size of the
      % underlying values, or the lengths of all the coords arrays.
      %
      % NOTE: Conceptually, unlike normal Matlab objects, DataArray objects
      % may be 1-D or 0-D. It is TBD how that will be reflected by the size
      % method. For now, it always returns a vector at least 2 elements
      % long.
      %
      % Returns a double vector.
      out = size(this.values, varargin{:});
    end
    
    function out = numel(this)
      %NUMEL Number of elements
      %
      % out = numel(obj)
      %
      % Gets the number of elements in this array. This is the same as the
      % number of elements in the underlying values array.
      out = numel(this.values);
    end
    
    function out = length(this)
      %LENGTH Length along longest dimension
      %
      % out = length(obj)
      %
      % Gets the length along the longest dimension of obj.
      %
      % Don't use this. Use numel or size instead.
      out = length(this.values);
    end
    
    % Structural operations
    
    function out = circshift(this, k, dim)
      narginchk(2, 3);
      out = this;
      if nargin == 2
        if isscalar(k)
          sz = size(this);
          ixDim = find(sz > 1, 1);
          out = circshift(this, k, ixDim);
        else
          tmp = this;
          for iDim = 1:numel(k)
            tmp = circshift(tmp, k(iDim), iDim);
          end
          out = tmp;
        end
      else
        out.values = circshift(this.values, k);
        out.coords{dim} = circshift(this.coords{dim}, k);
      end
    end
    
    function out = permute(this, dimorder)
      out = this;
      out.coords = this.coords(dimorder);
      out.dims = this.dims(dimorder);
      out.values = permute(this.values, dimorder);
    end
    
    function out = ipermute(this, dimorder) %#ok<STOUT,INUSD>
      UNIMPLEMENTED
    end
    
    function out = ctranspose(this)
      if ~ismatrix(this)
        error('input for ctranspose must be a matrix; this is %d-d', ...
          ndims(this));
      end
      out.values = ctranspose(this);
      out.coords = this.coords([2 1]);
      out.dims = this.dims([2 1]);
    end
    
    function out = transpose(this)
      if ~ismatrix(this)
        error('input for transpose must be a matrix; this is %d-d', ...
          ndims(this));
      end
      out.values = transpose(this);
      out.coords = this.coords([2 1]);
      out.dims = this.dims([2 1]);
    end
    
    function out = squeeze(this)
      %SQUEEZE Remove singleton dimensions
      %
      % Note: Unlike squeeze() on regular arrays, squeeze() on an DataArray is a
      % lossy operation! It discards the coords and dims for the squeezed
      % dimensions. This affects the semantics of the object!
      ixScalar = find(size(this) == 1);
      out = this;
      out.values = squeeze(this.values);
      out.coords(ixScalar) = [];
      out.dims(ixScalar) = [];
    end
    
    function out = shiftdim(this, n)
      if nargin == 1
        % TODO: implement 1-arg shiftdim
        error('The 1-arg form of shiftdim is unimplemented for DataArray');
      end
      out = this;
      out.values = shiftdim(this.values, n);
      out.dims = circshift(this.dims, n);
      out.coords = circshift(this.coords, n);
    end
    
    function out = sortdims(this)
      %SORTDIMS Sort this based on its dimension coords
      %
      % out = sortdims(obj)
      %
      % Sorts obj based on the natural ordering of the coord values along
      % its dimensions. This means that the coords arrays are sorted, and
      % the underlying values array is reordered along those dimensions to
      % match.
      %
      % Returns an updated DataArray.
      
      % TODO: Add an option that allows you to select which dims to sort
      % on.
      out = this;
      for iDim = 1:ndims(this)
        [~,ix] = sort(this.coords{iDim});
        out = subsetAlongDim(out, iDim, ix);
      end
    end
    
    function out = cat(dim, varargin)
      args = varargin;
      tmp = args{1};
      mustBeA(tmp, 'DataArray', 'input 2');
      % TODO: Check values name and dim name
      for i = 2:numel(args)
        mustBeA(args{i}, 'DataArray', sprintf('input %d', i+1));
        [tmp,b] = align(tmp, args{i}, {'excludeDims',dim});
        collisions = intersect(tmp.coords{dim}, b.coords{dim});
        if ~isempty(collisions)
          error('Duplicate coords in inputs for dimension %d: %s', ...
            dim, jl.utils.ellipses(collisions));
        end
        newcoords = [tmp.coords{dim} b.coords{dim}];
        newValues = cat(dim, tmp.values, b.values);
        tmp.coords{dim} = newcoords;
        tmp.values = newValues;
      end
      out = tmp;
    end
    
    function out = horzcat(varargin)
      out = cat(2, varargin{:});
    end
    
    function out = vertcat(varargin)
      out = cat(1, varargin{:});
    end
    
    function mustBeSameDimStructure(a, b)
      % Require that inputs have the same dimensional structure
      %
      % mustBeSameDimStructure(a, b)
      %
      % Requires that a and b have the same dimensional structure. This
      % means that they have the same values for dims and coords, except
      % for where there are missing values (missing values are allowed to
      % match against anything).
      %
      % Raises an error if the requirement is not met.
      if ~isequaln(a.coords, b.coords)
        error(['a and b must have same dimension structure, but they ' ...
          'differ in their dimension coords']);
      end
      if ~isequaln(a.dims, b.dims)
        error(['a and b must have same dimension structure, but they ' ...
          'differ in their dimension names']);
      end
    end
    
    % Type tests
    
    function out = isnan(this)
      out = isnan(this.values);
    end
    
    function out = ismissing(this)
      out = ismissing(this.values);
    end
    
    function out = isempty(this)
      out = isempty(this.values);
    end
    
    function out = isfinite(this)
      out = isfinite(this.values);
    end
    
    function out = isreal(this)
      out = isreal(this.values);
    end
    
    function out = isrow(this)
      out = isrow(this.values);
    end
    
    function out = ismatrix(this)
      out = ismatrix(this.values);
    end
    
    function out = iscolumn(this)
      out = iscolumn(this.values);
    end
    
    function out = isvector(this)
      out = isvector(this.values);
    end
    
    function out = isscalar(this)
      out = isscalar(this.values);
    end
    
    % Relational operations (relops)
    
    function out = eq(a, b)
      [a,b] = promote(a, b);
      mustBeSameDimStructure(a, b);
      out = eq(a.values, b.values);
    end
    
    function out = ne(a, b)
      [a,b] = promote(a, b);
      mustBeSameDimStructure(a, b);
      out = ne(a.values, b.values);
    end
    
    function out = lt(a, b)
      [a,b] = promote(a, b);
      mustBeSameDimStructure(a, b);
      out = lt(a.values, b.values);
    end
    
    function out = le(a, b)
      [a,b] = promote(a, b);
      mustBeSameDimStructure(a, b);
      out = le(a.values, b.values);
    end
    
    function out = gt(a, b)
      [a,b] = promote(a, b);
      mustBeSameDimStructure(a, b);
      out = gt(a.values, b.values);
    end
    
    function out = ge(a, b)
      [a,b] = promote(a, b);
      mustBeSameDimStructure(a, b);
      out = ge(a.values, b.values);
    end
    
    function out = or(a, b)
      [a,b] = promote(a, b);
      mustBeSameDimStructure(a, b);
      out = a;
      out.values = or(a.values, b.values);
      out.valueName = maybeSprintf('(%s | %s)', a.valueName, b.valueName);
    end
    
    function out = and(a, b)
      [a,b] = promote(a, b);
      mustBeSameDimStructure(a, b);
      out = a;
      out.values = and(a.values, b.values);
      out.valueName = maybeSprintf('(%s & %s)', a.valueName, b.valueName);
    end
    
    function out = xor(a, b)
      [a,b] = promote(a, b);
      mustBeSameDimStructure(a, b);
      out = a;
      out.values = and(a.values, b.values);
      out.valueName = maybeSprintf('(%s XOR %s)', a.valueName, b.valueName);
    end
    
    function out = not(this)
      out = this;
      out.values = not(this.values);
      out.valueName = maybeSprintf('~%s', this.valueName);
    end
    
    function out = apply(fcn, this)
      %APPLY Apply a unary function to an input DataArray
      %
      % out = apply(fcn, obj)
      %
      % This applies a given function to the values in obj, producing a new
      % DataArray of the same dimensional structure.
      %
      % fcn (function handle) is the function to apply to a and b's values once
      % aligned. It must return an array of the same size as its
      % input, whose output elements correspond to the input arguments in
      % the same position.
      %
      % Returns a DataArray.
      mustBeA(this, 'DataArray');
      out = this;
      out.values = feval(fcn, this.values);
      out.valueName = maybeSprintf('%s(%s)', ...
        func2str(fcn), this.valueName);
      validate(out);
    end
    
    function varargout = apply2(fcn, a, b, varargin)
      %APPLY2 Apply a two-arg function to input DataArrays
      %
      % varargout = apply2(fcn, a, b)
      % varargout = apply2(fcn, , ..., mode)
      % varargout = apply2(fcn, , ..., 'broadcast')
      % varargout = apply2(fcn, , ..., opts)
      %
      % This aligns the DataArray arguments, and then applies the given function
      % to their values.
      %
      % fcn (function handle) is the function to apply to a and b's values once
      % aligned. It must return one or more arrays of the same size as its
      % input.
      %
      % mode (char) may be 'union' or 'intersect'. It controls the mode used
      % when the align is done.
      %
      % If 'broadcast' is passed, it enables broadcasting. This expands the
      % input arrays along dimensions which are absent, but present in the other
      % argument. Presence is detected based on dimension name.
      %
      % opts (struct, jl.DataArray.AlignOptions) is an options argument that
      % controls various aspects of align's behavior. See its helptext for
      % details.
      %
      % See also:
      % jl.DataArray.AlignOptions
      [a,b] = promote(a, b);
      [a,b] = align(a, b, varargin{:});
      outvalues = cell(1, nargout);
      outvalues{:} = fcn(a.values, b.values);
      varargout = cell(size(outvalues));
      for i = 1:numel(outvalues)
        outvalues{i} = DataArray(outvalues{i}, a.coords, a.dims);
        outvalues{i}.valueName = maybeSprintf('%s(%s, %s)', ...
          func2str(fcn), a.valueName, b.valueName);
      end
    end
    
    % Arithmetic
    
    function out = plus(a, b, varargin)
      out = apply2(@plus, a, b, varargin{:});
      out.valueName = maybeSprintf('(%s + %s)', a.valueName, b.valueName);
    end
    
    function out = minus(a, b, varargin)
      out = apply2(@minus, a, b, varargin{:});
      out.valueName = maybeSprintf('(%s - %s)', a.valueName, b.valueName);
    end
    
    function out = times(a, b, varargin)
      out = apply2(@times, a, b, varargin{:});
      out.valueName = maybeSprintf('(%s .* %s)', a.valueName, b.valueName);
    end
    
    function out = ldivide(a, b, varargin)
      out = apply2(@ldivide, a, b, varargin{:});
      out.valueName = maybeSprintf('(%s .\ %s)', a.valueName, b.valueName);
    end
    
    function out = rdivide(a, b, varargin)
      out = apply2(@rdivide, a, b, varargin{:});
      out.valueName = maybeSprintf('(%s ./ %s)', a.valueName, b.valueName);
    end
    
    function out = mod(a, b, varargin)
      out = apply2(@mod, a, b, varargin{:});
      out.valueName = maybeSprintf('mod(%s, %s)', a.valueName, b.valueName);
    end
        
    function out = uminus(this)
      out = this;
      out.values = uminus(this.values);
      out.valueName = maybeSprintf('(-%s)', this.valueName);
    end
    
    function out = sum(this, varargin)
      args = varargin;
      includenan = true;
      dimvec = 1;
      while ~isempty(args)
        if isequal(args{end}, 'all')
        elseif isequal(args{end}, 'includenan')
          includenan = true;
        elseif isequal(args{end}, 'omitnan')
          includenan = false;
        elseif isnumeric(args{end})
          dimvec = args{end};
        else
          error('jl:InvalidInput', 'Unrecognized input argument: %s', ...
            dispstr(args{end}));
        end
        args(end) = [];
      end
      
      out = this;
      opArgs = {};
      if ~includenan
        opArgs{end+1} = 'omitnan';
      end
      out.values = sum(this.values, dimvec, opArgs{:});
      
      % TODO: Now, what should we use as the dimension name and coords for
      % the collapsed dimensions? I don't think we want to rearrange the
      % other dimensions. Or do we? Maybe we do; that seems like the only
      % way to preserve the semantics of DataArray and its dimensions?
      % For now, let's just stick in placeholder values.
      for iDim = 1:numel(dimvec)
        out.coords{dimvec(iDim)} = fillValFor(this.coords{dimvec(iDim)});
      end
      out.valueName = maybeSprintf('sum(%s)', this.valueName);
    end
    
    % Matrix math
    
    function out = mtimes(a, b, varargin)
      [a,b] = promote(a, b);
      if ~ismatrix(a) || ~ismatrix(b)
        error('inputs to mtimes must be matrixes');
      end
      % Check alignance of inner dimensions
      if size(a,2) ~= size(b,1)
        error('inputs differ in length of their inner dimensions');
      end
      if ~ismissing(a.dims(2)) && ~ismissing(b.dims(1)) ...
          && ~isequal(a.dims(2), b.dims(1))
        error(['dimension mismatch: inner dimensions must be the same, but ' ...
          'a dim 2 is "%s", and b dim 1 is "%s"'], a.dims(2), b.dims(1));
      end
      % TODO: Align inner dimensions, instead of just checking?
      if ~isequaln(a.coords{2}, b.coords{1})
        error('dimension mismatch: coords for a dimension 2 and b dimension 1 differ');
      end
      out = a;
      out.values = mtimes(a.values, b.values);
      out.coords{2} = b.coords{2};
      out.dims(2) = b.dims(2);
      out.valueName = maybeSprintf('(%s * %s)', a.valueName, b.valueName);
    end
    
    % Trigonometry
    
    function out = sin(this)
      out = this;
      out.values = sin(this.values);
      out.valueName = maybeSprintf('sin(%s)', this.valueName);
    end
    
    function out = sind(this)
      out = this;
      out.values = sind(this.values);
      out.valueName = maybeSprintf('sind(%s)', this.valueName);
    end
    
    function out = asin(this)
      out = this;
      out.values = asin(this.values);
      out.valueName = maybeSprintf('asin(%s)', this.valueName);
    end
    
    function out = asind(this)
      out = this;
      out.values = asind(this.values);
      out.valueName = maybeSprintf('asind(%s)', this.valueName);
    end
    
    function out = cos(this)
      out = this;
      out.values = cos(this.values);
      out.valueName = maybeSprintf('cos(%s)', this.valueName);
    end
    
    function out = acos(this)
      out = this;
      out.values = acos(this.values);
      out.valueName = maybeSprintf('acos(%s)', this.valueName);
    end
    
    function out = cosd(this)
      out = this;
      out.values = cosd(this.values);
      out.valueName = maybeSprintf('cosd(%s)', this.valueName);
    end
    
    function out = acosd(this)
      out = this;
      out.values = acosd(this.values);
      out.valueName = maybeSprintf('acosd(%s)', this.valueName);
    end
    
    function out = tan(this)
      out = this;
      out.values = tan(this.values);
      out.valueName = maybeSprintf('tan(%s)', this.valueName);
    end
    
    function out = atan(this)
      out = this;
      out.values = atan(this.values);
      out.valueName = maybeSprintf('atan(%s)', this.valueName);
    end
    
    function out = atan2(this)
      out = this;
      out.values = atan2(this.values);
      out.valueName = maybeSprintf('atan2(%s)', this.valueName);
    end
    
    % Other stuff
    
    function [a,b] = promote(a, b)
      %PROMOTE Promote inputs to be DataArrays
      %
      % [a,b] = promote(a, b)
      %
      % Promotes inputs to be DataArrays. Inputs which are not already
      % DataArrays are wrapped in DataArrays with the same dimensional
      % structure as the inputs which are DataArrays. This means that the
      % szie of the non-DataArray inputs must be the same size as the
      % DataArray inputs; no expansion or broadcasting is done/
      %
      % TODO: Maybe enable broadcasting/scalar expansion.
      %
      % Returns two DataArray objects. Errors if any input could not be
      % converted to a DataArray.
      if ~isa(b, 'DataArray')
        b = DataArray(b, a.coords, a.dims, a.valueName);
        validate(b);
      end
      if ~isa(a, 'DataArray')
        a = DataArray(a, b.coords, b.dims, b.valueName);
        validate(a);
      end
    end
    
    function [a2, b2] = align(a, b, varargin)
      %ALIGN Rearrange input DataArrays to have the same dimensions
      %
      % [a2, b2] = align(a, b)
      % [a2, b2] = align(..., 'union'|'intersect')
      % [a2, b2] = align(..., 'broadcast')
      % [a2, b2] = align(..., 'sort')
      % [a2, b2] = align(..., opts)
      %
      % Rearranges and expands or subsets the input arguments so that they
      % have the same dimensional structure or arrangement. The returned
      % DataArrays will have the same dims and coords, and their values
      % arrays will be the same size.
      %
      % If 'union' or 'intersect' is specified, it controls what happens
      % when the inputs do not have the same set of coords along a
      % dimension. If 'union', then both arrays are expanded so their
      % coords are the union of the input coords. If 'intersect', then they
      % are subsetted so their coords are the intersection of the input
      % coords.
      %
      % If 'sort' is specified, then the resulting coords are sorted.
      %
      % opts is a jl.xmarray.AlignOptions argument or a struct that can be
      % converted to one. It controls various aspects of align's behavior.
      %
      % Returns two DataArrays.
      %
      % See also:
      % jl.xmarray.AlignOptions
      mustBeA(a, 'DataArray');
      mustBeA(b, 'DataArray');
      args = varargin;
      
      opts = jl.DataArray.AlignOptions;
      while ischar(args{end}) || isstring(args{end}) || isstruct(args{end}) ...
          || isa(args{end}, 'jl.xmarray.AlignOptions')
        arg = args{end};
        args(end) = [];
        if ischar(arg) || isstring(arg)
          switch arg
            case ["union" "intersect"]
              opts.mode = arg;
            case "broadcast"
              opts.broadcast = true;
            case "sort"
              opts.sortCoords = true;
            otherwise
              error('jl:InvalidInput', 'Invalid string option: %s', arg);
          end
        else
          opts = jl.xmarray.AlignOptions(arg);
        end
      end
      
      if ~isempty(args)
        error('jl:InvalidInput', 'Too many arguments');
      end
      
      % Check input consistency
      
      if ndims(a) ~= ndims(b)
        error('jl:InvalidInput', 'Inconsistent dimensions: a has %d dims and b has %d dims', ...
          ndims(a), ndims(b));
      end
      for i = 1:ndims(a)
        if ~ismissing(a.dims(i)) && ~ismissing(b.dims(i)) ...
            && (a.dims(i) ~= b.dims(i))
          error('jl:InvalidInput', ['Inconsistent dimensions: dim %d ' ...
            'of a is named "%s", but dim %d of b is "%s"'], ...
            i, a.dims(i), i, b.dims(i));
        end
      end
      
      % Do the align
      
      switch mode
        case 'union'
          [a2,b2] = align1union(a, b, opts);
        case 'intersect'
          [a2,b2] = align1intersect(a, b, opts);
        otherwise
          error('jl:InvalidInput', 'Invalid mode argument: %s', mode);
      end
    end
    
    function out = subsetByIndex(this, ixs)
      %SUBSETBYINDEX Subset using indexes
      %
      % out = subsetByIndex(obj, ixs)
      %
      % Subsets and reorders obj by the supplied indexes.
      %
      % ixs is a cell vector containing the indexes to select along each
      % dimension. Note that these are regular array indexes, not coord
      % values.
      %
      % This is the function form of "out = obj(ixs{:})".
      %
      % Returns a dataarray.
      %
      % See also:
      % sel, isel, subsetByCoords, subsref
      out = this;
      out.values = this.values(ixs{:});
      for iDim = 1:numel(ixs)
        ix = ixs{iDim};
        if isequal(ix, ':') ...
            || (islogical(ix) && all(ix, 'all')) ...
            || (isnumeric(ix) && isequal(ix, 1:size(this, iDim)))
          continue
        end
        out.coords{iDim} = this.coords{iDim}(ix);
      end
    end
    
    function out = subsetByCoords(this, coordss)
      %SUBSETBYCOORDS Subset using coord values
      %
      % out = subsetByCoords(obj, coordss)
      %
      % Subsets obj by matching its coords values against supplied lists of
      % coords.
      %
      % coordss is a cell vector containing vectors of coord values to use
      % to subset obj by along each dimension.
      %
      % This is the function form of "out = obj{ixs{:}}".
      ixs = coords2subs(this, coordss);
      out = subsetByIndex(this, ixs);
    end
    
    function out = loc(this, coordss)
      %LOC Subset using coord values
      %
      % out = loc(obj, coordss)
      %
      % loc is an alias for subsetByCoords, provided for Python xarray
      % compatibility, or if you just want to do less typing.
      %
      % See also:
      % SUBSETBYCOORDS
      out = subsetByCoords(this, coordss);
    end
    
    function out = isel(this, ixs)
      %ISEL Indexing by dimension name and numeric/logical indexes
      %
      % out = isel(this, ixs)
      %
      % ix is a struct, cellvec, or name/value pair cell array, where the
      % names are dimension names, and the values are indexes to use along
      % those dimensions.
      ixsOut = repmat({':'}, [1 ndims(this)]);
      ixs = jl.datastruct.cellrec(ixs);
      for i = 1:size(ixs, 1)
        [dim,ix] = ixs{i,:};
        [tf,loc] = ismember(dim, this.dims);
        if ~tf
          name = inputname(1);
          if isempty(name)
            name = 'input';
          end
          error('No such dim in %s: %s', name, dim);
        end
        ixsOut{loc} = ix;
      end
      out = subsetByIndex(this, ixsOut);
    end
    
    function out = sel(this, ixs)
      %SEL Indexing by dimension name and coordinate values
      %
      % out = isel(this, ixs)
      %
      % ix is a struct, cellvec, or name/value pair cell array, where the
      % names are dimension names, and the values are coordinates to look
      % up along those dimensions.
      coordsOut = repmat({':'}, [1 ndims(this)]);
      ixs = jl.datastruct.cellrec(ixs);
      for i = 1:size(ixs, 1)
        [dim,ix] = ixs{i,:};
        [tf,loc] = ismember(dim, this.dims);
        if ~tf
          name = inputname(1);
          if isempty(name)
            name = 'input';
          end
          error('No such dim in %s: %s', name, dim);
        end
        coordsOut{loc} = ix;
      end
      out = subsetByCoords(this, coordsOut);
    end
    
    function out = coords2subs(this, coordss)
      %COORDS2SUBS Convert coordinates to array subscripts
      %
      % out = coords2subs(this, coordss)
      %
      % Converts coord-based indexes to numeric-based indexes.
      %
      % coordss is a cell vector of coord values.
      %
      % Returns a cell vector same size as coordss.
      mustBeA(coordss, 'cell');
      ixs = cell(size(coordss));
      for iDim = 1:numel(coordss)
        wantcoords = coordss{iDim};
        if isequal(wantcoords, ':')
          ixs{iDim} = true(1, size(this, iDim));
        else
          [tf,loc] = ismember(wantcoords, this.coords{iDim});
          if ~all(tf)
            error('coords not found along dimension %d: %s', ...
              iDim, jl.utils.ellipses(wantcoords(~tf)));
          end
          ixs{iDim} = loc;
        end
      end
      out = ixs;
    end
    
    function out = subsref(this, S)
      s = S(1);
      switch s.type
        case '()'
          out = subsetByIndex(this, s.subs);
        case '{}'
          out = subsetByCoords(this, s.subs);
        case '.'
          error('.-indexing is not supported by DataArray');
      end
      if numel(S) > 1
        out = subsref(out, S(2:end));
      end
    end
    
    function out = subsasgn(this, S, rhs)
      if numel(S) > 1
        % TODO: Add support
        error('Chained subsasgn indexing is not supported by DataArray');
      end
      s = S(1);
      out = this;
      switch s.type
        case '()'
          out.values(s.subs{:}) = rhs;
        case '{}'
          ixs = coords2subs(this, s.subs);
          out.values(ixs{:}) = rhs;
        case '.'
          error('.-indexing for assignment is not supported by DataArray');
      end
    end
    
    function out = numArgumentsFromSubscript(this, S, indexingContext) %#ok<INUSD>
      out = 1;
    end
    
    function out = unpivot(this)
      %UNPIVOT Unpivot an DataArray into a table
      %
      % out = unpivot(obj)
      %
      % Converts the DataArray obj into a table by unpivoting its dimensions.
      
      % TODO: DropMissing option
      % TODO: Expand to take multiple DataArrays as inputs, to be the inverse of
      % the multi-value-column pivot().
      
      sz = size(this);
      keyss = cell(1, ndims(this));
      keyCols = this.dims;
      % TODO: Fill in empty dims with default values
      for iDim = 1:ndims(this)
        sz2 = sz;
        sz2(iDim) = 1;
        sz2b = ones(1, ndims(this));
        sz2b(iDim) = sz(iDim);
        keys = repmat(reshape(this.coords{iDim}, sz2b), sz2);
        keyss{iDim} = keys(:);
      end
      outvalues = this.values(:);
      
      colvalues = [keyss outvalues];
      if ismissing(this.valueName)
        % TODO: Uniqueify this
        valueCol = 'Value';
      else
        valueCol = this.valueName;
      end
      colNames = [keyCols valueCol];
      out = table(colvalues{:}, 'VariableNames',colNames);
    end
    
  end
  
  methods (Static)
    
    function varargout = pivot(tbl, keyCols, valCols)
      %PIVOT Pivot a table into DataArray(s)
      %
      % varargout = pivot(tbl, keyCols, valCols)
      %
      % Pivots the given table
      %
      % tbl is a table, or something that works like one.
      %
      % keyCols (string) is a list of the columns/variables in tbl to treat as
      % keys. They are pivoted out into the dimensions of the output DataArrays.
      %
      % valCols (string) is a list of the value columns that will be pivoted
      % into the values of the output DataArrays. Each valCol will produce one
      % argout which contains the values from that corresponding input column.
      % Defaults to all columns in tbl which are not named in keyCols.
      %
      % Examples:
      % [s,p,sp] = jl.examples.table.SpDb;
      % xarr = DataArray.pivot(sp, {'SNum','PNum'})
      if nargin < 3; valCols = []; end
      keyCols = string(keyCols);
      cols = tbl.Properties.VariableNames;
      tf = ismember(keyCols, cols);
      if ~all(tf)
        error('Named variables not found in input table: %s', ...
          strjoin(keyCols(~tf), ', '));
      end
      if isempty(valCols)
        valCols = setdiff(cols, keyCols);
      end
      
      coords = cell(1, numel(keyCols));
      ixs = cell(1, numel(keyCols));
      for iKey = 1:numel(keyCols)
        keyvalues = tbl.(keyCols{iKey});
        [uKeys,~,Jndx] = unique(keyvalues);
        coords{iKey} = uKeys;
        ixs{iKey} = Jndx;
      end
      % Here's the magic
      sz = cellfun(@numel, coords);
      ix = sub2ind(sz, ixs{:});
      uIx = unique(ix);
      if numel(uIx) < numel(ix)
        error(['Value collision! Multiple rows in the input mapped ' ...
          'to the same element in the output']);
        % TODO: Better error message
      end
      
      varargout = cell(1, numel(valCols));
      template = DataArray;
      template.coords = coords;
      template.dims = keyCols;
      for iOut = 1:numel(valCols)
        xarr = template;
        valuesIn = tbl.(valCols(iOut));
        valuesOut = repmat(fillValFor(valuesIn), sz);
        valuesOut(ix) = valuesIn;
        xarr.values = valuesOut;
        xarr.valueName = valCols{iOut};
        varargout{iOut} = xarr;
      end
    end
    
  end
  
  methods (Access = private)
    
    function [a2,b2] = align1intersect(a, b, opts)
      mustBeA(opts, 'jl.xmarray.AlignOptions');
      for iDim = 1:ndims(a)
        if ismember(iDim, opts.excludeDims)
          continue
        end
        acoords = a.coords{iDim};
        bcoords = b.coords{iDim};
        [tf,loc] = ismember(acoords, bcoords);
        a2 = subsetAlongDim(a, iDim, tf);
        b2 = subsetAlongDim(b, iDim, loc(tf));
      end
    end
    
    function [a,b] = align1union(a, b, opts)
      [aIn,bIn] = deal(a, b); %#ok<ASGLU> This is just for debugging
      mustBeA(opts, 'jl.xmarray.AlignOptions');
      for iDim = 1:ndims(a)
        if ismember(iDim, opts.excludeDims)
          continue
        end
        acoords = a.coords{iDim};
        bcoords = b.coords{iDim};
        tf = ismember(acoords, bcoords);
        tf2 = ismember(bcoords, acoords);
        addcoordsA = bcoords(~tf2);
        addcoordsB = acoords(~tf);
        newcoordsA = [acoords addcoordsA];
        newcoordsB = [bcoords addcoordsB];
        newcoords = newcoordsA;
        if opts.sortcoords
          newcoords = sort(newcoords);
        end
        newLength = numel(newcoords);
        newvaluesA = expandvaluesAlong(a.values, iDim, newLength);
        newvaluesB = expandvaluesAlong(b.values, iDim, newLength);
        
        a.values = newvaluesA;
        a.coords{iDim} = newcoordsA;
        b.values = newvaluesB;
        b.coords{iDim} = newcoordsB;
        
        [~,loc] = ismember(newcoords, newcoordsA);
        a = subsetAlongDim(a, iDim, loc);
        [~,loc] = ismember(newcoords, newcoordsB);
        b = subsetAlongDim(b, iDim, loc);
      end
    end
    
    function out = subsetAlongDim(this, iDim, ix)
      out = this;
      ixs = repmat({':'}, [1 ndims(this)]);
      ixs{iDim} = ix;
      out.values = this.values(ixs{:});
      out.coords{iDim} = this.coords{iDim}(ix);
    end
  end
end

function out = fillValFor(x)
%FILLVALFOR Determine the fill value for a type

try
  out = feval(class(x), missing);
  return
catch err %#ok<NASGU>
  % Oh well. Not everything supports missing. Fall through and do it through
  % implicit expansion.
end

if isempty(x)
  x = feval(class(x)); % Hope this produces a valid scalar object
end
tmp = x(1);
tmp(3) = x(1);
out = tmp(2);
end

function out = expandvaluesAlong(values, ixDim, newLength)
fill = fillValFor(values);
out = values;
ixs = repmat({':'}, [1 ndims(values)]);
oldLength = size(values, ixDim);
ixs{ixDim} = oldLength+1:newLength;
out(ixs{:}) = fill;
end

function out = ellipsesOrMissing(x, n)
if nargin < 2 || isempty(n); n = 40; end

strs = string(dispstrs(x));
strs(ismissing(x)) = "<missing>";
strs = strs(:)';
if numel(strs) > n
  strs(n+1:end) = [];
  strs(end+1) = {'...'};
end
out = strjoin(strs, ', ');
end

function out = maybeSprintf(fmt, varargin)
args = varargin;
if any(cellfun(@(x) any(ismissing, 'any'), args))
  out = string(missing);
else
  out = sprintf(fmt, args{:});
end
end