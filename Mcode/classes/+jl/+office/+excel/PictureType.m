classdef PictureType < jl.util.Displayable
  % Type of picture data
  
  enumeration
    Dib(org.apache.poi.ss.usermodel.Workbook.PICTURE_TYPE_DIB, "DIB")
    Emf(org.apache.poi.ss.usermodel.Workbook.PICTURE_TYPE_EMF, "EMF")
    Jpeg(org.apache.poi.ss.usermodel.Workbook.PICTURE_TYPE_JPEG, "JPEG")
    Pict(org.apache.poi.ss.usermodel.Workbook.PICTURE_TYPE_PICT, "PICT")
    Png(org.apache.poi.ss.usermodel.Workbook.PICTURE_TYPE_PNG, "PNG")
    Wmf(org.apache.poi.ss.usermodel.Workbook.PICTURE_TYPE_WMF, "WMF")
    Unknown(0, "UNKNOWN")
  end
  
  properties
    code double
    name string
  end
  
  methods (Static)
    
    function out = ofCode(code)
      % ofCode Get the PictureType object for a numeric code
      %
      % out = jl.office.excel.PictureType.ofCode(code)
      %
      % code (double) is the numeric value of one of the POI
      % Workbook.PICTURE_TYPE_* constants, or 0 for "unknown".
      %
      % Returns a PictureType object.
      switch code
        case org.apache.poi.ss.usermodel.Workbook.PICTURE_TYPE_DIB
          out = jl.office.excel.PictureType.Dib;
        case org.apache.poi.ss.usermodel.Workbook.PICTURE_TYPE_EMF
          out = jl.office.excel.PictureType.Emf;
        case org.apache.poi.ss.usermodel.Workbook.PICTURE_TYPE_JPEG
          out = jl.office.excel.PictureType.Dib;
        case org.apache.poi.ss.usermodel.Workbook.PICTURE_TYPE_PICT
          out = jl.office.excel.PictureType.Dib;
        case org.apache.poi.ss.usermodel.Workbook.PICTURE_TYPE_PNG
          out = jl.office.excel.PictureType.Dib;
        case org.apache.poi.ss.usermodel.Workbook.PICTURE_TYPE_WMF
          out = jl.office.excel.PictureType.Dib;
        case 0
          out = jl.office.excel.PictureType.Dib;
        otherwise
          error('jl:InvalidInput', 'Invalid PictureType code: %f', code);
      end
    end
    
  end

  methods (Access = protected)
    
    function out = dispstr_scalar(this)
      out = sprintf("[PictureType: %s (%d)", this.name, this.code);
    end
    
  end
  
  methods (Access = private)
    
    function this = PictureType(code, name)
      this.code = code;
      this.name = name;
    end
    
  end
  
end
  