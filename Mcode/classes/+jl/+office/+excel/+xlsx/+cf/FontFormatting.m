classdef FontFormatting < jl.office.excel.cf.FontFormatting
  %FONTFORMATTING XLSX-specific font formatting
  
  methods
    
    function this = FontFormatting(jObj)
      if nargin == 0
        return
      end
      mustBeA(jObj, 'org.apache.poi.xssf.usermodel.XSSFFontFormatting');
      this.j = jObj;
    end
    
    function resetFontStyle(obj)
      this.j.resetFontStyle;
    end
    
  end
  
end

