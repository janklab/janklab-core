classdef ConditionFilterData < handle
  
  properties
    j
  end
  properties (Dependent)
    aboveAverage
    bottom
    equalAverage
    percent
    rank
    stdDev
  end
  
  methods
    
    function this = ConditionalFormattingRule(jObj)
      if nargin == 0
        return
      end
      mustBeA(jObj, 'org.apache.poi.ss.usermodel.ConditionFilterData');
      this.j = jObj;
    end
    
    function out = get.aboveAverage(this)
      out = this.j.getAboveAverage;
    end
    
    function out = get.bottom(this)
      out = this.j.getBottom;
    end
    
    function out = get.equalAverage(this)
      out = this.j.getEqualAverage;
    end
    
    function out = get.percent(this)
      out = this.j.getPercent;
    end
    
    function out = get.rank(this)
      out = this.j.getRank;
    end
    
    function out = get.stdDev(this)
      out = this.j.getStdDev;
    end
    
  end
  
end

