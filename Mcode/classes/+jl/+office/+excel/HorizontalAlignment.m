classdef HorizontalAlignment < jl.util.Displayable
  
  enumeration
    Center("Center")
    CenterSelection("CenterSelection")
    Distributed("Distributed")
    Fill("Fill")
    General("General")
    Justify("Justify")
    Left("Left")
    Right("Right")
  end
  
  properties (SetAccess = immutable)
    name string
  end

  methods (Static)
    
    function out = ofJava(jObj)
      if isempty(jObj)
        out = [];
      elseif ~isa(jObj, 'org.apache.poi.ss.usermodel.HorizontalAlignment')
        error('jl:InvalidInput', 'jObj must be a org.apache.poi.ss.usermodel.HorizontalAlignment; got a %s', ...
          class(jObj));
      elseif jObj.equals(org.apache.poi.ss.usermodel.HorizontalAlignment.CENTER)
        out = jl.office.excel.HorizontalAlignment.Center;
      elseif jObj.equals(org.apache.poi.ss.usermodel.HorizontalAlignment.CENTER_SELECTION)
        out = jl.office.excel.HorizontalAlignment.CenterSelection;
      elseif jObj.equals(org.apache.poi.ss.usermodel.HorizontalAlignment.DISTRIBUTED)
        out = jl.office.excel.HorizontalAlignment.Distributed;
      elseif jObj.equals(org.apache.poi.ss.usermodel.HorizontalAlignment.FILL)
        out = jl.office.excel.HorizontalAlignment.Fill;
      elseif jObj.equals(org.apache.poi.ss.usermodel.HorizontalAlignment.GENERAL)
        out = jl.office.excel.HorizontalAlignment.General;
      elseif jObj.equals(org.apache.poi.ss.usermodel.HorizontalAlignment.JUSTIFY)
        out = jl.office.excel.HorizontalAlignment.Justify;
      elseif jObj.equals(org.apache.poi.ss.usermodel.HorizontalAlignment.LEFT)
        out = jl.office.excel.HorizontalAlignment.Left;
      elseif jObj.equals(org.apache.poi.ss.usermodel.HorizontalAlignment.RIGHT)
        out = jl.office.excel.HorizontalAlignment.Right;
      else
        error('jl:InvalidInput', 'Unrecognized HorizontalAlignment value: %s', ...
          string(jObj.toString));
      end
    end
    
  end
  
  methods
    
    function out = toJava(this)
      if this == jl.office.excel.HorizontalAlignment.Center
        out = org.apache.poi.ss.usermodel.HorizontalAlignment.CENTER;
      elseif this == jl.office.excel.HorizontalAlignment.CenterSelection
        out = org.apache.poi.ss.usermodel.HorizontalAlignment.CENTER_SELECTION;
      elseif this == jl.office.excel.HorizontalAlignment.Distributed
        out = org.apache.poi.ss.usermodel.HorizontalAlignment.DISTRIBUTED;
      elseif this == jl.office.excel.HorizontalAlignment.Fill
        out = org.apache.poi.ss.usermodel.HorizontalAlignment.FILL;
      elseif this == jl.office.excel.HorizontalAlignment.General
        out = org.apache.poi.ss.usermodel.HorizontalAlignment.GENERAL;
      elseif this == jl.office.excel.HorizontalAlignment.Justify
        out = org.apache.poi.ss.usermodel.HorizontalAlignment.JUSTIFY;
      elseif this == jl.office.excel.HorizontalAlignment.Left
        out = org.apache.poi.ss.usermodel.HorizontalAlignment.LEFT;
      elseif this == jl.office.excel.HorizontalAlignment.Right
        out = org.apache.poi.ss.usermodel.HorizontalAlignment.RIGHT;
      else
        BADSWITCH
      end
    end
    
  end
  
  methods (Access = private)
    
    function this = HorizontalAlignment(name)
      this.name = name;
    end
    
  end
  
  methods (Access = protected)
    
    function out = dispstr_scalar(this)
      out = sprintf('[HorizontalAlignment: %s]', this.name);
    end
    
  end
  
end