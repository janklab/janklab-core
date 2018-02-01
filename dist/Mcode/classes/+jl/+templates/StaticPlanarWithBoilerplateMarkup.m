classdef StaticPlanar
	%STATICPLANAR A statically-defined planar-organized value class
	%
	% This class cannot be used directly. It
	% is used as a basis for generating boilerplate code for other
	% planar-organized value classes.
	
	properties
		%@@ planar_properties
		xxx = 0
		%@@ end
	end
	
	%@@ begin_boilerplate
	methods
		
		function varargout = size(this, varargin)
		%SIZE Size of array
		
		varargout = cell(1, max(1, nargout));
		%@@ one_planar
		[varargout{:}] = size(this.xxx, varargin{:});
		%@@ end
		end
		
		function out = numel(this)
		%NUMEL Number of elements in array
		
		%@@ one_planar
		out = numel(this.xxx);
		%@@ end
		end
		
		function out = ndims(this)
		%NDIMS Number of dimensions
		
		%@@ one_planar
		out = ndims(this.xxx);
		%@@ end
		end
		
		function out = isempty(this)
		%ISEMPTY True for empty array
		
		%@@ one_planar
		out = isempty(this.xxx);
		%@@ end
		end
		
		function out = isscalar(this)
		%ISSCALAR True if input is scalar
		
		%@@ one_planar
		out = isscalar(this.xxx);
		%@@ end
		end
		
		function out = isvector(this)
		%ISVECTOR True if input is a vector
		
		%@@ one_planar
		out = isvector(this.xxx);
		%@@ end
		end
		
		function out = iscolumn(this)
		%ISCOLUMN True if input is a column vector
		
		%@@ one_planar
		out = iscolumn(this.xxx);
		%@@ end
		end
		
		function out = isrow(this)
		%ISROW True if input is a row vector
		
		%@@ one_planar
		out = isrow(this.xxx);
		%@@ end
		end
		
		function out = ismatrix(this)
		%ISMATRIX True if input is a matrix
		
		%@@ one_planar
		out = ismatrix(this.xxx);
		%@@ end
		end
		
		function this = reshape(this, varargin)
		%RESHAPE Reshape array
		
		%@@ parallel_planar
		this.xxx = reshape(this.xxx, varargin{:});
		%@@ end
		end
		
		function this = squeeze(this)
		%SQUEEZE Remove singleton dimensions
		
		%@@ parallel_planar
		this.xxx = squeeze(this.xxx);
		%@@ end
		end
		
		function [this, nshifts] = shiftdim(this, n)
			%SHIFTDIM Shift dimensions
			
			if nargin > 1
				%@@ parallel_planar
				this.xxx = shiftdim(this.xxx, n);
				%@@ end
			else
				%@@ parallel_planar
				[this.xxx, nshifts] = shiftdim(this.xxx);
				%@@ end
			end
		end

		function this = circshift(this, varargin)
		%CIRCSHIFT Shift positions of elements circularly
		
		%@@ parallel_planar
		this.xxx = circshift(this.xxx, varargin{:});
		%@@ end
		end
		
		function this = permute(this, order)
		%PERMUTE Permute array dimensions
		
		%@@ parallel_planar
		this.xxx = permute(this.xxx, order);
		%@@ end
		end
		
		function this = ipermute(this, order)
		%IPERMUTE Inverse permute array dimensions
		
		%@@ parallel_planar
		this.xxx = ipermute(this.xxx, order);
		%@@ end
		end
		
		function this = repmat(this, varargin)
		%REPMAT Replicate and tile array
		
		%@@ parallel_planar
		this.xxx = repmat(this.xxx, varargin{:});
		%@@ end
		end
		
		function this = cat(dim, this, b)
			%CAT Concatenate arrays
			
			if ~isa(b, class(this))
				error('jl:TypeMismatch', 'Cannot concatenate %s with a %s',...
					class(b), class(this));
			end
			
			%@@ parallel_planar
			this.xxx = cat(dim, this.xxx, b.xxx);
			%@@ end
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
				%@@ parallel_planar
				this.xxx(s(1).subs{:}) = rhs.xxx;
				%@@ end
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
				%@@ parallel_planar
				out.xxx = this.xxx(s(1).subs{:});
				%@@ end
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
		
		
	end
	
	%@@ end_boilerplate
	
end