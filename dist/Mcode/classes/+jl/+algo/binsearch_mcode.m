function [ix,ix2] = binsearch_mcode(item, x)
%BINSEARCH_MCODE A pure Mcode implementation of binary search
%
% [ix,ix2] = binsearch_mcode(item, x)
%
% Searches for the given key item in the sorted array x.
% 
% Returns the index where the value was found, or [] if it was not found.
% If it was not found, then ix2 will contain the index where the value
% should be inserted in to the array to maintain sorting.
%
% This will work on any type that supports <, >, and ==.

ixLow = 1;
ixHigh = numel(x);

while (ixLow <= ixHigh)
    ix = floor((ixLow + ixHigh) / 2);
    val = x(ix);
    
    if (val < item)
        ixLow = ix + 1;
    elseif (item < val)
        ixHigh = ix - 1;
    elseif item == val
        ix2 = ix;
        return;
    else
        if isnumeric(x)
            error('jl:InvalidInput', 'Unexpected value in input: %f', val);
        else
            error('jl:InvalidInput', 'Unexpected value in input');
        end
    end
end

% Not found
ix2 = ixLow;
ix = [];

end