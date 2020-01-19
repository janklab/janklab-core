classdef Comment < handle
  
  properties
    % The underlying POI XSSFRow object
    j
  end
  
  properties (Dependent)
    address
    author
    clientAnchor
    richTextString
    visible
  end
  
  methods
    
    function this = Comment(varargin)
      if nargin == 0
        return
      elseif nargin == 1
        arg = varargin{1};
        if isa(arg, 'org.apache.poi.ss.usermodel.Comment')
          % Wrap Java object
          this.j = arg;
        end
      else
        error('jl:InvalidInput', 'Invalid inputs');
      end
    end
    
    function out = get.address(this)
      out = jl.office.excel.CellAddress(this.j.getAddress);
    end
    
    function set.address(this, val)
      if isa(val, 'jl.office.excel.CellAddress')
        this.j.setAddress(val.j);
      else
        error('jl:InvalidInput', 'Invalid input');
      end
    end
    
    function out = get.author(this)
      out = string(this.j.getAuthor);
    end
    
    function set.author(this, val)
      this.j.setAuthor(val);
    end
    
    function out = get.richTextString(this)
      out = jl.office.excel.RichTextString(this.j.getString);
    end
    
    function set.richTextString(this, val)
      if isa(val, 'jl.office.excel.RichTextString')
        this.j.setString(val.j);
      else
        error('jl:InvalidInput', 'Invalid input');
      end
    end
    
    function out = get.visible(this)
      out = this.j.isVisible;
    end
    
    function set.visible(this, val)
      this.j.setVisible(val);
    end
    
  end
end
