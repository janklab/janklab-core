classdef (Abstract) DataFormatTable < jl.util.DisplayableHandle
  % A table of the data formats used in a workbook
  %
  % A DataFormatTable keeps track of all the data formats (aka "number formats")
  % used in a workbook.
  
  properties
    % The underlying org.apache.poi.ss.usermodel.DataFormat Java POI object
    j
  end
  
  methods
    
    function out = getFormatIndex(this, formatStr)
      % Gets the data format index for a given string
      %
      % out = getFormatIndex(obj, str)
      %
      % Str (string) is a string containing the format definition, like
      % "#,##0.00". In this form, if no data format exists for that string yet,
      % it is automatically created. Aliases text to the proper format.
      %
      % Returns a numeric index. This is an index into the workbook's internal
      % list of data formats.
      if ~ischar(formatStr) && ~isstring(formatStr)
        error('jl:InvalidInput', 'formatStr must be char or string; got a %s', ...
          class(formatStr));
      end
      formatStr = string(formatStr);
      out = this.j.getFormat(formatStr);
    end
    
    function out = getFormatForIndex(this, index)
      % Get the format definition for a given format index
      %
      % out = getFormat(obj, index)
      %
      % Index (numeric) is an index into the format table's list of formats.
      %
      % Returns a string.
      mustBeNumeric(index);
      out = string(this.j.getFormat(index));
    end
    
  end
  
end