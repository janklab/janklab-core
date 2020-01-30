classdef (Abstract) Color < jl.util.DisplayableHandle
  % A Color in an Excel workbook
  %
  % This is the base class for XLS and XLSX colors. Because colors are done so
  % differently in the two Excel formats, there's not much they have in common,
  % and thus not much in this base class. See the format-specific Color class
  % definitions for details.
  %
  % See also:
  % jl.office.excel.xls.Color
  % jl.office.excel.xlsx.Color
  
  properties (SetAccess = protected)
    % The underlying POI Java Color object. May be one of the HSSFColor,
    % XSSFColor, or HSSFExtendedColor subclasses.
    j
  end
  
end