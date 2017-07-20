function out = isCellrec(x)

out = iscell(x) && size(x,2) == 2 && iscellstr(x(:,1));