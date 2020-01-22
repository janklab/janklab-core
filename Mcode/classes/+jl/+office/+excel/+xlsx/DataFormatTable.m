classdef DataFormatTable < jl.office.excel.DataFormatTable
  % A data format table for an XLSX workbook
  
  methods
    
    function this = DataFormatTable(jObj)
      mustBeA(jObj, 'org.apache.poi.xssf.usermodel.XSSFDataFormat');
      this.j = jObj;
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
    
    function putFormat(this, index, format)
      % Add a data format with a specific ID into the data format table
      %
      % putFormat(obj, index, format)
      %
      % Puts a data format into obj's data format table at a specific given
      % index. This is an alternative to just calling getFormatIndex(obj,
      % format) that you can use when you want to control the index it ends up
      % with. If you don't care what index is used (and you usually don't), you
      % can just call getFormatIndex and it will auto-add the format for you at
      % an index it picks.
      %
      % Index (numeric) is the index to use for the format.
      %
      % Format (string) is the format definition, like "#,##0.00".
      mustBeScalarNumeric(index);
      mustBeStringy(format);
      this.j.putFormat(index, format);
    end
    
  end
  
  methods (Access = protected)
    
    function out = dispstr_scalar(this)
      out = sprintf('[DataFormatTable]');
    end
    
  end
  
end