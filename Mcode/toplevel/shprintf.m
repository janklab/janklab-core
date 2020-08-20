function out = shprintf(fmt, varargin)
%SHPRINTF sprintf, but with variable interpolation
%
% out = shprintf(fmt, varargin)
%
% This is just like sprintf, except in fmt, you can also include macros in the
% form "${<varname>}" to substitute in the string representations of arbitrary
% Matlab values into the string. "<varname>" is the name of any variable in your
% workspace.
%
% Only variable names may be used, not arbitrary Matlab expressions. It is an
% error if <varname> is not a valid variable name.
%
% Examples:
%
% x = 42;
% dt = datetime;
% s = struct('foo',1, 'bar','whatever');
% hi = 'Hello, world!';
% z = 1:10;
% str = shprintf('x=${x}, dt=${dt}, s=${s}, hi=${hi} z=${z}')

isString = isstring(fmt);
fmt = char(fmt);

% Parse the format string
[ixStart, ixEnd, tok] = regexp(fmt, '\$\{(.*?)\}', 'start', 'end', 'tokens');
nMatch = numel(ixStart);
vars = cell(1, nMatch);
for i = 1:nMatch
  name = tok{i}{1};
  if ~isvarname(name)
    error('jl:InvalidInput', ['"%s" is not a valid Matlab variable name, and not ' ...
      'allowed in shprintf substitutions'], ...
      name);
  end
  vars{i} = name;
end

% Capture the variables

exprs = cell(1, nMatch);
for i = 1:nMatch
  exprs{i} = sprintf('''%s'', %s', vars{i}, vars{i});
end
expr = sprintf('struct(%s)', strjoin(exprs, ', '));
vals = evalin('caller', expr);

% Do the substitutions
fmt2 = fmt;
for i = nMatch:-1:1
  before = fmt2(1:(ixStart(i)-1));
  subst = char(dispstr(vals.(vars{i})));
  after = fmt2(min(ixEnd(i)+1,numel(fmt2)):end);
  fmt2 = [before subst after];
end

% And pass along to regular sprintf
out = sprintf(fmt2, varargin{:});

if isString
  out = string(out);
end

end