function out = valcmp(a, b)
%VALCMP Compare values
%
% out = valcmp(a, b)
%
% Compares the elements in the input arrays and returns -1, 0, or 1 for each,
% indicating whether a(i) is less than, equal to, or greater than b(i). This
% is analogous to the values returned by the C/C++ version of STRCMP.
%
% VALCMP considers NaNs to be equal, and to come after all non-NaN values. This
% is because it needs to return one of -1, 0, or 1, and impose a total ordering
% on its inputs. The output of VALCMP should be consistent with the ordering
% imposed by SORT.
%
% Works on any inputs for which <, ==, >, and ISNAN are defined and are
% consistent.

if isscalar(a)
	sz = size(b);
end

% This is a straightforward implementation that makes redundant comparisons, but
% avoids having to do possibly expensive subset reallocations on the inputs,
% which whould also mean more complex code. I'm unsure which would be faster in
% general, but I think this version is likely to be more cache- and
% memory-friendly, and is sure easier to read.

out = NaN(sz);
out(a < b) = -1;
out(eqnan(a, b)) = 0;
out(a > b) = 1;

if any(isnan(out))
	error('jl:InvalidInput', 'None of LT, EQNAN, or GT returned true for some input elements (class %s and %s)',...
		class(a), class(b));
end

end