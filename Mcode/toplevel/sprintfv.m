function out = sprintfv(format, varargin)
%SPRINTFV "Vectorized" sprintf
%
% out = sprintfv(format, varargin)
%
% SPRINTFV is an array-oriented form of sprintf that applies a format to array
% inputs and produces a cellstr.
%
% This is not a high-performance method. It's a convenience wrapper around a
% loop around sprintf().
%
% Returns cellstr.

args = varargin;
for i = 1:numel(args)
    if ischar(args{i})
        args{i} = { args{i} };  %#ok<CCAT1>
    end
end
[args{:}] = scalarexpand(args{:});

sz = size(args{1});
out = cell(sz);
for i = 1:numel(out)
    theseArgs = cell(size(args));
    for iArg = 1:numel(args)
        theseArgs{iArg} = args{iArg}(i);
        if iscell(theseArgs{iArg})
            theseArgs{iArg} = theseArgs{iArg}{1};
        end
    end
    out{i} = sprintf(format, theseArgs{:});
end
