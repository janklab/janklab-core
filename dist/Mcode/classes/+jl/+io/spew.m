function spew(file, data)
%SPEW Write data to a file

[fid,msg] = fopen(file, 'w');
if fid < 0
    error('jl:io', 'Failed opening file ''%s'': %s', file, msg);
end
RAII.fid = onCleanup(@() fclose(fid));

fwrite(fid, data);