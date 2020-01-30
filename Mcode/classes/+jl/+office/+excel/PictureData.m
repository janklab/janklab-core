classdef (Abstract) PictureData < jl.util.DisplayableHandle
  % Represents picture data included in a workbook
  
  properties
    % The underlying Java POI object
    j
  end
  properties (Dependent)
    % The MIME type for the image, as a string
    mimeType
    % The picture type, as a PictureType object
    pictureType
  end
  
  methods
    
    function out = getData(this)
      % Get the picture data as raw bytes
      %
      % out = getData(obj)
      %
      % Returns a uint8 vector.
      out = uint8(this.j.getData);
    end
    
    function out = get.mimeType(this)
      out = string(this.j.getMimeType);
    end
    
    function out = get.pictureType(this)
      out = jl.office.excel.PictureType.ofCode(this.j.getPictureType);
    end
    
    function out = suggestFileExtension(this)
      % Get a suggested file extension for this image
      %
      % out = suggestFileExtension(obj)
      %
      % Returns a string, which may be empty or missing.
      out = string(this.j.suggestFileExtension);
    end
      
  end
  
  methods (Access = protected)
    
    function out = dispstr_scalar(this)
      out = sprintf('[PictureData: type=%s, mimeType=%s, %d bytes, extn="%s"]', ...
        this.pictureType, this.mimeType, numel(this.getData), this.suggestFileExtension);
    end
    
  end
  
end