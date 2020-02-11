classdef TextParagraph < handle
% TextParagraph

  properties
    % The underlying POI org.apache.poi.xssf.usermodel.XSSFTextParagraph Java object
    j
  end

  methods

    function this = TextParagraph(jObj)
      if nargin == 0
        return
      end
      mustBeA(jObj, 'org.apache.poi.xssf.usermodel.XSSFTextParagraph');
      this.j = jObj;
    end

  end

end
