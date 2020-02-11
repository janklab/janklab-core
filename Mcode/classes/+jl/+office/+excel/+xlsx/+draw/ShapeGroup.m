classdef ShapeGroup < jl.office.excel.xlsx.draw.Shape
% ShapeGroup

  methods

    function this = ShapeGroup(varargin)
      this = this@jl.office.excel.xlsx.draw.Shape(varargin{:});
      if nargin == 0
        return
      end
      mustBeA(varargin{1}, 'org.apache.poi.xssf.usermodel.XSSFShapeGroup');
    end
    
    function out = get.shapeName(this)
      out = string(this.j.getShapeName);
    end
    
    function out = createConnector(this, childAnchor)
      mustBeA(childAnchor, 'jl.office.excel.xlsx.draw.ChildAnchor');
      jObj = this.j.createConnector(childAnchor.j);
      out = jl.office.excel.xlsx.draw.Connector(jObj);
    end

    function out = createGroup(this, childAnchor)
      mustBeA(childAnchor, 'jl.office.excel.xlsx.draw.ChildAnchor');
      jObj = this.j.createGroup(childAnchor.j);
      out = jl.office.excel.xlsx.draw.ShapeGroup(jObj);
    end
    
    function out = createPicture(this, clientAnchor, pictureIndex)
      mustBeA(clientAnchor, 'jl.office.excel.ClientAnchor');
      jObj = this.j.createPicture(clientAnchor.j, pictureIndex - 1);
      out = jl.office.excel.xlsx.draw.Picture(jObj);
    end
    
    function out = createTextbox(this, childAnchor)
      mustBeA(childAnchor, 'jl.office.excel.xlsx.draw.ChildAnchor');
      jObj = this.j.createTextbox(childAnchor.j);
      out = jl.office.excel.xlsx.draw.TextBox(jObj);
    end
    
    function setCoordinates(x1, y1, x2, y2)
      this.j.setCoordinates(x1, y1, x2, y2);
    end
    
  end

end
