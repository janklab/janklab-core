classdef Sheet < jl.util.DisplayableHandle
  
  properties
    % The underlying POI XSSFSheet object
    j
    % The parent workbook
    workbook
  end
  
  properties (Dependent)
    activeCellAddress
    autobreaks
  end
  
  methods
    
    function this = Sheet(workbook, jObj)
      if nargin == 0
        return
      else
        mustBeA(workbook, 'jl.office.excel.Workbook');
        mustBeA(jObj, 'org.apache.poi.ss.usermodel.Sheet');
        this.workbook = workbook;
        this.j = jObj;
      end
    end
    
    function out = dispstr_scalar(this)
      out = sprintf('[Sheet: ]');
    end
    
    function out = get.activeCellAddress(this)
      out = jl.office.excel.CellAddress(this.j.getActiveCell);
    end
    
    function set.activeCellAddress(this, val)
      mustBeA(val, 'jl.office.excel.CellAddress');
      this.j.setActiveCell(val.j);
    end
    
    function out = get.autobreaks(this)
      out = this.j.getAutobreaks;
    end
    
    function set.autobreaks(this, val)
      this.j.setAutobreaks(val);
    end
    
    
  end
  
end