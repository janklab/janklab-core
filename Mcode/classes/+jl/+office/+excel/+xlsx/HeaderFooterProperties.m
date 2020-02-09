classdef HeaderFooterProperties < handle
  
  properties
    j
  end
  
  properties (Dependent)
    alignWithMargins
    differentFirst
    differentOddEven
    scaleWithDoc
  end
  
  methods
    
    function this = HeaderFooterProperties(jObj)
      if nargin == 0
        return
      end
      mustBeA(jObj, 'org.apache.poi.xssf.usermodel.XSSFHeaderFooterProperties');
      this.j = jObj;
    end
    
    function out = get.alignWithMargins(this)
      out = this.j.getAlignWithMargins;
    end
    
    function out = get.differentFirst(this)
      out = this.j.getDifferentFirst;
    end
    
    function out = get.differentOddEven(this)
      out = this.j.getDifferentOddEven;
    end
    
    function out = get.scaleWithDoc(this)
      out = this.j.getScaleWithDoc;
    end
    
    function set.alignWithMargins(this, val)
      this.j.setAlignWithMargins(val);
    end
    
    function set.differentFirst(this, val)
      this.j.setDifferentFirst(val);
    end
    
    function set.differentOddEven(this, val)
      this.j.setDifferentOddEven(val);
    end
    
    function set.scaleWithDoc(this, val)
      this.j.setScaleWithDoc(val);
    end
    
    function removeAlignWithMargins(this)
      this.j.removeAlignWithMargins;
    end
    
    function removeDifferentFirst(this)
      this.j.removeDifferentFirst;
    end
    
    function removeDifferentOddEven(this)
      this.j.removeDifferentOddEven;
    end
    
    function removeScaleWithDoc(this)
      this.j.removeScaleWithDoc;
    end
    
  end
  
end