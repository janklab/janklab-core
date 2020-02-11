classdef CellReferenceNameType < handle
  
  properties
    j
  end
  
  enumeration
    BadCellOrNamedRange(jl.util.java.getStaticFieldOnClass(...
      'org.apache.poi.ss.util.CellReference$NameType', 'BAD_CELL_OR_NAMED_RANGE'))
    Cell(jl.util.java.getStaticFieldOnClass(...
      'org.apache.poi.ss.util.CellReference$NameType', 'CELL'))
    Column(jl.util.java.getStaticFieldOnClass(...
      'org.apache.poi.ss.util.CellReference$NameType', 'COLUMN'))
    NamedRange(jl.util.java.getStaticFieldOnClass(...
      'org.apache.poi.ss.util.CellReference$NameType', 'NAMED_RANGE'))
    Row(jl.util.java.getStaticFieldOnClass(...
      'org.apache.poi.ss.util.CellReference$NameType', 'ROW'))
  end
  
  
  methods (Static)
    
    function out = ofJava(jObj)
      if isempty(jObj)
        out = [];
      elseif jObj.equals(jl.util.java.getStaticFieldOnClass(...
          'org.apache.poi.ss.usermodel.CellReference$NameType', 'BAD_CELL_OR_NAMED_RANGE'))
        out = jl.office.excel.CellReferenceNameType.BadCellOrNamedRange;
      elseif jObj.equals(jl.util.java.getStaticFieldOnClass(...
          'org.apache.poi.ss.usermodel.CellReference$NameType', 'CELL'))
        out = jl.office.excel.CellReferenceNameType.Cell;
      elseif jObj.equals(jl.util.java.getStaticFieldOnClass(...
          'org.apache.poi.ss.usermodel.CellReference$NameType', 'COLUMN'))
        out = jl.office.excel.CellReferenceNameType.Column;
      elseif jObj.equals(jl.util.java.getStaticFieldOnClass(...
          'org.apache.poi.ss.usermodel.CellReference$NameType', 'NAMED_RANGE'))
        out = jl.office.excel.CellReferenceNameType.NamedRange;
      elseif jObj.equals(jl.util.java.getStaticFieldOnClass(...
          'org.apache.poi.ss.usermodel.CellReference$NameType', 'ROW'))
        out = jl.office.excel.CellReferenceNameType.Row;
      else
        BADSWITCH
      end
    end
    
  end
  
  methods
    
    function out = toJava(this)
      out = this.j;
    end
    
  end
  
  methods (Access = private)
    
    function this = CellReferenceNameType(jObj)
      this.j = jObj;
    end
    
  end
  
end