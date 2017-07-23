function out = isCellrec(x)

if ~iscell(x)
    out = false;
    return;
end
if isequal(size(x), [0 0])
    out = true;
    return;
end

out = size(x,2) == 2 && iscellstr(x(:,1));