function out = slurp(file, precision, encoding)
%SLURP Read all data from a file
%
% out = slurp(file, precision, encoding)
%
% Reads a file's entire contents. Throws an error if there is an I/O
% error.
%
% Precision (char, '*char'*) is the precision to read in. If precision is
% '*char' (the default), the file contents are read as text, and an encoding
% transformation may be supplied.
%
% File (char) is the path to the file to read in, as accepted by Matlab's
% fopen() function.
%
% Encoding (char, 'UTF-8'*) is the character set encoding to treat the
% input as. It may be any of the encodings supported by Matlab's FREAD
% function; see its helptext for a list. Unlike Matlab's fread() and
% fscanf() functions, the default is UTF-8 and not the platform's default
% encoding. This is because UTF-8 is more widely used as of 2014,
% especially for data interchange.
%
% When reading as text:
% The file is returned as a single string, with all line endings preserved.
% Note that when displayed on the Matlab command line, the file may appear 
% double-spaced, because it may be encoded with Windows style "\r\n" line
% endings, but Matlab's console window treats "\r" and "\n" as separate
% line endings.
%
% Returns a vector, of a type determined by precision.
%
% Examples:
%
% % Read a normal text file
% str = jl.io.slurp('somefile.txt');
% % Read UTF-16 formatted output of a Windows system tool
% str = jl.io.slurp('command_output.txt', 'UTF-16');
%
% See also:
% FOPEN
% FREAD

if nargin < 2 || isempty(precision);  precision = '*char'; end
if nargin < 3 || isempty(encoding);   encoding = 'UTF-8';  end

[fid,msg] = fopen(file, 'r', 'native', encoding);
if fid < 0
    error('jl:io', 'Failed opening file ''%s'': %s', file, msg);
end

RAII.fid = onCleanup(@() fclose(fid));

data = fread(fid, precision);
out = data(:)';