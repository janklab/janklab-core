classdef ConditionType
  
  properties (Access = private)
    j
  end
  
  properties (Dependent)
    id
    name
  end
  
  enumeration
    CellValueIs(org.apache.poi.ss.usermodel.ConditionType.CELL_VALUE_IS)
    ColorScale(org.apache.poi.ss.usermodel.ConditionType.COLOR_SCALE)
    DataBar(org.apache.poi.ss.usermodel.ConditionType.DATA_BAR)
    Filter(org.apache.poi.ss.usermodel.ConditionType.FILTER)
    Formula(org.apache.poi.ss.usermodel.ConditionType.FORMULA)
    IconSet(org.apache.poi.ss.usermodel.ConditionType.IconSet)
  end
  
  methods (Static)
    
    function out = ofJava(j)
      if j.equals(org.apache.poi.ss.usermodel.ConditionType.CELL_VALUE_IS)
        out = jl.office.excel.ConditionType.CellValueIs;
      elseif j.equals(org.apache.poi.ss.usermodel.ConditionType.COLOR_SCALE)
        out = jl.office.excel.ConditionType.ColorScale;
      elseif j.equals(org.apache.poi.ss.usermodel.ConditionType.DATA_BAR)
        out = jl.office.excel.ConditionType.DataBar;
      elseif j.equals(org.apache.poi.ss.usermodel.ConditionType.FILTER)
        out = jl.office.excel.ConditionType.Filter;
      elseif j.equals(org.apache.poi.ss.usermodel.ConditionType.FORMULA)
        out = jl.office.excel.ConditionType.Formula;
      elseif j.equals(org.apache.poi.ss.usermodel.ConditionType.ICON_SET)
        out = jl.office.excel.ConditionType.IconSet;
      end
    end
    
  end
  
  methods
    
    function out = get.id(this)
      out = this.j.id;
    end
    
    function out = get.name(this)
      out = string(this.j.type);
    end
    
    function out = toJava(this)
      out = this.j;
    end
    
  end
  
  methods (Access = private)
    function this = ConditionType(jObj)
      this.j = jObj;
    end
  end
  
end