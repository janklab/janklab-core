classdef PaneInformationPaneLocation < handle
  
  properties (SetAccess = private)
    jVal
  end
  
  enumeration
    LowerLeft(org.apache.poi.ss.util.PaneInformation.PANE_LOWER_LEFT)
    LowerRight(org.apache.poi.ss.util.PaneInformation.PANE_LOWER_RIGHT)
    UpperLeft(org.apache.poi.ss.util.PaneInformation.PANE_UPPER_LEFT)
    UpperRight(org.apache.poi.ss.util.PaneInformation.PANE_UPPER_RIGHT)
  end
  
  methods (Static)
    
    function out = ofJava(jVal)
      if isempty(jVal)
        out = [];
      elseif jVal == org.apache.poi.ss.util.PaneInformation.PANE_LOWER_LEFT
        out = jl.office.excel.PaneInformationPaneLocation.LowerLeft;
      elseif jVal == org.apache.poi.ss.util.PaneInformation.PANE_LOWER_RIGHT
        out = jl.office.excel.PaneInformationPaneLocation.LowerRight;
      elseif jVal == org.apache.poi.ss.util.PaneInformation.PANE_UPPER_LEFT
        out = jl.office.excel.PaneInformationPaneLocation.UpperLeft;
      elseif jVal == org.apache.poi.ss.util.PaneInformation.PANE_UPPER_RIGHT
        out = jl.office.excel.PaneInformationPaneLocation.UpperRight;
      else
        BADSWITCH
      end
    end
    
  end
  
  methods
    
    function out = toJava(this)
      out = this.jVal;
    end
    
  end
  
  methods (Access = private)
    
    function this = PaneInformationPaneLocation(jVal)
      this.jVal = jVal;
    end
    
  end
  
end