function pushd(varargin)
%PUSHD Push a directory on to the directory stack, cding to a new directory
%
% pushd [-n] [<dir>]
%
% Pushd pushes the current directory on to the pushd directory stack, and cds to
% the new specified directory <dir>. The previously-pushed directory can then be
% recalled using POPD.
%
% With no arguments, pushd exchanges the top two directories and makes the new
% top the current directory.
%
% Options:
%   -n  - Suppresses the normal change of directory when rotating or adding 
%         directories to the stack, so that only the stack is manipulated.
%
% See also:
% POPD
% PUSHD_DIRS

tfOption = startsWith(varargin, '-');
options = varargin(tfOption);
args = varargin(~tfOption);
if numel(args) > 1
    error('pushd: Too many arguments (max 1; got %d)', numel(args));
end

janklabState = getappdata(0, 'JanklabState');
if isfield(janklabState, 'PushdStack')
    stack = janklabState.PushdStack;
else
    stack = {};
end

doDisplay = false;
if isempty(args)
    % No args: rotate the stack
    if numel(stack) < 2
        error('pushd: Less than 2 dirs on stack. Cannot rotate.');
    end
    stack = [stack(1:end-2) stack{end} stack{end-1}];
    newDir = stack{end};
    doDisplay = true;
else
    newDir = args{1};
    stack{end+1} = pwd;
end

janklabState.PushdStack = stack;
setappdata(0, 'JanklabState', janklabState);

if ~ismember('-n', options)
    cd(newDir);
    if doDisplay
        disp(newDir);
    end
end

end