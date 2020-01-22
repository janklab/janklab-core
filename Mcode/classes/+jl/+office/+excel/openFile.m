function out = openFile(file)
% Open an existing Excel file for reading
%
% out = jl.office.excel.openFile(file)
%
% File (string) is the path to the file you wish to open. It may be in either
% Excel 97 (.xls) or Excel 2007 (.xlsx or .xlsm) format. The format is
% automatically detected.
%
% Returns a jl.office.excel.Workbook object of the appropriate subclass for the
% file's format.
%
% Raises an error if the file does not exist or could not be read for some
% reason.

out = jl.office.excel.Workbook.openFile(file);

end