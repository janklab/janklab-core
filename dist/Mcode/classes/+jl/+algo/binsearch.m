function [ix,ix2] = binsearch(item, x)
%BINSEARCH Binary search
%
% [ix,ix2] = binsearch(item, x)
%
% Searches for the given key item in the sorted array x.
% 
% Returns the index where the value was found, or [] if it was not found.
% If it was not found, then ix2 will contain the index where the value
% should be inserted in to the array to maintain sorting.
%
% This will work on any type that supports <, >, and ==.

if (isa(item, 'double') && isa(x, 'double')) ...
        || (isa(item, 'single') && isa(x, 'single'))
    ix = jl.algo.binsearch_mex(x, item);
    if ix < 0
        ix2 = (-1 * ix);
        ix = [];
    else
        ix = ix + 1;
        ix2 = ix;
    end
else
    [ix,ix2] = jl.algo.binsearch_mcode(item, x);
end