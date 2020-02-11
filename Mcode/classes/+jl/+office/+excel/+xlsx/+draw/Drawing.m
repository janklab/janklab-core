classdef Drawing < jl.office.excel.Drawing
  %DRAWING An Excel 2007 Drawing
  
  %#ok<*INUSL>
  
  properties
  end
  
  methods

    function this = Drawing(sheet, jObj)
      if nargin == 0
        return
      end
      mustBeA(sheet, 'jl.office.excel.xlsx.Sheet');
      mustBeA(jObj, 'org.apache.poi.xssf.usermodel.XSSFDrawing');
      this.sheet = sheet;
      this.j = jObj;
    end
    
    function out = addPictureReference(this, pictureIndex)
      jObj = this.j.addPictureReference(pictureIndex - 1);
      out = jl.office.excel.xlsx.PackageRelationship(jObj);
    end
    
    function out = createChart(this, clientAnchor)
      mustBeA(clientAnchor, 'jl.office.excel.ClientAnchor');
      jObj = this.j.createChart(clientAnchor.j);
      out = jl.office.excel.xlsx.draw.Chart(jObj);
    end
    
    function out = createConnector(this, clientAnchor)
      mustBeA(clientAnchor, 'jl.office.excel.xlsx.ClientAnchor');
      jObj = this.j.createConnector(clientAnchor.j);
      out = jl.office.excel.xlsx.draw.Connector(jObj);
    end
    
    function out = createGroup(this, clientAnchor)
      mustBeA(clientAnchor, 'jl.office.excel.xlsx.ClientAnchor');
      jObj = this.j.createGroup(clientAnchor.j);
      out = jl.office.excel.xlsx.draw.ShapeGroup(jObj);
    end
    
    function out = createSimpleShape(this, clientAnchor)
      mustBeA(clientAnchor, 'jl.office.excel.xlsx.ClientAnchor');
      jObj = this.j.createSimpleShape(clientAnchor.j);
      out = jl.office.excel.xlsx.draw.SimpleShape(jObj);
    end
    
    function out = createTextbox(this, anchor)
      mustBeA(anchor, 'jl.office.excel.xlsx.ClientAnchor');
      jObj = this.j.createTextbox(anchor.j);
      out = jl.office.excel.xlsx.draw.TextBox(jObj);
    end
    
    function out = getCharts(this)
      jList = this.j.getCharts;
      out = repmat(jl.office.excel.xlsx.draw.Chart, [1 jList.size]);
      for i = 1:numel(out)
        out(i) = jl.office.excel.xlsx.draw.Chart(jList.get(i - 1));
      end
    end
    
    function out = getShapes(this, shapeGroup)
      if nargin == 1
        jList = this.j.getShapes;
      else
        mustBeA(shapeGroup, 'jl.office.excel.xlsx.draw.ShapeGroup');
        jList = this.j.getShapes(shapeGroup.j);
      end
      out = repmat(jl.office.excel.xlsx.draw.Shape, [1 jList.size]);
      for i = 1:numel(out)
        out(i) = jl.office.excel.xlsx.draw.Shape(jList.get(i - 1));
      end
    end
    
    function out = importChart(this, sourceChart)
      mustBeA(sourceChart, 'jl.office.excel.xlsx.draw.Chart');
      jObj = this.j.importChart(sourceChart.j);
      out = jl.office.excel.xlsx.draw.Chart(jObj);
    end
    
  end
  
  methods (Access = protected)
    
    function out = wrapClientAnchorObject(this, jObj)
      out = jl.office.excel.xlsx.ClientAnchor(jObj);
    end
    
    function out = wrapCommentObject(this, jObj)
      out = jl.office.excel.xlsx.Comment(jObj);
    end
    
    function out = wrapObjectDataObject(this, jObj) 
      out = jl.office.excel.xlsx.ObjectData(jObj);
    end
    
    function out = wrapPictureObject(this, jObj)
      out = jl.office.excel.xlsx.Picture(jObj);
    end
    
  end
  
end

