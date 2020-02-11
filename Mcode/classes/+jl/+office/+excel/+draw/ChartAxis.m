classdef ChartAxis < handle
  
  properties (SetAccess = private)
    j
  end
  properties (Dependent)
    id
    logBase
    logBaseIsSet
    majorTickMark
    maximum
    maximumIsSet
    minimum
    minimumIsSet
    minorTickMark
    numberFormat
    numberFormatIsSet
    orientation
    position
    visible
  end
  
  methods
    
    function this = ChartAxis(jObj)
      if nargin == 0
        return
      end
      mustBeA(jObj, 'org.apache.poi.ss.usermodel.ChartAxis');
      this.j = jObj;
    end
    
    function out = get.id(this)
      out = this.j.getId;
    end
    
    function out = get.logBase(this)
      out = this.j.getLogBase;
    end
    
    function set.logBase(this, val)
      this.j.setLogBase(val);
    end
    
    function out = get.logBaseIsSet(this)
      out = this.j.isSetLogBase;
    end
    
    function out = get.majorTickMark(this)
      jObj = this.j.getMajorTickMark;
      out = jl.office.excel.draw.AxisTickMark.ofJava(jObj);
    end
    
    function set.majorTickMark(this, val)
      mustBeA(val, 'jl.office.excel.draw.AxisTickMark');
      this.j.setMajorTickMark(val.j);
    end
    
    function out = get.minorTickMark(this)
      jObj = this.j.getMinorTickMark;
      out = jl.office.excel.draw.AxisTickMark.ofJava(jObj);
    end
    
    function set.minorTickMark(this, val)
      mustBeA(val, 'jl.office.excel.draw.AxisTickMark');
      this.j.setMinorTickMark(val.j);
    end
    
    function out = get.maximum(this)
      out = this.j.getMaximum;
    end
    
    function set.maximum(this, val)
      this.j.setMaximum(val);
    end
    
    function out = get.maximumIsSet(this)
      out = this.j.isSetMaximum;
    end
    
    function out = get.minimum(this)
      out = this.j.getMinimum;
    end
    
    function set.minimum(this, val)
      this.j.setMinimum(val);
    end
    
    function out = get.minimumIsSet(this)
      out = this.j.isSetMinimum;
    end
    
    function out = get.numberFormat(this)
      out = string(this.j.getNumberFormat);
    end
    
    function set.numberFormat(this, val)
      this.j.setNumberFormat(val);
    end
    
    function out = get.numberFormatIsSet(this)
      out = this.j.hasNumberFormat;
    end
    
    function out = get.orientation(this)
      jObj = this.j.getOrientation;
      out = jl.office.excel.draw.AxisOrientation.ofJava(jObj);
    end
    
    function set.orientation(this, val)
      mustBeA(val, 'jl.office.excel.draw.AxisOrientation');
      this.j.setOrientation(val.j);
    end
    
    function out = get.position(this)
      jObj = this.j.getPosition;
      out = jl.office.excel.draw.AxisPosition(jObj);
    end
    
    function set.position(this, val)
      mustBeA(val, 'jl.office.excel.draw.AxisPosition');
      this.j.setPosition(val.j);
    end
    
    function out = get.visible(this)
      out = this.j.isVisible;
    end
    
    function set.visible(this, val)
      this.j.setVisible(val);
    end
    
    function out = getCrosses(this)
      out = jl.office.excel.draw.AxisCrosses.ofJava(this.j.getCrosses);
    end
    
  end
  
end