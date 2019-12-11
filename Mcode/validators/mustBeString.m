function mustBeString(x)
%MUSTBESTRING Validate that value is a string of some type
%
% muutBeString(x)
%
% Errors if x is not a string, as determined by isstring().
%
% See also:
% mustBeCharvec
% mustBeScalarString
% isstring

if ~isstring(x)
  reportBadValue(valueName, 'string of some type', sprintf('%s %s',...
      size2str(size(x)), class(x)));
end
