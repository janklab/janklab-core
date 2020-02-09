classdef PrintCellComments

  properties
    j
  end
  
  enumeration
    AsDisplayed(org.apache.poi.ss.usermodel.PrintCellComments.AS_DISPLAYED)
    AtEnd(org.apache.poi.ss.usermodel.PrintCellComments.AT_END)
    None(org.apache.poi.ss.usermodel.PrintCellComments.NONE)
  end
  
  methods (Static)
    
    function out = ofJava(jObj)
      if isempty(jObj)
        out = [];
      elseif jObj.equals(org.apache.poi.ss.usermodel.PrintCellComments.AS_DISPLAYED)
        out = jl.office.excel.xlsx.PrintCellComments.AsDisplayed;
      elseif jObj.equals(org.apache.poi.ss.usermodel.PrintCellComments.AT_END)
        out = jl.office.excel.xlsx.PrintCellComments.AtEnd;
      elseif jObj.equals(org.apache.poi.ss.usermodel.PrintCellComments.NONE)
        out = jl.office.excel.xlsx.PrintCellComments.None;
      else
        BADSWITCH
      end
    end
    
  end
  
  methods
    
    function out = toJava(this)
      out = this.j;
    end
    
  end
  
  methods (Access = private)
    
    function this = PrintCellComments(jObj)
      this.j = jObj;
    end
    
  end
  
end

