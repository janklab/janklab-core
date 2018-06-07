function out = fopen(filename, permission, machinefmt, encoding)
%FOPEN Open a file
%
% Opens a file as a jl.io.FileHandle. This is a convenience wrapper around
% jl.io.FileHandle.fopen.
%
% Throws an exception if the operation fails.

if nargin == 1
	out = jl.io.FileHandle.fopen(filename);
elseif nargin == 2
	out = jl.io.FileHandle.fopen(filename, permission);
else
	out = jl.io.FileHandle.fopen(filename, permission, machinefmt, encoding);
end

end