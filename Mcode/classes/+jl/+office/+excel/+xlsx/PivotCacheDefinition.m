classdef PivotCacheDefinition < handle
% PivotCacheDefinition

  properties
    % The underlying POI org.apache.poi.xssf.usermodel.XSSFPivotCacheDefinition Java object
    j
  end

  methods

    function this = PivotCacheDefinition(jObj)
      if nargin == 0
        return
      end
      mustBeA(jObj, 'org.apache.poi.xssf.usermodel.XSSFPivotCacheDefinition');
      this.j = jObj;
    end
    
    function out = getPivotArea(this, workbook)
      mustBeA(workbook, 'jl.office.excel.Workbook');
      jObj = this.j.getPivotArea;
      out = jl.office.excel.AreaReference(jObj);
    end

  end

end
