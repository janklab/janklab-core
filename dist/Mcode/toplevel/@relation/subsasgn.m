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
		this(s(1).subs{:}) = rhs;
	case '{}'
		error('jl:BadOperation',...
			'{}-subscripting is not supported for class %s', class(this));
	case '.'
		this = this.setcol(s(1).subs, rhs);
end
end

