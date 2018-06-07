function [outA,outB] = rowKeysToScalarProxyKeys(A, B)
%ROWKEYSTOSCALARPROXYKEYS Compute scalar proxy keys from row proxy keys
%
% [outA,outB] = rowKeysToScalarProxyKeys(A, B)

nA = size(A, 1);

k = [A; B];
[~,~,jx] = unique(k, 'rows');

outA = jx(1:nA);
outB = jx((nA+1):end);

end