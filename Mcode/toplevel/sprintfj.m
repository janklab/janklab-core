function out = sprintfj(fmt, varargin)
% sprintff Sprintf, but using Java's extended formatting support
%
% out = sprintff(fmt, varargin)
%
% This lets you call sprintf in a way that uses Java's sprintf formatting
% (from java.lang.String.format) instead of Matlab's built-in sprintf. This
% supports formatting extensions like "%,f" for thousands-separator commas.
%
% Dispstr support and sprintfv "vectorization" are also built in.
%
% Hitches:
%  * If you're passing a number to a %d conversion, you must convert it to
%    an integer type. Use a "%.0f" conversion instead, for convenience.
%    And you can't pass an integer to a %f conversion.
%  * It's gonna be slower than sprintf, sprintfv, or sprintfc.
%
% Returns a string array the same size as the nonscalar varargins, or a
% scalar string if all the varargins were scalar. (Char argins are
% implicitly converted to scalar strings.)

args = varargin;
% HACK: Use dispstrlib internal function. Since this is useful, maybe it
% should be made public in dispstr?
args = dispstrlib.internal.convertArgsForPrintf(args);
% Actually, we need to convert datetimes, since Java sprintf doesn't
% support them.

fmt = string(fmt);
for i = 1:numel(args)
  if ischar(args{i}) || iscellstr(args{i})
    args{i} = string(args{i});
  elseif isa(args{i}, 'datetime') || isa(args{i}, 'duration')
    args{i} = reshape(string(cellstr(datestr(args{i}))), size(args{i}));
  end
end

[args{:}] = scalarexpand(args{:});

sz = [1 1];
n = 1;
for i = 1:numel(args)
  if ~isscalar(args{i})
    sz = size(args{i});
    n = numel(args{i});
    break
  end
end

out = repmat(string(missing), sz);
jArgs = javaArray('java.lang.Object', numel(args));
for iEl = 1:n
  theseArgs = cell([1 numel(args)]);
  for iArg = 1:numel(args)
    arg = args{iArg}(iEl);
    theseArgs{iArg} = arg;
    if isnumeric(arg)
      jArgs(iArg) = numeric2java(arg);
    elseif isstring(arg)
      jArgs(iArg) = java.lang.String(arg);
    else
      % Hope it auto-boxes
      jArgs(iArg) = arg;
    end
  end
  jStr = java.lang.String.format(fmt, jArgs);
  out(iEl) = string(jStr);
end

end

function out = numeric2java(x)
  switch class(x)
    case 'double'
      out = java.lang.Double(x);
    case 'single'
      out = java.lang.Float(x);
    case 'int8'
      out = java.lang.Byte(x);
    case 'int16'
      out = java.lang.Short(x);
    case 'int32'
      out = java.lang.Integer(x);
    case 'int64'
      out = java.lang.Long(x);
    case 'uint8'
      out = java.lang.Short(x);
    case 'uint16'
      out = java.lang.Integer(x);
    case 'uint32'
      out = java.lang.Long(x);
    case 'uint64'
      % TODO: Maybe use BigInteger?
      out = java.math.BigInteger(sprintf('%d', x));
    otherwise
      error('jl:InvalidInput', 'Unsupported type: %s', class(x));
  end
end