classdef Color < jl.office.excel.Color
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
      % Get all the colors in the standard palette, in an array.
      %
      % out = jl.office.excel.xls.Color.allColors()
      %
      % Gets all the colors, in an array where out(i) contains the Color for
      % palette index i (using standard palette indexes). Some elements of the
      % array may be empty. The returned palette array will typically be about
      % 64 long, with the first few elements and maybe the last couple being
      % empty; I don't know if that's always the case or if that's
      % state-dependent. YMMV.
      %
      % Returns an array of j.office.excel.xls.Color objects.
      jColors = org.apache.poi.hssf.util.HSSFColor.getIndexHash;
      %out = containers.Map('KeyType','double', 'ValueType','jl.office.excel.xls.Color');
      out = repmat(jl.office.excel.xls.Color, [1 64]);
      it = jColors.entrySet.iterator;
      while it.hasNext
        entry = it.next;
        out(entry.getKey) = jl.office.excel.xls.Color(entry.getValue);
      end
    end
    
    function out = allColorsTable
      % List all the colors in the standard palette, in a table
      %
      % Lists the definitions for all the colors in the standard palette, in a
      % Matlab table array.
      %
      % Returns a table array with columns:
      %  color - the Color object
      %  index
      %  indexAlt
      %  r
      %  g
      %  b
      %  hexString
      allColors = jl.office.excel.xls.Color.allColors;
      tb = jl.util.TableBuffer({'color','index','indexAlt','r','g','b','hexString'});
      for i = 1:numel(allColors)
        c = allColors(i);
        if ismissing(c)
          continue
        end
        rgb = c.rgbTriplet;
        tb = tb.addRow({c, c.index, c.indexAlt, rgb(1), rgb(2), ...
          rgb(3), c.hexString});
      end
      out = table(tb);
      out = sortrows(out, {'index'}, 'ascend');
    end
  end
  
  methods
    
    function this = Color(jObj)
      if nargin == 0 || isempty(jObj)
        return
      end
      mustBeA(jObj, 'org.apache.poi.hssf.util.HSSFColor');
      this.j = jObj;
    end
    
    function out = get.hexString(this)
      out = repmat(string(missing), size(this));
      for i = 1:numel(this)
        if ~isempty(this(i).j)
          out(i) = this(i).j.getHexString;
        end
      end
    end
    
    function out = get.index(this)
      out = NaN(size(this));
      for i = 1:numel(this)
        if ~isempty(this(i).j)
          out(i) = this(i).j.getIndex;
        end
      end
    end
    
    function out = get.indexAlt(this)
      out = NaN(size(this));
      for i = 1:numel(this)
        if ~isempty(this(i).j)
          out(i) = this(i).j.getIndex2;
        end
      end
    end
    
    function out = get.rgbTriplet(this)
      out = this.j.getTriplet;
    end
    
    function out = ismissing(this)
      out = false(size(this));
      for i = 1:numel(this)
        out(i) = isempty(this(i).j);
      end
    end
    
  end
  
  methods (Access = protected)
    
    function out = dispstr_scalar(this)
      if isempty(this.j)
        out = '[xls.Color: null]';
        return
      end
      rgb = this.rgbTriplet;
      out = sprintf('[xls.Color: index=%d indexAlt=%d rgbTriplet=[%d,%d,%d] hex=%s]', ...
        this.index, this.indexAlt, rgb(1), rgb(2), rgb(3), this.hexString);
    end
    
  end
end