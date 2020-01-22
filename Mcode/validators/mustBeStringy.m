function mustBeStringy(x)
%MUSTBESTRINGY Validate that value is a string array or charvec
%
% muutBeStringy(x)
%
% Errors if x is not a string and is not a charvec and is not a cellstr
%
% See also:
% mustBeString
% mustBeCharvec
% mustBeScalarString
% isstring

if ~isstring(x) && ~(ischar(x) && (isrow(x) || isempty(x))) && ~iscellstr(x)
  reportBadValue(valueName, 'string of some type', sprintf('%s %s',...
      size2str(size(x)), class(x)));
end
