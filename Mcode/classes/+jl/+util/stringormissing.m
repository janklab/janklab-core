function out = stringormissing(x)
if isempty(x) && isnumeric(x)
  out = string(missing);
elseif ischar(x) || isstring(x) || iscellstr(x)
  out = string(x);
elseif isa(x, 'java.lang.String')
  out = string(x);
elseif isa(x, 'java.lang.String[]')
  out = repmat(string(missing), size(x));
  for i = 1:numel(x)
    jstr = x(i);
    if isa(jstr, 'java.lang.String')
      out(i) = string(jstr);
    end
  end
elseif isa(x, 'java.util.Collection')
  UNIMPLEMENTED
else
  error('jl:InvalidInput', 'Invalid input');
end