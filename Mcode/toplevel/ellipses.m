function out = ellipses(x, nEls, nChars)
%ELLIPSES Create a string of element values, with truncation
%
% out = ellipses(x)
% out = ellipses(x, nEls, nChars)
%
% Constructs a string that holds a representation of all the elements in
% the array you passed in. If the string is "too long", it will be
% truncated and end in ellipses like "..." (hence the name of this
% function).
%
% This function is intended for producing output to be displayed in the
% command window or in log files. The truncation feature is there to avoid
% completely spamming the user in case the input array is large. (Which in
% Matlab and scientific programming, sometimes it can be *quite* large.)
%
% x is the array of values you want to convert to a string. It can be
% anything that supports dispstrs(), which means just about any type.
%
% nEls (double, 128*) is the maximum number of elements to display in the
% list before truncation.
%
% nChars (double, 1024) is the maximum string length in characters to
% produce before truncation.
%
% Returns a charvec.

if nargin < 2 || isempty(nEls);  nEls = 128;  end
if nargin < 3 || isempty(nChars); nChars = 1024; end

% TODO: Do the nEls truncation on x before converting to strings, for
% speed.

strs = dispstrs(x);
strs = strs(:)';
strLens = strlen(strs);
outLen = cumsum(strLens);

ixTruncChars = find(outLen > nChars, 1);

ixTrunc = Inf;
if numel(x) > nEls
  ixTrunc = nEls;
end
if ~isempty(ixTruncChars)
  ixTrunc = min(ixTrunc, ixTruncChars);
end

if ~isinf(ixTrunc)
  out = [strjoin(strs(1:ixTrunc-1), ', ') ', ...'];
else
  out = strjoin(strs, ', ');
end