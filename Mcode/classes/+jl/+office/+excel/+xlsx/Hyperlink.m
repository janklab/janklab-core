classdef Hyperlink < jl.office.excel.Hyperlink
  
  properties (Dependent)
    cellRef
  end
    
  methods
    
    function this = Hyperlink(varargin)
      this = this@jl.office.excel.Hyperlink(varargin{:});
      if nargin == 0
        return
      end
      mustBeA(varargin{1}, 'org.apache.poi.xssf.usermodel.XSSFHyperlink');
    end
    
    function out = get.cellRef(this)
      out = string(this.j.getCellRef);
    end
    
    function set.cellRef(this, val)
      this.j.setCellref(val);
    end
    
  end
  
end

