classdef BorderStyle < jl.util.Displayable
  
  enumeration
    DashDot('DashDot')
    DashDotDot('DashDotDot')
    Dashed('Dashed')
    Dotted('Dotted')
    Double('Double')
    Hair('Hair')
    Medium('Medium')
    MediumDashDot('MediumDashDot')
    MediumDashDotDot('MediumDashDotDot')
    MediumDashed('MediumDashed')
    None('None')
    SlantedDashDot('SlantedDashDot')
    Thick('Thick')
    Thin('Thin')
  end
  
  properties (SetAccess = immutable)
    name
  end
  
  methods (Static)
    
    function out = ofJava(jObj)
      if isempty(jObj)
        out = [];
      elseif ~isa(jObj, 'org.apache.poi.ss.usermodel.BorderStyle')
        error('jl:InvalidInput', 'jObj must be a org.apache.poi.ss.usermodel.BorderStyle; got a %s', ...
          class(jObj));
      elseif jObj.equals(org.apache.poi.ss.usermodel.BorderStyle.DASH_DOT)
        out = jl.office.excel.BorderStyle.DashDot;
      elseif jObj.equals(org.apache.poi.ss.usermodel.BorderStyle.DASH_DOT_DOT)
        out = jl.office.excel.BorderStyle.DashDotDot;
      elseif jObj.equals(org.apache.poi.ss.usermodel.BorderStyle.DASHED)
        out = jl.office.excel.BorderStyle.Dashed;
      elseif jObj.equals(org.apache.poi.ss.usermodel.BorderStyle.DOTTED)
        out = jl.office.excel.BorderStyle.Dotted;
      elseif jObj.equals(org.apache.poi.ss.usermodel.BorderStyle.DOUBLE)
        out = jl.office.excel.BorderStyle.Double;
      elseif jObj.equals(org.apache.poi.ss.usermodel.BorderStyle.HAIR)
        out = jl.office.excel.BorderStyle.Hair;
      elseif jObj.equals(org.apache.poi.ss.usermodel.BorderStyle.MEDIUM)
        out = jl.office.excel.BorderStyle.Medium;
      elseif jObj.equals(org.apache.poi.ss.usermodel.BorderStyle.MEDIUM_DASH_DOT)
        out = jl.office.excel.BorderStyle.MediumDashDot;
      elseif jObj.equals(org.apache.poi.ss.usermodel.BorderStyle.MEDIUM_DASH_DOT_DOT)
        out = jl.office.excel.BorderStyle.MediumDashDotDot;
      elseif jObj.equals(org.apache.poi.ss.usermodel.BorderStyle.MEDIUM_DASHED)
        out = jl.office.excel.BorderStyle.MediumDashed;
      elseif jObj.equals(org.apache.poi.ss.usermodel.BorderStyle.NONE)
        out = jl.office.excel.BorderStyle.None;
      elseif jObj.equals(org.apache.poi.ss.usermodel.BorderStyle.SLANTED_DASH_DOT)
        out = jl.office.excel.BorderStyle.SlantedDashDot;
      elseif jObj.equals(org.apache.poi.ss.usermodel.BorderStyle.THICK)
        out = jl.office.excel.BorderStyle.Thick;
      elseif jObj.equals(org.apache.poi.ss.usermodel.BorderStyle.THIN)
        out = jl.office.excel.BorderStyle.Thin;
      else
        error('jl:InvalidInput', 'Invalid border style: %s', dispstr(jObj));
      end
    end
    
  end
  
  methods
    
    function out = toJava(this)
      if this == jl.office.excel.BorderStyle.DashDot
        out = org.apache.poi.ss.usermodel.BorderStyle.DASH_DOT;
      elseif this == jl.office.excel.BorderStyle.DashDotDot
        out = org.apache.poi.ss.usermodel.BorderStyle.DASH_DOT_DOT;
      elseif this == jl.office.excel.BorderStyle.Dashed
        out = org.apache.poi.ss.usermodel.BorderStyle.DASHED;
      elseif this == jl.office.excel.BorderStyle.Dotted
        out = org.apache.poi.ss.usermodel.BorderStyle.DOTTED;
      elseif this == jl.office.excel.BorderStyle.Double
        out = org.apache.poi.ss.usermodel.BorderStyle.DOUBLE;
      elseif this == jl.office.excel.BorderStyle.Hair
        out = org.apache.poi.ss.usermodel.BorderStyle.HAIR;
      elseif this == jl.office.excel.BorderStyle.Medium
        out = org.apache.poi.ss.usermodel.BorderStyle.MEDIUM;
      elseif this == jl.office.excel.BorderStyle.MediumDashDotDot
        out = org.apache.poi.ss.usermodel.BorderStyle.MEDIUM_DASH_DOT;
      elseif this == jl.office.excel.BorderStyle.MediumDashed
        out = org.apache.poi.ss.usermodel.BorderStyle.MEDIUM_DASHED;
      elseif this == jl.office.excel.BorderStyle.None
        out = org.apache.poi.ss.usermodel.BorderStyle.NONE;
      elseif this == jl.office.excel.BorderStyle.SlantedDashDot
        out = org.apache.poi.ss.usermodel.BorderStyle.SLANTED_DASH_DOT;
      elseif this == jl.office.excel.BorderStyle.Thick
        out = org.apache.poi.ss.usermodel.BorderStyle.THICK;
      elseif this == jl.office.excel.BorderStyle.Thin
        out = org.apache.poi.ss.usermodel.BorderStyle.THIN;
      else
        BADSWITCH
      end
    end
    
  end
  
  methods (Access = private)
  
    function this = BorderStyle(name)
      this.name = name;
    end
    
  end
  
  methods (Access = protected)
    
    function out = dispstr_scalar(this)
      out = sprintf('[BorderStyle: %s]', this.name);
    end
    
  end
  
end