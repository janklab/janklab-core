classdef RichTextString < jl.util.DisplayableHandle
  
  properties
    % The underlying POI RichTextString object
    j
  end
  
  properties (Dependent)
    string
    length
    numFormattingRuns
  end
  
  methods
    
    function this = RichTextString(varargin)
      if nargin == 0
        return
      elseif nargin == 1 
        arg = varargin{1};
        if isa(arg, 'org.apache.poi.ss.usermodel.RichTextString')
          % Wrap Java object
          this.j = arg;
        elseif ischar(arg) || isstring(arg)
          this.j = org.apache.poi.xssf.usermodel.XSSFRichTextString(arg);
        end
      else
        error('jl:InvalidInput', 'Invalid inputs');
      end
    end
    
    function out = dispstr_scalar(this)
      out = sprintf('[RichTextString: %s]', this.string);
    end
    
    function out = get.string(this)
      out = string(this.j.getString); %#ok<CPROP>
    end
    
    function out = get.length(this)
      out = this.j.length;
    end
    
    function out = get.numFormattingRuns(this)
      out = this.j.numFormattingRuns;
    end
    
    function clearFormatting(this)
      this.j.clearFormatting;
    end
    
    function out = hasFormatting(this)
      out = this.j.hasFormatting;
    end
    
    function append(this, text, font)
      narginchk(2, 3);
      if nargin == 2
        this.j.append(text);
      else
        mustBeA(font, 'jl.office.excel.Font');
        this.j.append(text, font.j);
      end
    end
    
    function applyFont(this, font, startIndex, endIndex)
      narginchk(2, 4);
      if ~isnumeric(font) && ~isa(font, 'jl.office.excel.Font')
        error('font must be numeric or a jl.office.excel.Font object');
      end
      if nargin == 2
        if isa(font, 'jl.office.excel.Font')
          this.j.applyFont(font.j);
        else
          this.j.applyFont(font);
        end
      else
        if isa(font, 'jl.office.excel.Font')
          this.j.applyFont(startIndex, endIndex, font.j);
        else
          this.j.applyFont(startIndex, endIndex, font);
        end
      end
    end
    
    function out = getFontAtIndex(this, ix)
      out = jl.office.excel.Font(this.j.getFontAtIndex(ix));
    end
    
    function out = getFontOfFormattingRun(this, ix)
      out = jl.office.excel.Font(this.j.getFontOfFormattingRun(ix));
    end
    
    function out = getIndexOfFormattingRun(ix)
      out = this.j.getIndexOfFormattingRun(ix);
    end
    
    function setString(this, str)
      this.j.setString(str);
    end
    
  end
  
end
