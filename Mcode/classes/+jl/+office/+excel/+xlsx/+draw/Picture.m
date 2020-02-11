classdef Picture < jl.office.excel.xlsx.draw.Shape
% Picture

  properties (Dependent)
    shapeName
  end
  
  methods

    function this = Picture(varargin)
      this = this@jl.office.excel.xlsx.draw.Shape(varargin{:});
      if nargin == 0
        return
      end
      mustBeA(varargin{1}, 'org.apache.poi.xssf.usermodel.XSSFPicture');
    end

    function out = getClientAnchor(this)
      jObj = this.j.getClientAnchor;
      out = jl.office.excel.xlsx.ClientAnchor(jObj);
    end
    
    function out = getImageDimension(this)
      out = this.j.getImageDimension;
      % TODO: Should we wrap java.awt.Dimension in a Matlab object?
    end
    
    function out = getPictureData(this)
      jObj = this.j.getPictureData;
      out = jl.office.excel.xlsx.PictureData(jObj);
    end
    
    function out = getPreferredSize(varargin)
      jObj = this.j.getPreferredSize(varargin{:});
      out = jl.office.excel.xlsx.ClientAnchor(jObj);
    end
    
    function out = get.shapeName(this)
      out = string(this.j.getShapeName);
    end
    
    function out = getSheet(this)
      jObj = this.j.getSheet;
      out = jl.office.excel.xlsx.Sheet(jObj);
    end
    
    function resize(this, varargin)
      narginchk(1, 3);
      this.j.resize(varargin{:});
    end
    
  end

end
