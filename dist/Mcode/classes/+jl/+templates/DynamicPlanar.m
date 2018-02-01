classdef DynamicPlanar
	%DYNAMICPLANAR Planar-organized object support, with dynamic implementation
	%
	% Implementation support for "planar-organized" objects. To create a
	% planar-organized class, you can inherit from DynamicPlanar and implement
	% the PLANARFIELDS method.
	%
	% The PLANARFIELDS method returns the list of the planar fields in a class.
	% They are listed in descending order of precedence, which is used for
	% comparisons to establish a total ordering of the values in a class.
	%
	% Because this is a dynamic implementation, there is a performance penalty for
	% using it: it introduces a few additional function calls inside each method.
	% This should be acceptable or negligible for classes which are used for
	% largish arrays. For classes that are used in tight loops over small arrays,
	% or pervasively, the performance hit may be significant.
	
	methods ( Abstract = true )
		%PLANARFIELDS List of the planar-organized fields of this class
		%
		% This should return the same thing for every invocation, and for every
		% instance of the class. It would make more sense as a class property,
		% but it's inconvenient to reference those, and getting it to work with
		% inheritance may be difficult.
		planarfields(this)
	end
	
	methods
		
		% Structure and shape methods
		
		function varargout = size(this, varargin)
			%SIZE Size of array
			varargout = cell(1, max(1, nargout));
			flds = this.planarfields;
			[varargout{:}] = size(this.(flds{1}), varargin{:});
		end
		
		function out = numel(this)
			%NUMEL Number of elements in array
			flds = this.planarfields;
			out = numel(this.(flds{1}));
		end
		
		function out = ndims(this)
			%NDIMS Number of dimensions
			flds = this.planarfields;
			out = ndims(this.(flds{1}));
		end
		
		function out = isempty(this)
			%ISEMPTY True for empty array
			flds = this.planarfields;
			out = isempty(this.(flds{1}));
		end
		
		function out = isscalar(this)
			%ISSCALAR True if input is scalar
			flds = this.planarfields;
			out = isscalar(this.(flds{1}));
		end
		
		function out = isvector(this)
			%ISVECTOR True if input is a vector
			flds = this.planarfields;
			out = isvector(this.(flds{1}));
		end
		
		function out = iscolumn(this)
			%ISCOLUMN True if input is a column vector
			flds = this.planarfields;
			out = iscolumn(this.(flds{1}));
		end
		
		function out = isrow(this)
			%ISROW True if input is a row vector
			flds = this.planarfields;
			out = isrow(this.(flds{1}));
		end
		
		function out = ismatrix(this)
			%ISMATRIX True if input is a matrix
			flds = this.planarfields;
			out = ismatrix(this.(flds{1}));
		end
		
		function this = reshape(this, varargin)
			%RESHAPE Reshape array
			flds = this.planarfields;
			for i = 1:numel(flds)
				this.(flds{i}) = reshape(this.(flds{i}), varargin{:});
			end
		end
		
		function this = squeeze(this)
			%SQUEEZE Remove singleton dimensions
			flds = this.planarfields;
			for i = 1:numel(flds)
				this.(flds{i}) = squeeze(this.(flds{i}));
			end
		end
		
		function [this, nshifts] = shiftdim(this, n)
			%SHIFTDIM Shift dimensions
			if nargin > 1
				flds = this.planarfields;
				for i = 1:numel(flds)
					this.(flds{i}) = shiftdim(this.(flds{i}), n);
				end
			else
				flds = this.planarfields;
				for i = 1:numel(flds)
					[this.(flds{i}), nshifts] = shiftdim(this.(flds{i}));
				end
			end
		end
		
		function this = transpose(this)
			%TRANSPOSE Non-conjugate transpose
			flds = this.planarfields;
			for i = 1:numel(flds)
				this.(flds{i}) = transpose(this.(flds{i}));
			end
		end
		
		function this = ctranspose(this)
			%CTRANSPOSE Complex conjugate transpose
			flds = this.planarfields;
			for i = 1:numel(flds)
				this.(flds{i}) = ctranspose(this.(flds{i}));
			end
		end
		
		function this = circshift(this, varargin)
			%CIRCSHIFT Shift positions of elements circularly
			flds = this.planarfields;
			for i = 1:numel(flds)
				this.(flds{i}) = circshift(this.(flds{i}), varargin{:});
			end
		end
		
		function this = permute(this, order)
			%PERMUTE Permute array dimensions
			flds = this.planarfields;
			for i = 1:numel(flds)
				this.(flds{i}) = permute(this.(flds{i}), order);
			end
		end
		
		function this = ipermute(this, order)
			%IPERMUTE Inverse permute array dimensions
			flds = this.planarfields;
			for i = 1:numel(flds)
				this.(flds{i}) = ipermute(this.(flds{i}), order);
			end
		end
		
		function this = repmat(this, varargin)
			%REPMAT Replicate and tile array
			flds = this.planarfields;
			for i = 1:numel(flds)
				this.(flds{i}) = repmat(this.(flds{i}), varargin{:});
			end
		end
		
		function this = cat(dim, this, b)
			%CAT Concatenate arrays
			if ~isa(b, class(this))
				error('jl:TypeMismatch', 'Cannot concatenate %s with a %s',...
					class(b), class(this));
			end
			
			flds = this.planarfields;
			for i = 1:numel(flds)
				this.(flds{i}) = cat(dim, this.(flds{i}), b.(flds{i}));
			end
		end
		
		function out = horzcat(this, b)
			%HORZCAT Horizontal concatenation
			out = cat(2, this, b);
		end
		
		function out = vertcat(this, b)
			%VERTCAT Vertical concatenation
			out = cat(1, this, b);
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
					if ~isequal(class(rhs), class(this))
						error('jl:TypeMismatch', 'Cannot assign a subclass in to a %s (got a %s)',...
							class(this), class(rhs));
					end
					flds = this.planarfields;
					for i = 1:numel(flds)
						this.(flds{i})(s(1).subs{:}) = rhs.(flds{i});
					end
				case '{}'
					error('jl:BadOperation',...
						'{}-subscripting is not supported for class %s', class(this));
				case '.'
					this.(s(1).subs) = rhs;
			end
		end
		
		function out = subsref(this, s)
			%SUBSREF Subscripted reference
			
			% Base case
			switch s(1).type
				case '()'
					out = this;
					flds = this.planarfields;
					for i = 1:numel(flds)
						out.(flds{i}) = this.(flds{i})(s(1).subs{:});
					end
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
		
		% Element identity methods
		
		function out = eq(this, b)
			%EQ Equal
			flds = this.planarfields;
			out = this.(flds{1}) == b.(flds{1});
			for i = 2:numel(flds)
				out = out & this.(flds{i}) == b.(flds{i});
			end
		end
		
		function out = ne(this, b)
			%NE Not equal
			out = ~eq(this, b);
		end
		
		function out = eqnan(this, b)
			%EQNAN Equal, considering NaNs to be equal
			flds = this.planarfields;
			out = eqnan(this.(flds{1}), b.(flds{1}));
			for i = 2:numel(flds)
				out = out & eqnan(this.(flds{i}), b.(flds{i}));
			end
		end
		
		function out = lt(this, b)
			%LT Less than
			cmp = valcmp(this, b);
			out = cmp == -1;
		end
		
		function out = gt(this, b)
			%GT Greater than
			cmp = valcmp(this, b);
			out = cmp == 1;
		end
		
		function out = le(this, b)
			%LE Less than or equal
			cmp = valcmp(this, b);
			out = cmp ~= 1;
		end
		
		function out = ge(this, b)
			%GE Greater than or equal
			cmp = valcmp(this, b);
			out = cmp ~= -1;
		end
		
		% Set operations
		
		% For set operations, we rely on the field content types also implementing
		% these functions. The use of IDENTITYPROXY is to handle the possibility of
		% incompatible, mixed field types. As an optimization, its use is skipped in
		% the single-field case.
		
		function out = union(a, b)
			%UNION Set union
			flds = this.planarfields;
			if isscalar(flds)
				out = this;
				out.(flds{1}) = union(a, b);
			else
				[tmpA, tmpB] = deal(cell(1, numel(flds)));
				
				for i = 1:numel(flds)
					[tmpA{i}, tmpB{i}] = identityProxy(a.(flds{i}), b.(flds{i}));
				end
				error('jl:TODO', 'Not implemented');
			end
		end
		
		function out = unique(a, option)
			%UNIQUE Set unique
			error('jl:TODO', 'Not implemented');
		end
		
		function out = intersect(a, b)
			%INTERSECT Set intersection
			error('jl:TODO', 'Not implemented');
		end
		
		function out = setdiff(a, b)
			%SETDIFF Set difference
			error('jl:TODO', 'Not implemented');
		end
		
		function out = setxor(a, b)
			%SETXOR Set exclusive-or
			error('jl:TODO', 'Not implemented');
		end
		
		function [out, ixA, ixC] = ismember(a, b)
			%ISMEMBER True for set member
			flds = this.planarfields;
			if isscalar(flds)
				[out, ixA, ixC] = ismember(a.(flds{1}), b.(flds{1}));
			else
				[proxyA, proxyB] = identityProxy(a, b);
				[out, ixA, ixC] = ismember(proxyA, proxyB);
			end
		end
		
		function [out, ix] = sort(this, dim, mode)
			%SORT Sort in ascending or descending order
			if nargin < 2; dim = [];         end
			if nargin < 3; mode = 'ascend';  end
			if isempty(dim)
				dim = ifthen(isrow(this), 2, 1);
			end
			if isvector(this)
				[out, ix] = sortVector(this, mode);
				return;
			end
			if ndims(this) > 2 || dim > 2  %#ok
				error('jl:BadArgument', 'dimensions higher than 2 are not supported');
			end
			out = this;
			if dim == 2
				out = out';
			end
			for iCol = 1:size(out, 2)
				out(:,iCol) = sortVector(out(:,iCol), mode);
			end
			if dim == 2
				out = out';
			end
		end
		
		% Janklab implementation stuff
		
		function [outA, outB] = identityProxy(a, b)
			%IDENTITYPROXY Proxy values for identity tests on a set of values
			%
			%
			flds = this.planarfields;
			[tmpA, tmpB] = deal(cell(1, numel(flds)));
			for i = 1:numel(flds)
				[tmpA{i}, tmpB{i}] = identityProxy(a.(flds{i}), b.(flds{i}));
				[tmpA{i}, tmpB{i}] = deal(tmpA{i}(:), tmpB{i}(:));
			end
			proxiesA = cat(2, tmpA{:});
			proxiesB = cat(2, tmpB{:});
			
			[~, ~, ixC] = unique([proxiesA; proxiesB], 'rows');
			outA = reshape(ixC(1:numel(a)), size(a));
			outB = reshape(ixC((numel(a)+1):end), size(b));
		end
		
	end
	
	methods (Access = private)
		function [out, ix] = sortVector(this, mode)
			%SORTVECTOR Sort a vector of this class
			if nargin < 2; mode = 'ascend'; end
			% Radix sort on the object's fields. Should be cheaper than using
			% identityProxy values, which itself does per-field sorts plus additional
			% work.
			flds = this.planarfields;
			ix = 1:numel(this);
			for i = numel(flds):-1:1
				[~,ixA] = sort(this.(flds{i}), mode);
				ix = ix(ixA);
			end
			out = this(ix);
		end
	end
	
end
