classdef Hyperlink < jl.util.DisplayableHandle
  
  properties
    % The underlying POI Hyperlink object
    j
  end
  
  properties (Dependent)
    address
    label
    location
    type
    firstColumn
    firstRow
    lastColumn
    lastRow
    tooltip
  end
  
  methods
    
    function this = Hyperlink(varargin)
      if nargin == 0
        return
      elseif nargin == 1
        arg = varargin{1};
        if isa(arg, 'org.apache.poi.ss.usermodel.Hyperlink')
          % Wrap Java object
          this.j = arg;
        else
          error('jl:InvalidInput', 'Invalid input')
        end
      else
        error('jl:InvalidInput', 'Invalid inputs');
      end
    end
    
    function out = dispstr_scalar(this)
      out = sprintf('[Hyperlink: label=%s address=%s type=%s range=[(%d,%d) to (%d,%d)]', ...
        this.label, this.address, this.type, ...
        this.firstRow, this.firstColumn, this.lastRow, this.lastColumn);
    end
    
    function out = get.firstColumn(this)
      out = this.j.getFirstColumn;
    end
    
    function set.firstColumn(this, val)
      this.j.setFirstColumn(val);
    end
    
    function out = get.firstRow(this)
      out = this.j.getFirstRow;
    end
    
    function set.firstRow(this, val)
      this.j.setFirstRow(val);
    end
    
    function out = get.lastColumn(this)
      out = this.j.getLastColumn;
    end
    
    function set.lastColumn(this, val)
      this.j.setLastColumn(val);
    end
    
    function out = get.lastRow(this)
      out = this.j.getLastRow;
    end
    
    function set.lastRow(this, val)
      this.j.setLastRow(val);
    end
    
    function out = get.address(this)
      out = string(this.j.getAddress);
    end
    
    function set.address(this, val)
      this.j.setAddress(val);
    end
    
    function out = get.label(this)
      out = string(this.j.getLabel);
    end
    
    function set.label(this, val)
      this.j.setLabel(val);
    end
    
    function out = get.location(this)
      out = string(this.j.getLocation);
    end
    
    function set.location(this, val)
      this.j.setLocation(val);
    end
    
    function out = get.type(this)
      out = jl.office.excel.HyperlinkType.ofJava(this.j.getType);
    end
    
    function out = get.tooltip(this)
      out = string(this.j.getTooltip);
    end
    
    function set.tooltip(this, val)
      this.j.setTooltip(val);
    end
        
  end
  
end
