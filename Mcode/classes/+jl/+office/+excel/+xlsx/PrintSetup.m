classdef PrintSetup < jl.office.excel.PrintSetup
  
  properties
    cellComment
  end
  
  methods
    
    function out = get.cellComment(this)
      out = jl.office.excel.xlsx.PrintCellComments.ofJava(this.j.getCellComment);
    end
    
  end
  
end

