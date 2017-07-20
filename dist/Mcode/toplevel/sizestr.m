function out = sizestr(x)
%SIZESTR Size of array as a display string
%
% out = sizestr(x)
%
% Returns the size of the input array X as a human-readable string.
%
% This is just a convenience wrapper around size2str(size(x)), provided 
% since that's such a common usage pattern.

out = size2str(size(x));