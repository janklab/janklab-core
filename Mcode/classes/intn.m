classdef (Abstract) intn < jl.util.Displayable
	%INTN A NaN-able integer array
	%
	% An INTN is an integer array that supports NaN values.
	%
	% INTN is the abstract base type for all the various [u]int*n
	% classes. Each size of integer has its own concrete subclass.
	% The subtypes are all named after their corresponding regular integer
	% array type, with the letter "n" appended to them. This is analagous
	% to how "isequaln" is "isequal" with an "n" for "NaN" appended to it.
	%
	% To use INTN, create an array using one of its numeric-type-specific
	% subclasses, and then work with that.
	%
	% This is still a work in progress. Many of the arithmetic operations are
	% not implemented yet, including MIN, MAX, MEAN, CUMSUM, CUMPROD,
	% and DIFF. But SUM and PROD are working, along with + - ./ .* == ~=
	% and set operations like UNIQUE, ISMEMBER, and SORT.
	%
	% Examples:
	%
	% x = int32n([1 2 NaN 4])
	% isnan(x)
	% y = x .* 3
	% unique([x x x])
	% 
	% See also:
	% INT8N, UINT8N, INT16N, UINT16N, INT32N, UINT32N, INT64N, UINT64N

	% TODO: Max, min, mean, median, diff
	% TODO: cumprod, cumsum
	
	% @planarprecedence(tfnan,ints)
	
	properties
		ints  % @planar
		tfnan % @planar @planarnanflag
	end
	
	methods
		function this = intn(ints, tfnan)
			if ~isinteger(ints)
				error('ints must be of integer type');
			end
			if nargin < 2 || isempty(tfnan)
				tfnan = false(size(ints));
			end
			mustBeA(tfnan, 'logical');
			this.ints = ints;
			this.tfnan = tfnan;
		end
		
		function [varargout] = promote(varargin)
			%PROMOTE Convert inputs to be intns of the same subtype
			args = varargin;
			targetType = [];
			for i = 1:numel(args)
				if isa(args{i}, 'intn')
					targetType = class(args{i});
					break
				end
			end
			if isempty(targetType)
				error('jl:Bug', 'BUG: Could not determine target type for promotion');
			end
			for i = 1:numel(args)
				if ~isa(args{i}, 'intn')
					args{i} = feval(targetType, args{i});
				end
			end
			varargout = args;
		end
		
		function disp(this)
			dispMaybeMatrix(this);
		end
		
		% Relational operations
		
		function out = isequal(a, b)
			[a,b] = promote(a, b);
			if any(a.tfnan(:)) || any(b.tfnan(:))
				out = false;
			else
				out = isequal(a.ints, b.ints);
			end
		end
		
		function out = isequaln(a, b)
			if ~isequal(size(a), size(b))
				out = false;
				return
			end
			tf = a.ints == b.ints;
			tf(a.tfnan & b.tfnan) = true;
			tf(xor(a.tfnan, b.tfnan)) = false;
			out = all(tf(:));
		end
		
		function out = gt(a, b)
			[a,b] = promote(a, b);
			out = gt(a.ints, b.ints);
			out(a.tfnan | b.tfnan) = false;
		end
		
		function out = ge(a, b)
			[a,b] = promote(a, b);
			out = ge(a.ints, b.ints);
			out(a.tfnan | b.tfnan) = false;
		end
		
		function out = lt(a, b)
			[a,b] = promote(a, b);
			out = lt(a.ints, b.ints);
			out(a.tfnan | b.tfnan) = false;
		end
		
		function out = le(a, b)
			[a,b] = promote(a, b);
			out = le(a.ints, b.ints);
			out(a.tfnan | b.tfnan) = false;
		end
		
		function out = eq(a, b)
			[a,b] = promote(a, b);
			out = eq(a.ints, b.ints);
			out(a.tfnan | b.tfnan) = false;
		end
		
		function out = ne(a, b)
			[a,b] = promote(a, b);
			% Special case!
			out = ne(a.ints, b.ints) | a.tfnan | b.tfnan;
		end
		
		% Arithmetic
		%
		% We can do simple arithmetic here, because Matlab already enforces that
		% integer operands be of the same type.
		%
		% TODO: Automatic widening of mixed types?
		
		function out = plus(a, b)
			[a,b] = promote(a, b);
			out = a;
			out.ints = plus(a.ints, b.ints);
			out.tfnan = a.tfnan | b.tfnan;
		end
		
		function out = minus(a, b)
			[a,b] = promote(a, b);
			out = a;
			out.ints = minus(a.ints, b.ints);
			out.tfnan = a.tfnan | b.tfnan;
		end
		
		function out = uminus(a)
			out = a;
			out.ints = uminus(out.ints);
		end
		
		function out = times(a, b)
			[a,b] = promote(a, b);
			out = a;
			out.ints = times(a.ints, b.ints);
			out.tfnan = a.tfnan | b.tfnan;
		end
		
		function out = mtimes(a, b)
			[a,b] = promote(a, b);
			error('%s is unimplemented because I have not figured out how to propagate NaNs', mfilename);
		end
		
		function out = mldivide(a, b)
			[a,b] = promote(a, b);
			error('%s is unimplemented because I have not figured out how to propagate NaNs', mfilename);
		end
		
		function out = mrdivide(a, b)
			[a,b] = promote(a, b);
			error('%s is unimplemented because I have not figured out how to propagate NaNs', mfilename);
		end
		
		function out = ldivide(a, b)
			[a,b] = promote(a, b);
			out = a;
			out.ints = ldivide(a.ints, b.ints);
			out.tfnan = a.tfnan | b.tfnan;
		end
		
		function out = rdivide(a, b)
			[a,b] = promote(a, b);
			out = a;
			out.ints = rdivide(a.ints, b.ints);
			out.tfnan = a.tfnan | b.tfnan;
		end
		
		function out = sum(this, arg)
			if nargin < 2 || isempty(arg); arg = 1; end
			out = this;
			out.ints = sum(this.ints, arg);
			out.tfnan = any(this.tfnan, arg);
		end
		
		function out = prod(this, arg)
			if nargin < 2 || isempty(arg); arg = 1; end
			out = this;
			out.ints = prod(this.ints, arg);
			out.tfnan = any(this.tfnan, arg);
		end
		
	end
	
	methods (Access = protected)
		function out = dispstr_scalar(this)
			if this.tfnan
				out = 'NaN';
			else
				out = num2str(this.ints);
			end
		end
	end
	
	%%%%% START PLANAR-CLASS BOILERPLATE CODE %%%%%
	
	% This section contains code auto-generated by Janklab's genPlanarClass.
	% Do not edit code in this section manually.
	% Do not remove the "%%%%% START/END .... %%%%%" header or footer either;
	% that will cause the code regeneration to break.
	% To update this code, re-run jl.code.genPlanarClass() on this file.
	
	methods
		
		function out = numel(this)
			%NUMEL Number of elements in array.
			out = numel(this.ints);
		end
		
		function out = ndims(this)
			%NDIMS Number of dimensions.
			out = ndims(this.ints);
		end
		
		function out = size(this)
			%SIZE Size of array.
			out = size(this.ints);
		end
		
		function out = isempty(this)
			%ISEMPTY True for empty array.
			out = isempty(this.ints);
		end
		
		function out = isscalar(this)
			%ISSCALAR True if input is scalar.
			out = isscalar(this.ints);
		end
		
		function out = isvector(this)
			%ISVECTOR True if input is a vector.
			out = isvector(this.ints);
		end
		
		function out = iscolumn(this)
			%ISCOLUMN True if input is a column vector.
			out = iscolumn(this.ints);
		end
		
		function out = isrow(this)
			%ISROW True if input is a row vector.
			out = isrow(this.ints);
		end
		
		function out = ismatrix(this)
			%ISMATRIX True if input is a matrix.
			out = ismatrix(this.ints);
		end
		
		function out = isnan(this)
			%ISNAN True for Not-a-Number.
			out = this.tfnan;
		end
		
		function this = reshape(this, varargin)
			%RESHAPE Reshape array.
			this.ints = reshape(this.ints, varargin{:});
			this.tfnan = reshape(this.tfnan, varargin{:});
		end
		
		function this = squeeze(this, varargin)
			%SQUEEZE Remove singleton dimensions.
			this.ints = squeeze(this.ints, varargin{:});
			this.tfnan = squeeze(this.tfnan, varargin{:});
		end
		
		function this = circshift(this, varargin)
			%CIRCSHIFT Shift positions of elements circularly.
			this.ints = circshift(this.ints, varargin{:});
			this.tfnan = circshift(this.tfnan, varargin{:});
		end
		
		function this = permute(this, varargin)
			%PERMUTE Permute array dimensions.
			this.ints = permute(this.ints, varargin{:});
			this.tfnan = permute(this.tfnan, varargin{:});
		end
		
		function this = ipermute(this, varargin)
			%IPERMUTE Inverse permute array dimensions.
			this.ints = ipermute(this.ints, varargin{:});
			this.tfnan = ipermute(this.tfnan, varargin{:});
		end
		
		function this = repmat(this, varargin)
			%REPMAT Replicate and tile array.
			this.ints = repmat(this.ints, varargin{:});
			this.tfnan = repmat(this.tfnan, varargin{:});
		end
		
		function this = ctranspose(this, varargin)
			%CTRANSPOSE Complex conjugate transpose.
			this.ints = ctranspose(this.ints, varargin{:});
			this.tfnan = ctranspose(this.tfnan, varargin{:});
		end
		
		function this = transpose(this, varargin)
			%TRANSPOSE Transpose vector or matrix.
			this.ints = transpose(this.ints, varargin{:});
			this.tfnan = transpose(this.tfnan, varargin{:});
		end
		
		function [this, nshifts] = shiftdim(this, n)
			%SHIFTDIM Shift dimensions.
			if nargin > 1
				this.ints = shiftdim(this.ints, n);
				this.tfnan = shiftdim(this.tfnan, n);
			else
				this.ints = shiftdim(this.ints);
				[this.tfnan,nshifts] = shiftdim(this.tfnan);
			end
		end
		
		function out = cat(dim, varargin)
			%CAT Concatenate arrays.
			args = cell(size(varargin));
			[args{:}] = promote(varargin{:});
			out = args{1};
			fieldArgs = cellfun(@(obj) obj.ints, args, 'UniformOutput', false);
			out.ints = cat(dim, fieldArgs{:});
			fieldArgs = cellfun(@(obj) obj.tfnan, args, 'UniformOutput', false);
			out.tfnan = cat(dim, fieldArgs{:});
		end
		
		function out = horzcat(varargin)
			%HORZCAT Horizontal concatenation.
			out = cat(2, varargin{:});
		end
		
		function out = vertcat(varargin)
			%VERTCAT Vertical concatenation.
			out = cat(1, varargin{:});
		end
		
		function this = subsasgn(this, s, b)
			%SUBSASGN Subscripted assignment.
			
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
					this = subsasgnParensPlanar(this, s(1), rhs);
				case '{}'
					error('jl:BadOperation',...
						'{}-subscripting is not supported for class %s', class(this));
				case '.'
					this.(s(1).subs) = rhs;
			end
		end
		
		function out = subsref(this, s)
			%SUBSREF Subscripted reference.
			
			% Base case
			switch s(1).type
				case '()'
					out = subsrefParensPlanar(this, s(1));
				case '{}'
					error('jl:BadOperation',...
						'{}-subscripting is not supported for class %s', class(this));
				case '.'
					out = this.(s(1).subs);
			end
			
			% Chained reference
			if numel(s) > 1
				out = subsref(out, s(2:end));
			end
		end
		
		function n = numArgumentsFromSubscript(this,~,indexingContext) %#ok<INUSL>
			switch indexingContext
				case matlab.mixin.util.IndexingContext.Statement
					n = 1; % nargout for indexed reference used as statement
				case matlab.mixin.util.IndexingContext.Expression
					n = 1; % nargout for indexed reference used as function argument
				case matlab.mixin.util.IndexingContext.Assignment
					n = 1; % nargin for indexed assignment
			end
		end
		
		function [out,Indx] = sort(this)
			%SORT Sort array elements.
			if isvector(this)
				isRow = isrow(this);
				this = subset(this, ':');
				% NaNs sort stably to end, so handle them separately
				tfNan = isnan(this);
				nans = subset(this, tfNan);
				nonnans = subset(this, ~tfNan);
				ixNonNan = find(~tfNan);
				proxy = proxyKeys(nonnans);
				[~,ix] = sortrows(proxy);
				out = [subset(nonnans, ix); nans];
				Indx = [ixNonNan(ix); find(tfNan)];
				if isRow
					out = out';
				end
			elseif ismatrix(this)
				out = this;
				Indx = NaN(size(out));
				for iCol = 1:size(this, 2)
					[sortedCol,Indx(:,iCol)] = sort(subset(this, ':', iCol));
					out = asgn(out, {':', iCol}, sortedCol);
				end
			else
				% I believe this multi-dimensional implementation is correct,
				% but have not tested it yet. Use with caution.
				out = this;
				Indx = NaN(size(out));
				sz = size(this);
				nDims = ndims(this);
				ixs = [{':'} repmat({1}, [1 nDims-1])];
				while true
					col = subset(this, ixs{:});
					[sortedCol,sortIx] = sort(col);
					Indx(ixs{:}) = sortIx;
					out = asgn(out, ixs, sortedCol);
					ixs{end} = ixs{end}+1;
					for iDim=nDims:-1:3
						if ixs{iDim} > sz(iDim)
							ixs{iDim-1} = ixs{iDim-1} + 1;
							ixs{iDim} = 1;
						end
					end
					if ixs{2} > sz(2)
						break;
					end
				end
			end
		end
		
		function [out,Indx] = unique(this, varargin)
			%UNIQUE Set unique.
			flags = setdiff(varargin, {'rows'});
			if ismember('rows', varargin)
				[~,proxyIx] = unique(this);
				proxyIx = reshape(proxyIx, size(this));
				[~,Indx] = unique(proxyIx, 'rows', flags{:});
				out = subset(this, Indx, ':');
			else
				isRow = isrow(this);
				this = subset(this, ':');
				tfNaN = isnan(this);
				nans = subset(this, tfNaN);
				nonnans = subset(this, ~tfNaN);
				ixNonnan = find(~tfNaN);
				keys = proxyKeys(nonnans);
				if isa(keys, 'table')
					[~,ix] = unique(keys, flags{:});
				else
					[~,ix] = unique(keys, 'rows', flags{:});
				end
				out = [subset(nonnans, ix); nans];
				Indx = [ixNonnan(ix); find(tfNaN)];
				if isRow
					out = out';
				end
			end
		end
		
		function [out,Indx] = ismember(a, b, varargin)
			%ISMEMBER True for set member.
			if ismember('rows', varargin)
				error('ismember(..., ''rows'') is unsupported');
			end
			[a,b] = promote(a, b);
			[proxyA, proxyB] = proxyKeys(a, b);
			[out,Indx] = ismember(proxyA, proxyB, 'rows');
			out = reshape(out, size(a));
			Indx = reshape(Indx, size(a));
		end
		
		function [out,Indx] = setdiff(a, b, varargin)
			%SETDIFF Set difference.
			if ismember('rows', varargin)
				error('setdiff(..., ''rows'') is unsupported');
			end
			[tf,~] = ismember(a, b);
			out = parensRef(a, ~tf);
			Indx = find(~tf);
			[out,ix] = unique(out);
			Indx = Indx(ix);
		end
		
		function [out,ia,ib] = intersect(a, b, varargin)
			%INTERSECT Set intersection.
			if ismember('rows', varargin)
				error('intersect(..., ''rows'') is unsupported');
			end
			[proxyA, proxyB] = proxyKeys(a, b);
			[~,ia,ib] = intersect(proxyA, proxyB, 'rows');
			out = parensRef(a, ia);
		end
		
		function [out,ia,ib] = union(a, b, varargin)
			%UNION Set union.
			if ismember('rows', varargin)
				error('union(..., ''rows'') is unsupported');
			end
			[proxyA, proxyB] = proxyKeys(a, b);
			[~,ia,ib] = union(proxyA, proxyB, 'rows');
			aOut = parensRef(a, ia);
			bOut = parensRef(b, ib);
			out = [parensRef(aOut, ':'); parensRef(bOut, ':')];
		end
		
		function [keysA,keysB] = proxyKeys(a, b)
			%PROXYKEYS Proxy key values for sorting and set operations
			propertyValsA = {a.ints a.tfnan};
			propertyTypesA = cellfun(@class, propertyValsA, 'UniformOutput',false);
			isAllNumericA = all(cellfun(@isnumeric, propertyValsA));
			propertyValsA = cellfun(@(x) x(:), propertyValsA, 'UniformOutput',false);
			if nargin == 1
				if isAllNumericA && isscalar(unique(propertyTypesA))
					% Properties are homogeneous numeric types; we can use them directly
					keysA = cat(2, propertyValsA{:});
				else
					% Properties are heterogeneous or non-numeric; resort to using a table
					propertyNames = {'ints' 'tfnan'};
					keysA = table(propertyValsA{:}, 'VariableNames', propertyNames);
				end
			else
				propertyValsB = {b.ints b.tfnan};
				propertyTypesB = cellfun(@class, propertyValsB, 'UniformOutput',false);
				isAllNumericB = all(cellfun(@isnumeric, propertyValsB));
				propertyValsB = cellfun(@(x) x(:), propertyValsB, 'UniformOutput',false);
				if isAllNumericA && isAllNumericB && isscalar(unique(propertyTypesA)) ...
						&& isscalar(unique(propertyTypesB))
					% Properties are homogeneous numeric types; we can use them directly
					keysA = cat(2, propertyValsA{:});
					keysB = cat(2, propertyValsB{:});
				else
					% Properties are heterogeneous or non-numeric; resort to using a table
					propertyNames = {'ints' 'tfnan'};
					keysA = table(propertyValsA{:}, 'VariableNames', propertyNames);
					keysB = table(propertyValsB{:}, 'VariableNames', propertyNames);
				end
			end
		end
		
	end
	
	methods (Access=private)
		
		function this = subsasgnParensPlanar(this, s, rhs)
			%SUBSASGNPARENSPLANAR ()-assignment for planar object
			if ~isa(rhs, 'intn')
				rhs = feval(class(this), rhs);
			end
			this.ints(s.subs{:}) = rhs.ints;
			this.tfnan(s.subs{:}) = rhs.tfnan;
		end
		
		function out = subsrefParensPlanar(this, s)
			%SUBSREFPARENSPLANAR ()-indexing for planar object
			out = this;
			out.ints = this.ints(s.subs{:});
			out.tfnan = this.tfnan(s.subs{:});
		end
		
		function out = parensRef(this, varargin)
			%PARENSREF ()-indexing, for this class's internal use
			out = subsrefParensPlanar(this, struct('subs', {varargin}));
		end
		
		function out = subset(this, varargin)
			%SUBSET Subset array by indexes.
			% This is what you call internally inside the class instead of doing
			% ()-indexing references on the RHS, which don't work properly inside the class
			% because they don't respect the subsref() override.
			out = parensRef(this, varargin{:});
		end
		
		function out = asgn(this, ix, value)
			%ASGN Assign array elements by indexes.
			% This is what you call internally inside the class instead of doing
			% ()-indexing references on the LHS, which don't work properly inside
			% the class because they don't respect the subsasgn() override.
			if ~iscell(ix)
				ix = { ix };
			end
			s.type = '()';
			s.subs = ix;
			out = subsasgnParensPlanar(this, s, value);
		end
		
	end
	
	%%%%% END PLANAR-CLASS BOILERPLATE CODE %%%%%
	
end


