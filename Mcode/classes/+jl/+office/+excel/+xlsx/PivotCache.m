classdef PivotCache < handle
% PivotCache

  properties
    % The underlying POI org.apache.poi.xssf.usermodel.XSSFPivotCache Java object
    j
  end

  methods

    function this = PivotCache(jObj)
      if nargin == 0
        return
      end
      mustBeA(jObj, 'org.apache.poi.xssf.usermodel.XSSFPivotCache');
      this.j = jObj;
    end

  end

end
