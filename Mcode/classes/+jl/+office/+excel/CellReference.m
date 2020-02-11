classdef CellReference < handle
% CellReference

  properties
    % The underlying POI org.apache.poi.ss.usermodel.CellReference Java object
    j
  end
  
  properties (Dependent)
    column
    row
    sheetName
    isColumnAbsolute
    isRowAbsolute
  end

  % TODO: Factory methods or alternate constructor calling forms to create
  % cell references out of values, instead of wrapping a Java CellReference obj
  
  methods

    function this = CellReference(jObj)
      if nargin == 0
        return
      end
      mustBeA(jObj, 'org.apache.poi.ss.usermodel.CellReference');
      this.j = jObj;
    end
    
    function out = get.column(this)
      out = this.j.getCol;
    end
    
    function out = get.row(this)
      out = this.j.getRow;
    end
    
    function out = get.sheetName(this)
      out = string(this.j.getSheetName);
    end
    
    function out = get.isColumnAbsolute(this)
      out = this.j.isColumnAbsolute;
    end
    
    function out = get.isRowAbsolute(this)
      out = this.j.isRowAbsolute;
    end

  end

end
