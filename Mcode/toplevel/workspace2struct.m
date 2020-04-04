function out = workspace2struct()
%WORKSPACE2STRUCT Capture all variables in the workspace to a struct
%
% s = workspace2struct
%
% Captures all variables in the caller's workspace and stores them in fields of
% a struct with corresponding names.

varnames = evalin('caller', 'who');
out = struct;
for i = 1:numel(varnames)
  out.(varnames{i}) = evalin('caller', varnames{i});
end

end