classdef PrintSetup < jl.office.excel.PrintSetup
  % PrintSetup XLSX-specific Print Setup
  
  properties
    cellComment
    orientation
    pageOrder
  end
  
  methods
    
    function out = get.cellComment(this)
      out = jl.office.excel.xlsx.PrintCellComments.ofJava(this.j.getCellComment);
    end
    
    function out = get.orientation(this)
      out = jl.office.excel.xlsx.PrintOrientation.ofJava(this.j.getOrientation);
    end
    
    function set.orientation(this, val)
      mustBeA(val, 'jl.office.excel.PrintOrientation');
      this.setOrientation(val.toJava);
    end
    
    function out = get.pageOrder(this)
      out = jl.office.excel.PageOrder.ofJava(this.j.getPageOrder);
    end
    
    function set.pageOrder(this, val)
      mustBeA(val, 'jl.office.excel.PageOrder');
      this.j.setPageOrder(val.toJava);
    end
    
  end
  
end

