function spew(file, data)
%SPEW Write data to a file

[fid,msg] = fopen(file, 'w');
if fid < 0
    error('jl:io', 'Failed opening file ''%s'': %s', file, msg);
end

fwrite(fid, data);

status = fclose(fid);
if status < 0
    error('jl:io', 'Failed closing file after writing. Write may have failed. File: ''%s''', ...
        file);
end

end
