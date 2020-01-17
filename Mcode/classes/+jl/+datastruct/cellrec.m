function out = cellrec(x)
%CELLREC Convert to cellrec
%
% out = jl.datastruct.cellrec(x)
%
% Converts the input value to a "cellrec". A cellrec is an n-by-2 cell
% array with names in the first column that represents a list of name/value
% pairs.
%
% Input x may be a scalar struct, a cellrec, or a 2n-long name/value pair
% cell row vector.
%
% Returns a cellrec.

if isstruct(x)
    if ~isscalar(x)
        error('Non-scalar structs cannot be converted to cellrec');
    end
    out = [fieldnames(x) struct2cell(x)];
elseif iscell(x)
    if jl.types.tests.isCellrec(x)
        out = x;
    else
        % Name-value lists can be converted
        if isrow(x) && mod(numel(x), 2) == 0 && iscellstr(x(1:2:end))
            out = reshape(x, [2 numel(x)/2])';
        else
            error('Value is a cell but not a valid cellrec or name-value list');
        end
    end
else
    error('jl:InvalidInput', 'Type ''%s'' cannot be converted to cellrec',...
        class(x));
end