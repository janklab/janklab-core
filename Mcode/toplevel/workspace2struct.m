function out = workspace2struct()
% Capture all variables in the workspace to a struct.
%
% s = workspace2struct
%
% Captures all variables in the caller's workspace and stores them in fields of
% a struct with corresponding names.
%
% This has been superseded by VARS2STRUCT, which has the same
% functionality, but I like the name better.
%
% Returns a scalar struct.
%
% See also:
% VARS2STRUCT
% STRUCT2VARS

varnames = evalin('caller', 'who');
out = struct;
for i = 1:numel(varnames)
  out.(varnames{i}) = evalin('caller', varnames{i});
end

end