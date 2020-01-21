classdef Color
  % A Color in an Excel 97 XLS workbook
  
  properties
  end
  
  properties (Dependent)
    % A colon-delimited hex string representing this color's value
    hexString
    % Color standard palette index
    index
    % Alternative color standard palette index
    indexAlt
    % RGB triplet as a 3-long row vector ([R, G, B])
    rgbTriplet
  end
  
  methods (Static)
    
    function out = allColors
      % Get all the colors.
      %
      % Returns a containers.Map mapping integers to Color objects
      
    end
    
  end
  
  methods
    
    function this = Color(jObj)
      if nargin == 0
        return
      end
      mustBeA(jObj, 'org.apache.poi.hssf.util.HSSFColor');
      this.j = jObj;
    end
    
    function out = get.hexString(this)
      out = string(this.j.getHexString;
    end
    
    function out = get.index(this)
      out = this.j.getIndex;
    end
    
    function out = get.indexAlt(this)
      out = this.j.getIndex2;
    end
    
    function out = get.rgbTriplet(this)
      out = this.j.getTriplet;
    end
    
  end
  
end