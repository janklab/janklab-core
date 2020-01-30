classdef ExtendedColor < jl.office.excel.ExtendedColor
  % ExtendedColor An ExtendedColor in an XLS (Office 97) workbook
  
  methods
    
    function this = ExtendedColor(jObj)
      if nargin == 0
        return
      end
      mustBeA(jObj, 'org.apache.poi.hssf.usermodel.HSSFExtendedColor');
      this = this@jl.office.excel.ExtendedColor(jObj);
    end
    
  end
  
end