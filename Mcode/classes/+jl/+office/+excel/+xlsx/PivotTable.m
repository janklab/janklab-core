classdef PivotTable < handle
% PivotTable

  properties
    % The underlying POI org.apache.poi.xssf.usermodel.XSSFPivotTable Java object
    j
  end
  
  properties (Dependent)
    dataSheet
    parentSheet
    pivotCache
    pivotCacheDefinition
    pivotCacheRecords
    rowLabelColumns
  end

  methods

    function this = PivotTable(jObj)
      if nargin == 0
        return
      end
      mustBeA(jObj, 'org.apache.poi.xssf.usermodel.XSSFPivotTable');
      this.j = jObj;
    end
    
    function out = get.dataSheet(this)
      jObj = this.j.getDataSheet;
      out = jl.office.excel.xlsx.Sheet(jObj);
    end
    
    function out = get.parentSheet(this)
      jObj = this.j.getParentSheet;
      out = jl.office.excel.xlsx.Sheet(jObj);
    end
    
    function set.parentSheet(this, val)
      mustBeA(val, 'jl.office.excel.xlsx.Sheet');
      this.j.setParentSheet(val.j);
    end
    
    function out = get.pivotCache(this)
      jObj = this.j.getPivotCache;
      out = jl.office.excel.xlsx.PivotCache(jObj);
    end
    
    function set.pivotCache(this, val)
      mustBeA(val, 'jl.office.excel.xlsx.PivotCache');
      this.j.setPivotCache(val.j);
    end
    
    function out = get.pivotCacheDefinition(this)
      jObj = this.j.getPivotCacheDefinition;
      out = jl.office.excel.xlsx.PivotCacheDefinition(jObj);
    end
    
    function set.pivotCacheDefinition(this, val)
      mustBeA(val, 'jl.office.excel.xlsx.PivotCacheDefinition');
      this.j.setPivotCacheDefinition(val.j);
    end
    
    function out = get.pivotCacheRecords(this)
      jObj = this.j.getPivotCacheRecords;
      out = jl.office.excel.xlsx.PivotCacheRecords(jObj);
    end
    
    function set.pivotCacheRecords(this, val)
      mustBeA(val, 'jl.office.excel.xlsx.PivotCacheRecords');
      this.j.setPivotCacheRecords(val.j);
    end

    function addColumnLabel(this, consolidateFunction, columnIndex, valueFieldName)
      mustBeA(consolidateFunction, 'jl.office.excel.DataConsolidateFunction');
      if nargin < 4
        this.j.addColumnLabel(consolidateFunction.j, columnIndex - 1);
      else
        mustBeStringy(valueFieldName);
        this.j.addColumnLabel(consolidateFunction.j, columnIndex - 1, valueFieldName);
      end
    end
    
    function addDataColumn(this, columnIndex, isDataField)
      this.j.addDataColumn(columnIndex - 1, isDataField);
    end
    
    function addReportFilter(this, columnIndex)
      this.j.addReportFilter(columnIndex - 1);
    end
    
    function addRowLabel(this, columnIndex)
      this.j.addRowLabel(columnIndex - 1);
    end
    
  end

end
