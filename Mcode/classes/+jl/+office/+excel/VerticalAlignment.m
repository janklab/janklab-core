classdef VerticalAlignment < jl.util.Displayable
  % Indicates the type of vertical alignment for a cell
  
  enumeration
    % Aligned to the bottom of the cell
    Bottom("Bottom")
    % Centered across the height of the cell
    Center("Center")
    % When text direction is horizontal: the vertical alignment of lines of text
    % is distributed vertically, where each line of text inside the cell is
    % evenly distributed across the height of the cell, with flush top
    Distributed("Distributed")
    % When text direction is horizontal: the vertical alignment of lines of text
    % is distributed vertically, where each line of text inside the cell is
    % evenly distributed across the height of the cell, with flush top and
    % bottom margins.
    Justify("Justify")
    % Aligned to the top of the cell
    Top("Top")
  end
  
  properties (SetAccess = immutable)
    name string
  end

  methods (Static)
    
    function out = ofJava(jObj)
      if isempty(jObj)
        out = [];
      elseif ~isa(jObj, 'org.apache.poi.ss.usermodel.VerticalAlignment')
        error('jObj must be a org.apache.poi.ss.usermodel.VerticalAlignment; got a %s', ...
          class(jObj));
      elseif jObj.equals(org.apache.poi.ss.usermodel.VerticalAlignment.BOTTOM)
        out = jl.office.excel.VerticalAlignment.Bottom;
      elseif jObj.equals(org.apache.poi.ss.usermodel.VerticalAlignment.CENTER)
        out = jl.office.excel.VerticalAlignment.Center;
      elseif jObj.equals(org.apache.poi.ss.usermodel.VerticalAlignment.DISTRIBUTED)
        out = jl.office.excel.VerticalAlignment.Distributed;
      elseif jObj.equals(org.apache.poi.ss.usermodel.VerticalAlignment.JUSTIFY)
        out = jl.office.excel.VerticalAlignment.Justify;
      elseif jObj.equals(org.apache.poi.ss.usermodel.VerticalAlignment.TOP)
        out = jl.office.excel.VerticalAlignment.Top;
      else
        error('jl:InvalidInput', 'Unrecognized VerticalAlignment value: %s', ...
          string(jObj.toString));
      end
    end
    
  end
  
  methods
    
    function out = toJava(this)
      if this == jl.office.excel.VerticalAlignment.Bottom
        out = org.apache.poi.ss.usermodel.VerticalAlignment.BOTTOM;
      elseif this == jl.office.excel.VerticalAlignment.Center
        out = org.apache.poi.ss.usermodel.VerticalAlignment.CENTER;
      elseif this == jl.office.excel.VerticalAlignment.Distributed
        out = org.apache.poi.ss.usermodel.VerticalAlignment.DISTRIBUTED;
      elseif this == jl.office.excel.VerticalAlignment.Justify
        out = org.apache.poi.ss.usermodel.VerticalAlignment.JUSTIFY;
      elseif this == jl.office.excel.VerticalAlignment.Top
        out = org.apache.poi.ss.usermodel.VerticalAlignment.TOP;
      else
        BADSWITCH
      end
    end
    
  end
  
  methods (Access = private)
    
    function this = VerticalAlignment(name)
      this.name = name;
    end
    
  end
  
  methods (Access = protected)
    
    function out = dispstr_scalar(this)
      out = sprintf('[VerticalAlignment: %s]', this.name);
    end
    
  end
    
end