classdef DataFormatTable < jl.office.excel.DataFormatTable
  % A data format table for an XLS workbook
  
  methods
    
    function this = DataFormatTable(jObj)
      mustBeA(jObj, 'org.apache.poi.hssf.usermodel.HSSFDataFormat');
      this.j = jObj;
    end
    
    function out = getBuiltinFormat(this, index)
      % Get the format string for the given built-in format index
      %
      % out = getBuiltinFormat(obj, index)
      %
      % Index (numeric) is the index into obj's built-in format list.
      %
      % Returns a string.
      out = string(this.j.getBuiltinFormat(index));
    end
    
    function out = getBuiltinFormatIndex(this, format)
      % Get the index of the given built-in format
      %
      % out = getBuiltinFormatIndex(obj, format)
      %
      % Gets the index of the given format in obj's built-in format list.
      %
      % Returns a numeric.
      mustBeStringy(format);
      mustBeScalar(format);
      out = this.j.getBuiltinFormatIndex(format);
    end
    
    function out = getBuiltinFormats(this)
      % List all the built-in formats
      %
      % out = getBuiltinFormats(obj)
      %
      % Returns a string array vector.
      out = jl.util.java.convertStringsToMatlab(this.j.getBuiltinFormats);
      out = out(:);
    end
    
    function out = getFormat(this, index)
      % Get the format string for the given format index
      %
      % out = getFormat(obj, index)
      %
      % Index (numeric) is the index into obj's format list.
      %
      % Returns a string.
      out = string(this.j.getFormat(index));
    end
    
    function out = getFormatIndex(this, format)
      % Get the index of the givenformat
      %
      % out = getFormatIndex(obj, format)
      %
      % Gets the index of the given format in obj's format list.
      %
      % Returns a numeric.
      mustBeStringy(format);
      mustBeScalar(format);
      out = this.j.getFormatIndex(format);
    end
    
    function out = numberOfBuiltinFormats(this)
      % Get the number of built-in and reserved builtin formats
      %
      % out = numberOfBuiltinFormats(obj)
      %
      % Returns a numeric.
      out = this.j.getNumberOfBuiltinBuiltinFormats;
    end
    
  end
  
  methods (Access = protected)
    
    function out = dispstr_scalar(this)
      out = sprintf('[DataFormatTable: %d built-in formats]', ...
        this.numberOfBuiltinFormats);
    end
    
  end
  
end