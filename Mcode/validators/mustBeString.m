function mustBeString(x)
%MUSTBESTRING Validate that value is a string array
%
% mustBeString(x)
%
% Errors if x is not a string, as determined by isstring().
%
% See also:
% mustBeStringy
% mustBeCharvec
% mustBeScalarString
% isstring

if ~isstring(x)
  reportBadValue(valueName, 'string array', sprintf('%s %s',...
      size2str(size(x)), class(x)));
end
