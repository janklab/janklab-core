function out = vars2struct()
% Capture all variables in the current workspace to a struct.
%
% s = vars2struct
%
% Captures all variables in the caller's workspace and stores them in fields of
% a struct with corresponding names. This lets you package up a workspace
% into a struct which can be passed around as a data structure.
%
% Returns a scalar struct.
%
% See also:
% STRUCT2VARS

varnames = evalin('caller', 'who');
out = struct;
for i = 1:numel(varnames)
  out.(varnames{i}) = evalin('caller', varnames{i});
end

end