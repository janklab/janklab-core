function [outA, outB] = identityProxyUsingUnique(a, b)
%IDENTITYPROXYUSINGUNIQUE Compute proxy values using output of UNIQUE
if nargin == 1
    [~, ~, ixC] = unique(a(:));
    outA = ixC;
else
    [~, ~, ixC] = unique([a(:); b(:)]);
    outA = reshape(ixC(1:numel(a)), size(a));
    outB = reshape(ixC((numel(a)+1):end), size(b));
end
end