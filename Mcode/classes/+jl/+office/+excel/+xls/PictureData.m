classdef PictureData < jl.office.excel.PictureData
  
  methods
    
    function this = PictureData(jObj)
      if nargin == 0
        return
      end
      mustBeA(jObj, 'org.apache.poi.hssf.usermodel.HSSFPictureData');
      this.j = jObj;
    end
    
    function out = getFormat(this)
      % Get the format of this picture as an integer code
      %
      % out = getFormat(obj)
      %
      % Returns an integer value.
      out = this.j.getFormat;
    end
    
  end
  
end