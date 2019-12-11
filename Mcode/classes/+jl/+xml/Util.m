classdef Util
  
  properties (Constant)
    % The missing string value
    % This shares a common missing string value to avoid excessive array 
    % creation.
    % Why doesn't Matlab provide a "string.missing" that does this?
    missing_string = string(missing);
  end
  
  methods (Static)
    
    function out = isValidXmlName(str)
      % True if input is a valid XML name
      mustBeString(str);
      str = string(str);
      out = logical(size(str));
      for i = 1:numel(str)
        % The valid name pattern turns into a gory regex, so let's just
        % call down to Java's XML code to do this.
        out(i) = org.apache.xerces.util.XMLChar.isValidName(str(i));
      end
    end
    
  end
  
end
