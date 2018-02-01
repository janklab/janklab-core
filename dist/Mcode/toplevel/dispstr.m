function out = dispstr(x)
%DISPSTR Display string for arrays
%
% This returns a one-line string representing the input value, in a format
% suitable for inclusion into multi-element output.
%
% The intention is for classes to override this method.
%
% See also: DISPSTRS

if ~ismatrix(x)
    out = sprintf('%s %s', size2str(size(x)), class(x));
elseif isempty(x)
    if ischar(x) && isequal(size(x), [0 0])
        out = '''''';
    elseif isnumeric(x) && isequal(size(x), [0 0])
        out = '[]';
    else
        out = sprintf('Empty %s %s', size2str(size(x)), class(x));
    end
elseif isnumeric(x)
    if isscalar(x)
        out = num2str(x);
    else
        strs = strtrim(cellstr(num2str(x(:))));
        out = formatArrayOfStrings(strs);
    end
elseif ischar(x)
    if isrow(x)
        out = ['''' x ''''];
    else
        strs = strcat({''''}, num2cell(x,2), {''''});
        out = formatArrayOfStrings(strs);
    end
elseif iscell(x)
    if iscellstr(x)
        strs = strcat('''', x, '''');
    else
        strs = cellfun(@dispstr, x, 'UniformOutput',false);
    end
    out = formatArrayOfStrings(strs, {'{','}'});
else
    out = sprintf('%s %s', size2str(size(x)), class(x));
end

end

function out = formatArrayOfStrings(strs, brackets)
if nargin < 2 || isempty(brackets);  brackets = { '[' ']' }; end
rowStrs = cell(size(strs,1), 1);
for iRow = 1:size(strs,1)
    rowStrs{iRow} = strjoin(strs(iRow,:), ' ');
end
out = [brackets{1} strjoin(rowStrs, '; ') brackets{2}];
end
