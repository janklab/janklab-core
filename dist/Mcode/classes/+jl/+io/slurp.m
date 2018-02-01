function out = slurp(file, precision)
%SLURP Read all data from a file

if nargin < 2 || isempty(precision);  precision = '*char'; end

[fid,msg] = fopen(file, 'r');
if fid < 0
    error('jl:io', 'Failed opening file ''%s'': %s', file, msg);
end
RAII.fid = onCleanup(@() fclose(fid));

data = fread(fid, precision);
out = data(:)';