function out = createNew(format)
% Create a new Excel workbook
%
% out = jl.office.excel.createNew(format)
%
% Creates a new in-memory workbook in the specified format.
%
% Format (string) is the workbook/file format to use. May be "xls" for
% Excel 97 (.xls) format, or "xlsx" for Excel 2007 (.xlsx or .xlsm) format.
% Format is optional; the default is "xlsx" (Excel 2007).
%
% Returns a new Workbook object of the appropriate subclass for the specified
% format.

if nargin < 1 || isempty(format); format = "xlsx"; end

out = jl.office.excel.Workbook.createNew(format);

end