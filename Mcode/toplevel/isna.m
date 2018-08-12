function out = isna(x)
%ISNA True for N/A data (such as NaN or NaT (or maybe Java null))
%
% out = isna(x)
%
% ISNA is a generalization of ISNAN. It returns true for any missing values,
% whether these are represented as NaN or NaT. It can run on any data type,
% whereas isnan() throws errors on some types of inputs.
%
% ISNA will return a logical array the same size as its input, with trues in the
% place of "missing" or "Not-a-X" values in the input, and falses in all other
% elements. Missing/Not-a-X values include:
%   * NaNs for doubles and floats
%   * NaTs for datetimes
%   * Matlab objects for which isnan(x) is true
% For other data types, ISNA will return false for all input elements.
% TODO: This may be extended to support isnat(x) for Matlab objects.
% TODO: This may be extended to support Java null values in Java arrays.
%
% ISNA is *not* the same as ISNIL. ISNA is an element-wise test for "missing
% value" indicators. ISNIL tests whether the entire array/variable is "nil". ISNA
% is false for NIL, and ISNIL is false for any array where ISNA is true.
%
% The only reasons this method exists are because:
%   * datetime decided to define 'isnat()' instead of 'isnan()'
%   * some user-defined objects may not define isnan, and
%   * isnan() is not defined for Java objects, not even to just return false
%   * isnan() is not defined for cells
%
% DEVELOPER NOTES
%
% So, as an author of classes, should you define an isnan() or an isna() for
% your custom classes? (Or both?) I don't know the answer at this point.
%
% SEE ALSO:
% ISNAN, ISNAT, ISNIL

% Developer's note: If there is any type of input which throws a type error
% about "Undefined function 'isnan' for input arguments of type '...'", that is
% a bug; please report it to Janklab.

if isnumeric(x)
    out = isnan(x);
elseif iscell(x)
    out = false(size(x));
elseif isa(x, 'datetime')
    out = isnat(x);
elseif isa(x, 'duration') || isa(x, 'calendarDuration')
    out = isnan(x);
elseif isjava(x)
    %TODO: In arrays, true for NULL ([]), false otherwise. Probably. Maybe.
    %TODO: Support Double[] and Float[] with their isNan()?
    error('isna() is unimplemented for Java objects.');
elseif isobject(x)
    %TODO: Detect whether object defines isnat(), and call that instead.
    out = isnan(x);
else
    out = isnan(x);
end    

end