classdef (Abstract) Drawing < handle
  %DRAWING 
  
  properties
    % The underlying POI org.apache.poi.ss.usermodel.Drawing Java object
    j
    % The jl.office.excel.xlsx.Sheet this is attached to
    sheet
  end
  
  methods
  
    function this = Drawing()
    end
    
    function out = createAnchor(this, dx1, dy1, dx2, dy2, col1, row1, col2, row2)
      jObj = this.j.createAnchor(dx1, dy1, dx2, dy2, col1 - 1, row1 - 1, col2 - 1, row2 - 1);
      out = this.wrapClientAnchorObject(jObj);
    end
    
    function out = createCellComment(this, clientAnchor)
      mustBeA(clientAnchor, 'jl.office.excel.ClientAnchor');
      jObj = this.j.createCellComment(clientAnchor.j);
      out = this.wrapCommentObject(jObj);
    end
    
    function out = createObjectData(clientAnchor, storageId, pictureIndex)
      mustBeA(clientAnchor, 'jl.office.excel.ClientAnchor');
      jObj = this.j.createObjectData(clientAnchor, storageId, pictureIndex - 1);
      out = this.wrapObjectDataObject(jObj);
    end
    
    function out = createPicture(clientAnchor, pictureIndex)
      mustBeA(clientAnchor, 'jl.office.excel.ClientAnchor');
      jObj = this.j.createPicture(clientAnchor, pictureIndex - 1);
      out = this.wrapPictureObject(jObj);
    end
    
  end
  
  methods (Access = protected)
    out = wrapClientAnchorObject(this, jObj)
    out = wrapCommentObject(this, jObj)
    out = wrapObjectDataObject(this, jObj)
    out = wrapPictureObject(this, jObj)
  end
  
end

