function out = jndx2kndxs(jndx, n)
% Convert an item-to-bin mapping to a bin-to-items mapping
%
% out = jl.util.jndx2kndxs(jndx, n)
%
% Inverts a many-to-one item-to-bin mapping to a one-to-many
% bin-to-items mapping.
%
% Jndx (numeric) is a vector if bin indexes indicating which
% bin each item belongs to.
%
% N (numeric) is the number of bins. If omitted, it is taken to
% be max(jndx).
%
% Returns an n-long cell vector of index vectors, where out{i}
% is a list of the indexes of the input that belong in bin i.

if nargin < 2; n = []; end
mustBeVector(jndx);
if isempty(n) || isnan(n)
  n = max(jndx);
end

if isempty(jndx)
  out = [];
  return
end

% This approach is way faster than a dumb loop. Do not modify
% this code without benchmarking the before and after speeds!
ix = 1:numel(jndx);
out = splitapply(@(x) {x}, ix, jndx(:)');

if numel(out) < n
  out(end+1:n) = {[]};
end

end
