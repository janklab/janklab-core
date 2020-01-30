classdef Color < jl.office.excel.ExtendedColor
  % Color A color in an XLSX (Office 2003) workbook
  
  methods
    
    function this = Color(jObj)
      if nargin == 0
        return
      end
      mustBeA(jObj, 'org.apache.poi.xssf.usermodel.XSSFColor');
      this = this@jl.office.excel.ExtendedColor(jObj);
    end
    
    function out = hasAlpha(this)
      out = this.j.hasAlpha;
    end
    
    function out = hasTint(this)
      out = this.j.hasTint;
    end
    
    function setAuto(this, val)
      this.j.setAuto(val);
    end
    
    function setIndexed(this, val)
      this.j.setIndexed(val);
    end
    
  end
  
end