classdef CellStyle < jl.office.excel.CellStyle
  
  methods
    
    function this = CellStyle(wkbk, jObj)
      if nargin == 0
        return
      else
        mustBeA(wkbk, 'jl.office.excel.Workbook');
        mustBeA(jObj, 'org.apache.poi.xssf.usermodel.XSSFCellStyle');
        this.wkbk = wkbk;
        this.j = jObj;
      end
    end
    
  end
  
  methods (Access = protected)
    
    function out = wrapColorObject(this, jObj) %#ok<INUSL>
      if isempty(jObj)
        out = [];
      else
        out = jl.office.excel.xlsx.Color(jObj);
      end
    end
    
    function setFillBackgroundColor(this, val)
      color = jl.office.excel.xlsx.Color.ofWhatever(val);
      this.j.setFillBackgroundColor(color.index);
    end
    
  end
  
end