function pushd_dirs(varargin)
%PUSHD_DIRS List or manage the directory stack for pushd/popd
%
% pushd_dirs [-l] [-v]
% pushd_dirs -c
%
% pushd_dirs lists the directories on the directory stack used by pushd/popd.
% Options:
%     -l  - Produces a listing with full pathnames; the default listing format
%           uses a tilde to denote the home directory.
%     -p  - Vertical display: prints the directory stack with one entry per
%           line.
%     -v  - Vertical display with numbers: prints the directory stack with one
%           entry per line, prefixing each entry with its index in the stack.
%
% 'pushd_dirs -c' clears the directory stack.
%
% See also:
% PUSHD
% POPD


janklabState = getappdata(0, 'JanklabState');
if isfield(janklabState, 'PushdStack')
    stack = janklabState.PushdStack;
else
    stack = {};
end

if ismember('-c', varargin)
    % Clear the stack
    stack = {};
    janklabState.PushdStack = stack;
    setappdata(0, 'JanklabState', janklabState);
else
    % Show the stack
    d = stack;
    if ~ismember('-l', varargin)
        homeDir = getenv('HOME');
        n = numel(homeDir);
        for i = 1:numel(d)
            if startsWith(d{i}, homeDir)
                d{i} = ['~' d{i}(n+1:end)];
            end
        end
    end
    if ismember('-p', varargin)
        disp(strjoin(d, '\n'));
    elseif ismember('-v', varargin)
        strs = {};
        for i = 1:numel(d)
            strs{end+1} = sprintf('%-5d %s', i, d{i}); %#ok<AGROW>
        end
        disp(strjoin(strs, '\n'));
    else
        disp(strjoin(d, ' '));
    end
end

