classdef PaneInformation < handle
% PaneInformation

  properties (SetAccess = private)
    % The underlying POI org.apache.poi.ss.usermodel.PaneInformation Java object
    j
  end

  properties (Dependent)
    activePane
    horizontalSplitPosition
    horizontalSplitTopRow
    verticalSplitLeftColumn
    verticalSplitPosition
    isFreezePane
  end
  
  methods

    function this = PaneInformation(jObj)
      if nargin == 0
        return
      end
      mustBeA(jObj, 'org.apache.poi.ss.usermodel.PaneInformation');
      this.j = jObj;
    end
    
    function out = get.activePane(this)
      jVal = this.j.getActivePane;
      out = jl.office.excel.PaneInformationPaneLocation.ofJava(jVal);
    end
    
    function out = get.horizontalSplitPosition(this)
      out = this.j.getHorizontalSplitPosition;
    end
    
    function out = get.horizontalSplitTopRow(this)
      out = this.j.getHorizontalSplitTopRow;
    end
    
    function out = get.verticalSplitLeftColumn(this)
      out = this.j.getVerticalSplitLeftColumn;
    end
    
    function out = get.verticalSplitPosition(this)
      out = this.j.getVerticalSplitPosition;
    end
    
    function out = get.isFreezePane(this)
      out = this.j.isFreezePane;
    end

  end

end
