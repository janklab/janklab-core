classdef Color < jl.office.excel.ExtendedColor
  % Color A color in an XLSX (Office 2003) workbook
  
  properties (Constant, Hidden)
    ValidColorConstants = ["Black" "blue" "Cyan" "DarkGray" "Gray" ...
      "Green" "LightGray" "Magenta" "Orange" "Pink" "Red" "White" "Yellow"];
  end
  
  properties (Constant)
    Black = jl.office.excel.xlsx.Color.ofAwtColor(java.awt.Color.black)
    Blue = jl.office.excel.xlsx.Color.ofAwtColor(java.awt.Color.blue)
    Cyan = jl.office.excel.xlsx.Color.ofAwtColor(java.awt.Color.cyan)
    DarkGray = jl.office.excel.xlsx.Color.ofAwtColor(java.awt.Color.darkGray)
    Gray = jl.office.excel.xlsx.Color.ofAwtColor(java.awt.Color.gray)
    Green = jl.office.excel.xlsx.Color.ofAwtColor(java.awt.Color.green)
    LightGray = jl.office.excel.xlsx.Color.ofAwtColor(java.awt.Color.lightGray)
    Magenta = jl.office.excel.xlsx.Color.ofAwtColor(java.awt.Color.magenta)
    Orange = jl.office.excel.xlsx.Color.ofAwtColor(java.awt.Color.orange)
    Pink = jl.office.excel.xlsx.Color.ofAwtColor(java.awt.Color.pink)
    Red = jl.office.excel.xlsx.Color.ofAwtColor(java.awt.Color.red)
    White = jl.office.excel.xlsx.Color.ofAwtColor(java.awt.Color.white)
    Yellow = jl.office.excel.xlsx.Color.ofAwtColor(java.awt.Color.yellow)
  end
  
  methods (Static)
    
    function out = ofWhatever(in)
      % Convert color specifications of various types to Color objects
      if isa(in, 'jl.office.excel.xlsx.Color')
        out = in;
      elseif isnumeric(in)
        out = jl.office.excel.xlsx.Color.ofRgb(in);
      elseif isstringy(in)
        error('String color definitions are not supported yet');
      elseif isa(in, 'java.awt.Color')
        out = jl.office.excel.xlsx.Color.ofAwtColor(in);
      else
        error('jl:InvalidInput', 'Invalid type for XLSX Color: %s', ...
          class(in));
      end
    end
    
    function out = ofRgb(rgb)
      % Create a Color from RGB values
      %
      % out = jl.office.excel.xlsx.Color.ofRgb(rgb)
      %
      % rgb must be a 3- or 4-long vector of either:
      %   * an integer array holding values between 0 and 255.
      %   * a single or double array holding values betwen 0.0 and 1.0.
      % The elements of this vector represent the byte-sized R, G, and B, and
      % (optionally) alpha components of this color. If the values are out
      % of range, they will get rounded.
      %
      mustBeNumeric(rgb);
      if ~ismember(numel(rgb), [3 4])
        error('jl:InvalidInput', 'rgb must be 3 or 4 elements long; got %d elements', ...
          numel(rgb));
      end
      if isinteger(rgb)
        if any(rgb > 255 | rgb < 0)
          error('RGB values out of range (must be between 0 and 255; got: %s)', ...
            dispstr(rgb));
        end
        rgb = int16(uint8(rgb));
      else
        if ~isreal(rgb)
          error('RGB values may not have imaginary components');
        end
        if any(isnan(rgb) | isinf(rgb))
          error('RGB values may not be NaN or Inf; got %s', dispstr(rgb));
        end
        if any(rgb > 1.0 | rgb < 0.0)
          error('RGB values out of range (must be between 0.0 and 1.0; got: %s)', ...
            dispstr(rgb));
        end
        rgb = single(rgb);
      end
      if numel(rgb) == 3
        awtColor = java.awt.Color(rgb(1), rgb(2), rgb(3));
      else
        awtColor = java.awt.Color(rgb(1), rgb(2), rgb(3), rgb(4));
      end
      out = jl.office.excel.xlsx.Color.ofAwtColor(awtColor);
    end
    
    function out = ofRgbHex(hex)
      mustBeStringy(hex);
      hex = char(hex);
      if ~ismember(numel(hex), [6 8])
        error('hex string must be 6 or 8 characters long; got %d-long', ...
          numel(hex));
      end
      r = uint8(hex2dec(hex(1:2)));
      g = uint8(hex2dec(hex(3:4)));
      b = uint8(hex2dec(hex(5:6)));
      if numel(hex) == 8
        a = uint8(hex2dec(hex(7:8)));
        out = jl.office.excel.xlsx.Color.ofRgb([r g b a]);
      else
        out = jl.office.excel.xlsx.Color.ofRgb([r g b]);
      end
    end
    
    function out = ofColorName(name)
      mustBeStringy(name);
      switch lower(name)
        case "black"
          out = jl.office.excel.xlsx.Color.Black;
        case "blue"
          out = jl.office.excel.xlsx.Color.Blue;
        case "cyan"
          out = jl.office.excel.xlsx.Color.Cyan;
        case "darkgray"
          out = jl.office.excel.xlsx.Color.DarkGray;
        case "gray"
          out = jl.office.excel.xlsx.Color.Gray;
        case "green"
          out = jl.office.excel.xlsx.Color.Green;
        case "lightgray"
          out = jl.office.excel.xlsx.Color.LightGray;
        case "magenta"
          out = jl.office.excel.xlsx.Color.Magenta;
        case "orange"
          out = jl.office.excel.xlsx.Color.Orange;
        case "pink"
          out = jl.office.excel.xlsx.Color.Pink;
        case "red"
          out = jl.office.excel.xlsx.Color.Red;
        case "white"
          out = jl.office.excel.xlsx.Color.White;
        case "yellow"
          out = jl.office.excel.xlsx.Color.Yellow;
        otherwise
          error('Unknown color name: %s', name);
      end
    end
    
  end
  
  methods (Static, Access = private)
    
    function out = ofAwtColor(awtColor)
      jColor = org.apache.poi.xssf.usermodel.XSSFColor(awtColor);
      out = jl.office.excel.xlsx.Color(jColor);
    end
    
  end
  
  methods
    
    function this = Color(jObj)
      if nargin == 0
        return
      end
      mustBeA(jObj, 'org.apache.poi.xssf.usermodel.XSSFColor');
      this.j = jObj;
    end
    
    function out = hasAlpha(this)
      out = this.j.hasAlpha;
    end
    
    function out = hasTint(this)
      out = this.j.hasTint;
    end
    
    function setAuto(this, val)
      this.j.setAuto(val);
    end
    
    function setIndexed(this, val)
      this.j.setIndexed(val);
    end
    
  end
  
  methods (Access = protected)
    
    function out = dispstr_scalar(this)
      hex = char(this.argbHex);
      rgbHex = hex(1:6);
      if this.hasAlpha
        alphaHex = hex(7:8);
        out = sprintf('[Color: #%s alpha=%s (%s)]', ...
          rgbHex, alphaHex, dispstr(this.rgb));
      else
        out = sprintf('[Color: #%s (%s)]', rgbHex, dispstr(this.rgb));
      end
    end
    
  end
  
end