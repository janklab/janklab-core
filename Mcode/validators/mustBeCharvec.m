function mustBeCharvec(x)
%MUSTBECHARVEC Validate that value is a single string as char row vector
%
% mustBeCharvec(x)
%
% Errors if x is not a single string represented as a char row vector. This
% means it must be the empty string '' or a char row vector.
%
% See also:
% mustBeString
% mustBeStringy
% mustBeScalarString

mustBeA(x, 'char');
if size(x,1) > 1 || ~ismatrix(x)
    valueName = firstNonEmpty(name, inputname(1));
    reportBadValue(valueName, 'single string as char', sprintf('%s %s',...
        size2str(size(x)), class(x)));
end
