classdef CustomIndexedColorMap < jl.office.excel.xlsx.IndexedColorMap
  % A custom indexed color map, e.g. from the styles.xml definition
  
  methods
    
    function this = CustomIndexedColorMap(jObj)
      if nargin == 0
        return
      end
      mustBeA(jObj, 'org.apache.poi.xssf.usermodel.CustomIndexedColorMap');
      this = this@jl.office.excel.xlsx.IndexedColorMap(jObj);
    end
    
  end
  
end