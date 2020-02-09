classdef DataValidation < handle
  
  properties
    j
  end
  
  properties (Dependent)
    emptyCellAllowed
    errorBoxText
    errorBoxTitle
    errorStyle
    promptBoxText
    promptBoxTitle
    regions
    showErrorBox
    showPromptBox
    suppressDropDownArrow
    validationConstraint
  end
  
  
  methods
    
    function this = DataValidation(jObj)
      if nargin == 0
        return
      end
      mustBeA(jObj, 'org.apache.poi.ss.usermodel.DataValidation');
      this.j = jObj;
    end
    
    function out = get.emptyCellAllowed(this)
      out = this.j.getEmptyCellAllowed;
    end
    
    function set.emptyCellAllowed(this, val)
      this.j.setEmptyCellAllowed(val);
    end
    
    function out = get.errorBoxText(this)
      out = string(this.j.getErrorBoxText);
    end
    
    function set.errorBoxText(this, val)
      this.j.setErrorBoxText(val);
    end
    
    function out = get.errorBoxTitle(this)
      out = string(this.j.getErrorBoxTitle);
    end
    
    function set.errorBoxTitle(this, val)
      this.j.setErrorBoxTitle(val);
    end
    
    function out = get.errorStyle(this)
      out = this.j.getErrorStyle;
    end
    
    function set.errorStyle(this, val)
      this.j.setErrorStyle(val);
    end
    
    function out = get.promptBoxText(this)
      out = string(this.j.getPromptBoxText);
    end
    
    function set.promptBoxText(this, val)
      this.j.setPromptBoxText(val);
    end
    
    function out = get.promptBoxTitle(this)
      out = string(this.j.getPromptBoxTitle);
    end
    
    function set.promptBoxTitle(this, val)
      this.j.setPromptBoxtitle(val);
    end
    
    function out = get.regions(this)
      jRegions = this.j.getRegions;
      UNIMPLEMENTED
      % TODO: Implement CellRangeAddressList object
    end
    
    function out = get.validationConstraint(this)
      out = jl.office.excel.DataValidationConstraint(this.j.getValidationConstraint);
    end
    
  end
  
end

