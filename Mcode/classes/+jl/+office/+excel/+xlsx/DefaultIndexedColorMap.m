classdef DefaultIndexedColorMap < jl.office.excel.xlsx.IndexedColorMap
  % A color map that uses the legacy colors defined in Excel 97 for lookups
  
  methods
    
    function this = DefaultIndexedColorMap(jObj)
      if nargin == 0
        return
      end
      mustBeA(jObj, 'org.apache.poi.xssf.usermodel.DefaultIndexedColorMap');
      this = this@jl.office.excel.xlsx.IndexedColorMap(jObj);
    end
    
    function out = getDefaultRgb(this, index)
      out = this.j.getDefaultRGB(index);
    end
    
  end
  
end