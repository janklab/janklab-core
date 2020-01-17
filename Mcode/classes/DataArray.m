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
  % TODO: groupby()
  % TODO: Rename conform() to align() to be like Python xarray?
  % TODO: Label-based indexing where you name a dimension instead of
  %       passing it in to a positional parameter in {}-indexing. (sel()
  %       and isel())
  % TODO: Support dimensions without coordinates?
  % TODO: sortrows, N-D generalization of sortrows
  % TODO: Update valuesName based on function application
  % TODO: Aggregate arithmetic (prod, cumsum, cumprod, diff) with dim collapsing
  % TODO: Statistics (mean, median, std)
  % TODO: Matrix division (mldivide, mrdivide)
  % TODO: Matrix inverse (inv). I don't know what the resulting dimensions
  %       should be.
  % TODO: Multi-DataArray structure like xarray's Dataset
  % TODO: NetCDF and HDF5 I/O
  % TODO: DataUnits?
  % TODO: Plotting
  % TODO: Attributes?
  
  properties
    values = []
    coords cell = {}
    dims string = string.empty
    valueName (1,1) string = string(missing)
  end
  properties (Dependent = true)
    valueType
  end
  
  methods (Static)
    function out = empty()
      out = DataArray;
    end
  end
  
  methods
    
    function this = DataArray(values, coords, dims, valueName)
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
      out = this.values;
    end
    
    function validate(this)
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
      if numel(this) < 1000
        disp(this.values);
      end
    end
    
    function out = dispstrs(this)
      out = dispstrs(this.values);
    end
    
    function out = dispstr(this)
      %DISPSTR Custom display string for array
      
      % TODO: Add dim names
      out = sprintf('DataArray (%s): %s', ...
        this.valueType, size2str(size(this)));
    end
    
    function out = mat2str(this)
      out = sprintf('DataArray(%s, %s, %s)', ...
        mat2str(this.values), mat2str(this.coords), mat2str(this.dims));
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
      out = size(this.values, varargin{:});
    end
    
    function out = numel(this)
      out = numel(this.values);
    end
    
    function out = length(this)
      out = length(this.values);
    end
    
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
    
    function mustBeSameDimStructure(a, b)
      if ~isequaln(a.coords, b.coords)
        error(['a and b must have same dimension structure, but they ' ...
          'differ in their dimension coords']);
      end
      if ~isequaln(a.dims, b.dims)
        error(['a and b must have same dimension structure, but they ' ...
          'differ in their dimension names']);
      end
    end
    
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
      out = or(a.values, b.values);
    end
    
    function out = and(a, b)
      [a,b] = promote(a, b);
      mustBeSameDimStructure(a, b);
      out = and(a.values, b.values);
    end
    
    function out = xor(a, b)
      [a,b] = promote(a, b);
      mustBeSameDimStructure(a, b);
      out = xor(a.values, b.values);
    end
    
    function out = not(this)
      out = this;
      out.values = not(this.values);
    end
    
    function varargout = apply(fcn, a, b, varargin)
      %APPLY Apply a two-arg function to input DataArrays
      %
      % varargout = apply(fcn, a, b)
      % varargout = apply(fcn, , ..., mode)
      % varargout = apply(fcn, , ..., 'broadcast')
      % varargout = apply(fcn, , ..., opts)
      %
      % This conforms the DataArray arguments, and then applies the given function
      % to their values.
      %
      % fcn (function handle) is the function to apply to a and b's values once
      % conformed. It must return one or more arrays of the same size as its
      % input.
      %
      % mode (char) may be 'union' or 'intersect'. It controls the mode used
      % when the conform is done.
      %
      % If 'broadcast' is passed, it enables broadcasting. This expands the
      % input arrays along dimensions which are absent, but present in the other
      % argument. Presence is detected based on dimension name.
      %
      % opts (struct, jl.DataArray.ConformOptions) is an options argument that
      % controls various aspects of conform's behavior. See its helptext for
      % details.
      %
      % See also:
      % jl.DataArray.ConformOptions
      [a,b] = promote(a, b);
      [a,b] = conform(a, b, varargin{:});
      outvalues = cell(1, nargout);
      outvalues{:} = fcn(a.values, b.values);
      varargout = cell(size(outvalues));
      for i = 1:numel(outvalues)
        outvalues{i} = DataArray(outvalues{i}, a.coords, a.dims);
      end
    end
    
    function out = plus(a, b, varargin)
      out = apply(@plus, a, b, varargin{:});
    end
    
    function out = minus(a, b, varargin)
      out = apply(@minus, a, b, varargin{:});
    end
    
    function out = times(a, b, varargin)
      out = apply(@times, a, b, varargin{:});
    end
    
    function out = ldivide(a, b, varargin)
      out = apply(@ldivide, a, b, varargin{:});
    end
    
    function out = rdivide(a, b, varargin)
      out = apply(@rdivide, a, b, varargin{:});
    end
    
    function out = mod(a, b, varargin)
      out = apply(@mod, a, b, varargin{:});
    end
    
    function out = mtimes(a, b, varargin)
      [a,b] = promote(a, b);
      if ~ismatrix(a) || ~ismatrix(b)
        error('inputs to mtimes must be matrixes');
      end
      % Check conformance of inner dimensions
      if size(a,2) ~= size(b,1)
        error('inputs differ in length of their inner dimensions');
      end
      if ~ismissing(a.dims(2)) && ~ismissing(b.dims(1)) ...
          && ~isequal(a.dims(2), b.dims(1))
        error(['dimension mismatch: inner dimensions must be the same, but ' ...
          'a dim 2 is "%s", and b dim 1 is "%s"'], a.dims(2), b.dims(1));
      end
      % TODO: Conform inner dimensions, instead of just checking?
      if ~isequaln(a.coords{2}, b.coords{1})
        error('dimension mismatch: coords for a dimension 2 and b dimension 1 differ');
      end
      out = a;
      out.values = mtimes(a.values, b.values);
      out.coords{2} = b.coords{2};
      out.dims(2) = b.dims(2);
    end
    
    function out = uminus(this)
      out = this;
      out.values = uminus(this.values);
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
    end
    
    function out = sortdims(this)
      %SORTDIMS Sort this based on its dimension coords
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
        [tmp,b] = conform(tmp, args{i}, {'excludeDims',dim});
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
    
    function [a,b] = promote(a, b)
      if ~isa(b, 'DataArray')
        b = DataArray(b, a.coords, a.dims, a.valueName);
        validate(b);
      end
      if ~isa(a, 'DataArray')
        a = DataArray(a, b.coords, b.dims, b.valueName);
        validate(a);
      end
    end
    
    function [a2, b2] = conform(a, b, varargin)
      %CONFORM Rearrange input DataArrays to have the same dimensions
      mustBeA(a, 'DataArray');
      mustBeA(b, 'DataArray');
      args = varargin;
      
      opts = jl.DataArray.ConformOptions;
      while ischar(args{end}) || isstring(args{end}) || isstruct(args{end}) ...
          || isa(args{end}, 'jl.xmarray.ConformOptions')
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
          opts = jl.xmarray.ConformOptions(arg);
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
      
      % Do the conform
      
      switch mode
        case 'union'
          [a2,b2] = conform1union(a, b, opts);
        case 'intersect'
          [a2,b2] = conform1intersect(a, b, opts);
        otherwise
          error('jl:InvalidInput', 'Invalid mode argument: %s', mode);
      end
    end
    
    function out = subsetByIndex(this, ixs)
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
      ixs = coords2subs(this, coordss);
      out = subsetByIndex(this, ixs);
    end
    
    function out = loc(this, coordss)
      out = subsetByCoords(this, coordss);
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
    
    function [a2,b2] = conform1intersect(a, b, opts)
      mustBeA(opts, 'jl.xmarray.ConformOptions');
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
    
    function [a,b] = conform1union(a, b, opts)
      [aIn,bIn] = deal(a, b); %#ok<ASGLU> This is just for debugging
      mustBeA(opts, 'jl.xmarray.ConformOptions');
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