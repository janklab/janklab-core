function struct2vars(s)
% Assign values from a struct's fields to variables in the current workspace.
%
% struct2vars(s)
%
% Assigns the value in each field of the input struct s to a variable of
% the same name in the current workspace. This is the inverse of what
% VARS2STRUCT does.
%
% See also:
% VARS2STRUCT

assert(isstruct(s));
mustBeScalar(s);

varnames = fieldnames(s);
for i = 1:numel(varnames)
  assignin('caller', varnames{i}, s.(varnames{i}));
end

end