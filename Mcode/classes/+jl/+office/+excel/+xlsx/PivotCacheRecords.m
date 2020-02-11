classdef PivotCacheRecords < handle
% PivotCacheRecords

  properties
    % The underlying POI org.apache.poi.xssf.usermodel.XSSFPivotCacheRecords Java object
    j
  end

  methods

    function this = PivotCacheRecords(jObj)
      if nargin == 0
        return
      end
      mustBeA(jObj, 'org.apache.poi.xssf.usermodel.XSSFPivotCacheRecords');
      this.j = jObj;
    end

  end

end
