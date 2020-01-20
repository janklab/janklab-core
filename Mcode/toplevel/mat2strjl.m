function out = mat2strjl(x)
%MAT2STRJL An extension of mat2str that works on more types
%
% out = mat2strjl(x)
%
% MAT2STRJL is just like mat2str, except it works on more types, including
% cells, structs, datetimes, and categoricals.
%
% WARNING: The datetime conversion here is lossy! The datetime values are
% rounded or truncated to the nearest nanosecond, but datetime's internal
% representation is higher precision than that. Datetime values reconstructed
% from the strings that mat2strjl produces may not compare equal to the original
% values.
%
% Does not support values that are handles, because they can't be correctly
% reconstructed from a serialized representation.
%
% Returns a charvec.
%
% Examples:
%
% % It supports cells!
% c = { 42, [1 2 3]; "foo", 'bar' };
% mat2strjl(c)
%
% % And structs!
% s = struct('x',magic(3), 'a_cell', { 1 2 "foo" categorical({'x' 'y' 'z'}) });
% mat2strjl(s)
%
% % And categoricals, which get represented compactly.
% ctg = categorical(repmat({'foo' 'bar' 'baz'}, [4 1]));
% mat2strjl(ctg)
%
% % Yay, it supports datetime!
% mat2strjl(datetime)
%
% % Yes, it respects Format and TimeZone!
% dt = datetime;
% dt.TimeZone = 'America/Chicago';
% dt.Format = 'uuuu-MM-dd HH:mm:ss';
% mat2strjl(dt)
%
% % And you can mash together heterogeneous nested data structures!
% mat2strjl({ 42 datetime dt "foobar" {'foobar'} ...
%   struct('foo', 42, 'bar', struct('qux', [32 1 2]), ...
%   'c', { 1 "foo" 'bar'}, 'ctg', categorical({'a','b','a','c','a','d'})) })
%
% See also:
% MAT2STR

% TODO: table support

% Special cases that need to be grabbed first
% All Matlab-supplied types that are objects and are not supported by 
% mat2str must be grabbed here, to avoid the delegation call below.
if isaAnyOf(x, {'datetime', 'duration', 'calendarDuration'})
  out = mat2strjlRecurse(x);
  return
end
if iscategorical(x)
  out = mat2strjlCategorical(x);
  return
end

% Delegation in cases known or expected to support mat2str directly
if isnumeric(x) || ischar(x) || isstring(x) || islogical(x)
  % Here we know that Matlab provides a mat2str() implementation
  out = mat2str(x);
  return
end
if isobject(x)
  % Here we hope that the class author has provides a mat2str() override
  out = mat2str(x);
  return
end

% General case
out = mat2strjlRecurse(x);

end

function out = mat2strjlRecurse(x)
if ndims(x) > 2 %#ok<ISMAT>
  lastDim = ndims(x);
  len = size(x, lastDim);
  pageExprs = cell(1, len);
  for i = 1:len
    ixs = repmat({':'}, [1 ndims(x)]);
    ixs{end} = i;
    slice = x(ixs{:});
    pageExprs{i} = mat2strjlRecurse(slice);
  end
  out = sprintf('cat(%d, %s)', lastDim, strjoin(pageExprs, ', '));
else
  out = mat2strjlMatrix(x);
end
end

function out = mat2strjlMatrix(x)
%MAT2STRJLMATRIX

  if isempty(x)
    UNIMPLEMENTED
  end
  
  % Fallbacks to Matlab's own implementation
  if isnumeric(x) || isstring(x) || ischar(x)
    out = mat2str(x);
    return
  end
  
  % Special case for datetimes because we can build a compact constructor
  % call for an entire matrix for them.
  if isa(x, 'datetime')
    tz = x.TimeZone;
    fmt = x.Format;
    defaultFormat = 'dd-MMM-uuuu HH:mm:ss.SSSSSSSSS';
    % I _wish_ we could use human-readable string format instead of datenum
    % format here, but that conversion is lossy, since (I think) datetime's
    % underlying representation is a double datenum, and not some type that
    % is exact to the millisecond or whatever.
    dt2 = x;
    dt2.Format = defaultFormat;
    out = sprintf('datetime(%s', ...
      mat2str(string(dt2)));
    if ~isempty(tz)
      out = sprintf('%s, ''TimeZone'',''%s''', out, tz);
    end
    if ~isequal(fmt, defaultFormat)
      out = sprintf('%s, ''Format'',''%s''', out, fmt);
    end
    out = [out ')'];
    return
  end
  
  % General case
  isCell = iscell(x);
  elExprs = cell(size(x));
  for i = 1:numel(x)
    if isCell
      elExprs{i} = mat2strjlRecurse(x{i});
    else
      elExprs{i} = mat2strjlScalar(x(i));
    end
  end
  rowExprs = cell(size(x,1), 1);
  for i = 1:numel(rowExprs)
    rowExprs{i} = strjoin(elExprs(i,:), ', ');
  end
  if isCell
    out = sprintf('{%s}', strjoin(rowExprs, '; '));
  else
    if isscalar(elExprs)
      out = elExprs{1};
    else
      out = sprintf('[%s]', strjoin(rowExprs, '; '));
    end
  end
end

function out = mat2strjlCategorical(c)
  codes = int64(c); % I'm certain int64 is big enough to hold any code set
  levels = categories(c);
  out = sprintf('categorical(%s, %s, %s', ...
    mat2strjl(codes), mat2strjl(unique(codes)), mat2strjl(levels));
  if isordinal(c)
    out = [out ', ''Ordinal'',true'];
  end
  if isprotected(c)
    out = [out ', ''Protected'',true'];
  end
  out = [out ')'];
end

function out = mat2strjlScalar(x)
  if isstruct(x)
    s = x;
    fields = fieldnames(s);
    args = cell(1, 2*numel(fields));
    for i = 1:numel(fields)
      args{2*(i-1)+1} = fields{i};
      val = s.(fields{i});
      expr = mat2strjl(val);
      if iscell(val)
        % Special case: must protect against struct()'s expansion of cells
        % by sticking it inside another cell
        expr = ['{' expr '}']; %#ok<AGROW>
      end
      args{2*(i-1)+2} = expr;
    end
    out = sprintf('struct(%s)', strjoin(args, ', '));
  else
    out = mat2str(x);
  end
end

function out = isaAnyOf(x, types)
types = string(types);
for i = 1:numel(types)
  if isa(x, types(i))
    out = true;
    return
  end
end
out = false;
end
