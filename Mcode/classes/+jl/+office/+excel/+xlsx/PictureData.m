classdef PictureData < jl.office.excel.PictureData
  % Raw picture data, normally attached to a SpreadsheetML Drawing.
  
  methods
    
    function this = PictureData(jObj)
      if nargin == 0
        return
      end
      mustBeA(jObj, 'org.apache.poi.xssf.usermodel.XSSFPictureData');
      this.j = jObj;
    end
    
  end
  
end