function out = countThings(x)
%COUNTTHINGS Count the occurrences of values in an array
%
% out = jl.util.countThings(x)
%
% Counts the occurrences of distinct values in an array.
%
% Returns a table with variables Value and Count, sorted by Count in descending
% order.

[ux,~,Jndx] = unique(x(:));

Value = ux;
Count = NaN(size(Value));
for i = 1:numel(Value)
    Count(i) = numel(find(Jndx == i));
end

out = table(Value, Count);
out = sortrows(out, 'Count', 'descend');

end

