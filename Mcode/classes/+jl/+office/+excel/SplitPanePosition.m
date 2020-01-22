classdef SplitPanePosition
  
  enumeration
    LowerLeft
    LowerRight
    UpperLeft
    UpperRight
  end
  
  methods (Static)
    
    function out = ofJava(val)
      if isempty(val)
        out = [];
        return
      end
      switch val
        case org.apache.poi.ss.usermodel.Sheet.PANE_LOWER_LEFT
          out = jl.office.excel.SplitPanePosition.LowerLeft;
        case org.apache.poi.ss.usermodel.Sheet.PANE_LOWER_RIGHT
          out = jl.office.excel.SplitPanePosition.LowerRight;
        case org.apache.poi.ss.usermodel.Sheet.PANE_UPPER_LEFT
          out = jl.office.excel.SplitPanePosition.UpperLeft;
        case org.apache.poi.ss.usermodel.Sheet.PANE_UPPER_RIGHT
          out = jl.office.excel.SplitPanePosition.UpperRight;
        otherwise
          BADSWITCH
      end
    end
    
  end
  
  methods
    
    function out = toJava(this)
      if this == jl.office.excel.SplitPanePosition.LowerLeft
        out = org.apache.poi.ss.usermodel.Sheet.PANE_LOWER_LEFT;
      elseif this == jl.office.excel.SplitPanePosition.LowerRight
        out = org.apache.poi.ss.usermodel.Sheet.PANE_LOWER_RIGHT;
      elseif this == jl.office.excel.SplitPanePosition.UpperLeft
        out = org.apache.poi.ss.usermodel.Sheet.PANE_UPPER_LEFT;
      elseif this == jl.office.excel.SplitPanePosition.UpperRight
        out = org.apache.poi.ss.usermodel.Sheet.PANE_UPPER_RIGHT;
      else
        BADSWITCH
      end
    end
    
  end
  
end
          