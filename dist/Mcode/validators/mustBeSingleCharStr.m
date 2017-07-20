function mustBeSingleCharStr(x)
%MUSTBESINGLECHARSTR Validate that value is a single string as char
%
% mustBeSingleCharStr(x)
%
% Errors if x is not a single string represented as a char vector. This
% means it must be the empty string '' or a char row vector.

mustBeType(x, 'char');
if size(x,1) > 1 || ~ismatrix(x)
    valueName = firstNonEmpty(name, inputname(1));
    reportBadValue(valueName, 'single string as char', sprintf('%s %s',...
        size2str(size(x)), class(x)));
end