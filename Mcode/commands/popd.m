function popd(varargin)
%POPD Pop a directory off the directory stack, and cd to it
%
% popd [-n]
%
% Popd pops the last directory off the directory stack created by PUSHD, and cds
% to it.
%
% Options:
%     -n  - Suppresses the normal change of directory when removing directories
%           from the stack, so that only the stack is manipulated.
%
% See also:
% PUSHD
% PUSHD_DIRS

janklabState = getappdata(0, 'JanklabState');
if isfield(janklabState, 'PushdStack')
    stack = janklabState.PushdStack;
else
    stack = {};
end

if isempty(stack)
    fprintf('popd: Directory stack is empty\n');
    return;
end

newDir = stack{end};
stack(end) = [];

janklabState.PushdStack = stack;
setappdata(0, 'JanklabState', janklabState);

if ~ismember('-n', varargin)
    cd(newDir);
    disp(newDir);
end

end