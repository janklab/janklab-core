classdef (Abstract) ExtendedColor < jl.office.excel.Color
  
  properties (Dependent)
    argb
    argbHex
    index
    indexedRgb
    rgb
    rgbOrArgb
    rgbWithTint
    storedRgb
    theme
    tint
    isAuto
    isIndexed
    isRgb
    isThemed
  end
  
  methods
    
    function this = ExtendedColor(jObj)
      if nargin == 0
        return
      end
      mustBeA(jObj, 'org.apache.poi.ss.usermodel.ExtendedColor');
      this.j = jObj;
    end
    
    function out = get.argb(this)
      out = typecast(this.j.getARGB, 'uint8')';
    end
    
    function out = get.argbHex(this)
      out = string(this.j.getARGBHex);
    end
    
    function out = get.index(this)
      out = this.j.getIndex;
    end
    
    function out = get.indexedRgb(this)
      out = this.j.getIndexedRGB;
    end
    
    function out = get.rgb(this)
      out = typecast(this.j.getRGB, 'uint8')';
    end
    
    function out = get.rgbOrArgb(this)
      out = typecast(this.j.getRGBOrARGB, 'uint8')';
    end
    
    function out = get.rgbWithTint(this)
      out = typecast(this.j.getRGBWithTint, 'uint8')';
    end
    
    function out = get.storedRgb(this)
      %
      
      % Yes, this is a typo in the Apache POI API
      out = this.j.getStoredRBG;
    end
    
    function out = get.theme(this)
      out = this.j.getTheme;
    end
    
    function out = get.tint(this)
      out = this.j.getTint;
    end
    
    function out = get.isAuto(this)
      out = this.j.isAuto;
    end
    
    function out = get.isIndexed(this)
      out = this.j.isIndexed;
    end
    
    function out = get.isRgb(this)
      out = this.j.isRGB;
    end
    
    function out = get.isThemed(this)
      out = this.j.isThemed;
    end
    
    function set.argbHex(this, val)
      this.j.setARGBHex(val);
    end
    
    function setColor(this, javaColor)
      % setColor Set the color from a Java Color object.
      %
      % setColor(obj, javaColor)
      %
      % JavaColor must be a Java java.awt.Color object. We may change this to
      % accept additional input types in the future. But Matlab has no
      % native color object, so it's unclear what types we would accept.
      %
      mustBeA(javaColor, 'java.awt.Color');
      this.j.setColor(javaColor);
    end
    
    function set.rgb(this, val)
      this.j.setRGB(val);
    end
    
    function set.tint(this, val)
      this.setTint(val);
    end
    
    function set.theme(this, val)
      % Set the theme
      %
      % It is a hack that this is defined on ExtendedColor instead of
      % jl.office.excel.xlsx.Color. It will only work on
      % jl.office.excel.xlsx.Color objects.
      this.j.setTheme(val);
    end
    
  end
  
end