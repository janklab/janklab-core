function out = isaOneOf(x, types)
%ISAONEOF True if value is one of a list of given types
%
% This uses the base ISA test, not ISA2.
for i = 1:numel(types)
    if isa(x, types{i})
        out = true;
        return;
    end
end
out = false;
end