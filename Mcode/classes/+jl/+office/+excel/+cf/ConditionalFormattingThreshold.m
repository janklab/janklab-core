classdef ConditionalFormattingThreshold < handle
  %CONDITIONALFORMATTINGTHRESHOLD
  
  %#ok<*INUSL>
  
  properties
    j
  end
  
  properties (Dependent)
    formula
    rangeType
    value
  end
  
  methods
    
    function this = ConditionalFormattingThreshold(jObj)
      if nargin == 0
        return
      end
      mustBeA(jObj, 'org.apache.poi.ss.usermodel.ConditionalFormattingThreshold');
      this.j = jObj;
    end
    
    function out = get.formula(this)
      out = string(this.j.getFormula);
    end
    
    function set.formula(this, val)
      this.j.setFormula(val);
    end
    
    function out = get.rangeType(this)
      out = this.wrapRangeTypeObject(this.j.getRangeType);
    end
    
    function set.rangeType(this, val)
      mustBeA(val, 'jl.office.excel.cf.ConditionalFormattingThresholdRangeType');
      this.j.setRangeType(val.j);
    end
    
    function out = get.value(this)
      out = this.j.getValue;
    end
    
    function set.value(this, val)
      this.j.setValue(val);
    end
    
  end
  
  methods (Access = protected)
    
    function out = wrapRangeTypeObject(this, jObj)
      out = jl.office.excel.cf.ConditionalFormattingThresholdRangeType.ofJava(jObj);
    end
    
  end
  
end

