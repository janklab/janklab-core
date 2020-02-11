classdef AreaReference < handle
% AreaReference

  properties
    % The underlying POI org.apache.poi.ss.usermodel.AreaReference Java object
    j
  end

  properties (Dependent)
    stringRep
    firstCell
    lastCell
    isSingleCell
    isWholeColumnReference
  end
  
  methods

    function this = AreaReference(jObj)
      if nargin == 0
        return
      end
      mustBeA(jObj, 'org.apache.poi.ss.usermodel.AreaReference');
      this.j = jObj;
    end

    function out = get.stringRep(this)
      out = string(this.j.formatAsString);
    end
    
    function out = get.firstCell(this)
      jObj = this.j.getFirstCell;
      out = jl.office.excel.CellReference(jObj);
    end
    
    function out = get.lastCell(this)
      jObj = this.j.getLastCell;
      out = jl.office.excel.CellReference(jObj);
    end
    
    function out = get.isSingleCell(this)
      out = this.j.isSingleCell;
    end
    
    function out = get.isWholeColumnReference(this)
      out = this.j.isWholeColumnReference;
    end
    
    function out = getAllReferencedCells(this)
      jArr = this.j.getAllReferencedCells;
      out = repmat(jl.office.excel.CellReference, [1 numel(jArr)]);
      for i = 1:numel(out)
        out(i) = jArr(i-1);
      end
    end
    
  end

end
