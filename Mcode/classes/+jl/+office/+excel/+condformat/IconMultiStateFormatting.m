classdef IconMultiStateFormatting < handle
  %ICONMULTISTATEFORMATTING 
  
  properties
    j
  end
  
  properties (Dependent)
    iconSet
    thresholds
    iconOnly
    reversed
  end
  
  methods
    
    function this = IconMultiStateFormatting(jObj)
      if nargin == 0
        return
      end
      mustBeA(jObj, 'org.apache.poi.ss.usermodel.IconMultiStateFormatting');
      this.j = jObj;
    end
        
    function out = get.iconSet(this)
      out = jl.office.excel.condformat.IconMultiStateFormattingIconSet.ofJava(this.getIconSet);
    end
    
    function set.iconSet(this, val)
      mustBeA(val, 'jl.office.excel.condformat.IconMultiStateFormattingIconSet');
      this.j.setIconSet(val.j);
    end
    
    function out = get.thresholds(this)
      out = jl.office.excel.condformat.ConditionalFormattingThreshold(this.j.getThresholds);
    end
    
    function set.thresholds(this, val)
      mustBeA(val, 'jl.office.excel.condformat.ConditionalFormattingThreshold');
      this.j.setThresholds(val.toJavaArray);
    end
    
    function out = get.iconOnly(this)
      out = this.j.isIconOnly;
    end
    
    function set.iconOnly(this, val)
      this.j.setIconOnly(val);
    end
    
    function out = get.reversed(this)
      out = this.j.isReversed;
    end
    
    function set.reversed(this, val)
      this.j.setReversed(val);
    end
    
  end
  
end

