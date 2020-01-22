classdef Font < jl.office.excel.Font
  
  properties (Constant)
    DefaultFontColor = org.apache.poi.xssf.usermodel.XSSFFont.DEFAULT_FONT_COLOR
    DefaultFontName = string(org.apache.poi.xssf.usermodel.XSSFFont.DEFAULT_FONT_NAME)
    DefaultFontSize = org.apache.poi.xssf.usermodel.XSSFFont.DEFAULT_FONT_SIZE
  end
  
  methods
    
    function this = Font(jObj)
      mustBeA(jObj, 'org.apache.poi.xssf.usermodel.XSSFFont');
      this.j = jObj;
    end
    
  end
  
end