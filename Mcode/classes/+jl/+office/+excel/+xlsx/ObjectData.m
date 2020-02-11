classdef ObjectData < jl.office.excel.xlsx.draw.SimpleShape & jl.office.excel.ObjectData
% ObjectData Represents binary object (i.e. OLE) data stored in a file.

  properties (Dependent)
    directory
    fileName
    ole2ClassName
    sheet
    hasDirectoryEntry
  end
  
  methods

    function this = ObjectData(varargin)
      this = this@jl.office.excel.xlsx.draw.SimpleShape(varargin{:});
      if nargin == 0
        return
      end
      mustBeA(varargin{1}, 'org.apache.poi.xssf.usermodel.XSSFObjectData');
    end

    function out = get.directory(this)
      jObj = this.j.getDirectory;
      % TODO: Implement poifs.directoryentry
      UNIMPLEMENTED
    end
    
    function out = get.fileName(this)
      out = string(this.j.getFileName);
    end
    
    function out = getObjectData(this)
      out = this.j.getObjectData;
    end
    
    function out = getObjectPart(this)
      out = this.j.getObjectPart;
      % TODO: Should this be wrapped in a Matlab object?
    end
    
    function out = get.ole2ClassName(this)
      out = string(this.j.getOLE2ClassName);
    end
    
    function out = getOleObject(this)
      out = this.j.getOleObject;
    end
    
    function out = getPictureData(this)
      jObj = this.j.getPictureData;
      out = jl.office.excel.xlsx.PictureData(jObj);
    end
    
    function out = get.sheet(this)
      jObj = this.j.getSheet;
      % TODO: Should we be tracking references to the parent sheet in the ctor
      % here?
      out = jl.office.excel.xlsx.Sheet(jObj);
    end
    
    function out = get.hasDirectoryEntry(this)
      out = this.j.hasDirectoryEntry;
    end
    
  end

end
