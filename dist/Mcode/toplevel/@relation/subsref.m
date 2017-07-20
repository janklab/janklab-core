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
				out = this.getcol(s(1).subs);
		end
		
		% Chained reference
		if numel(s) > 1
			out = subsref(out, s(2:end));
		end
	
end