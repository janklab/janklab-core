classdef symbol
    %SYMBOL Compact representation of low-cardinality strings
    
	properties
		sym int32 = int32(0)
	end
	
	methods
        
        function this = symbol(in)
        %SYMBOL Construct a symbol array.
        if nargin == 0
            return;
        end
        if isa(in, 'net.janklab.util.SymbolArrayList')
            this = symbol(in.getSymbols());
            return;
        end
        in = string(in);
        sz = size(in);
        this.sym = reshape(net.janklab.util.Symbol.encodeStrings(in(:)), sz);
        end
        
        function out = string(this)
        %STRING Convert to string array.
        sz = size(this);
        out = reshape(string(net.janklab.util.Symbol.decodeSymbols(this.sym(:))), sz);
        end
        
        function out = symbolvals(this)
        %SYMBOLVALS Numeric symbol values (for debugging).
        out = this.sym;
        end
        
        function disp(this)
        %DISP Custom display
        disp('@symbol:');
        disp(string(this));
        end
		
		function varargout = size(this, varargin)
		%SIZE Size of array.
		varargout = cell(1, max(1, nargout));
		[varargout{:}] = size(this.sym, varargin{:});
		end
		
		function out = numel(this)
		%NUMEL Number of elements in array.
		out = numel(this.sym);
		end
		
		function out = ndims(this)
		%NDIMS Number of dimensions.
		out = ndims(this.sym);
		end
		
		function out = isempty(this)
		%ISEMPTY True for empty array.
		out = isempty(this.sym);
		end
		
		function out = isscalar(this)
		%ISSCALAR True if input is scalar.
		out = isscalar(this.sym);
		end
		
		function out = isvector(this)
		%ISVECTOR True if input is a vector.
		out = isvector(this.sym);
		end
		
		function out = iscolumn(this)
		%ISCOLUMN True if input is a column vector.
		out = iscolumn(this.sym);
		end
		
		function out = isrow(this)
		%ISROW True if input is a row vector.
		out = isrow(this.sym);
		end
		
		function out = ismatrix(this)
		%ISMATRIX True if input is a matrix.
		out = ismatrix(this.sym);
		end
		
		function this = reshape(this, varargin)
		%RESHAPE Reshape array.
		this.sym = reshape(this.sym, varargin{:});
		end
		
		function this = squeeze(this)
		%SQUEEZE Remove singleton dimensions.
		this.sym = squeeze(this.sym);
		end
		
		function [this, nshifts] = shiftdim(this, n)
			%SHIFTDIM Shift dimensions.
			if nargin > 1
				this.sym = shiftdim(this.sym, n);
			else
				[this.sym, nshifts] = shiftdim(this.sym);
			end
        end
		
		function this = circshift(this, varargin)
		%CIRCSHIFT Shift positions of elements circularly.
		this.sym = circshift(this.sym, varargin{:});
		end
		
		function this = permute(this, order)
		%PERMUTE Permute array dimensions.
		this.sym = permute(this.sym, order);
		end
		
		function this = ipermute(this, order)
		%IPERMUTE Inverse permute array dimensions.
		this.sym = ipermute(this.sym, order);
		end
		
		function this = repmat(this, varargin)
		%REPMAT Replicate and tile array.
		this.sym = repmat(this.sym, varargin{:});
		end
		
		function this = cat(dim, this, b)
			%CAT Concatenate arrays.
			if ~isa(b, class(this))
				error('jl:type_mismatch', 'Cannot concatenate %s with a %s',...
					class(b), class(this));
			end
			
			this.sym = cat(dim, this.sym, b.sym);
		end
		
		function out = horzcat(this, b)
			%HORZCAT Horizontal concatenation.
			out = cat(2, this, b);
		end
		
		function out = vertcat(this, b)
			%VERTCAT Vertical concatenation.
			out = cat(1, this, b);
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
				if ~isa(rhs, class(this))
					error('jl:type_mismatch', 'Cannot assign %s in to a %s',...
						class(rhs), class(this));
				end
				if ~isequal(class(rhs), class(this))
					error('jl:type_mismatch', 'Cannot assign a subclass in to a %s (got a %s)',...
						class(this), class(rhs));
				end
				this.sym(s(1).subs{:}) = rhs.sym;
			case '{}'
				error('jl:bad_operation',...
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
				out = this;
				out.sym = this.sym(s(1).subs{:});
			case '{}'
				error('jl:bad_operation',...
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
	
end