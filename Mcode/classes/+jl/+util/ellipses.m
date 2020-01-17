function out = ellipses(x, n)
%ELLIPSES Convert array into a possibly-truncated list of values
%
% out = jl.util.ellipses(x, n)
%
% x may be anything that supports dispstrs(). (Which is basically anything.)
%
% n is the maximum number of elements to include in the output before truncating
% the list.
%
% Returns a scalar string

if nargin < 2 || isempty(n); n = 40; end

strs = dispstrs(x);
strs = strs(:)';
if numel(strs) > n
  strs(n+1:end) = [];
  strs(end+1) = {'...'};
end
out = strjoin(strs, ', ');
end