classdef ConditionFilterType
  
  properties (Access = private)
    j
  end
  
  enumeration
    AboveAverage(org.apache.poi.ss.usermodel.ConditionFilterType.ABOVE_AVERAGE)
    BeginsWith(org.apache.poi.ss.usermodel.ConditionFilterType.BEGINS_WITH)
    ContainsBlanks(org.apache.poi.ss.usermodel.ConditionFilterType.CONTAINS_BLANKS)
    ContainsErrors(org.apache.poi.ss.usermodel.ConditionFilterType.CONTAINS_ERRORS)
    ContainsText(org.apache.poi.ss.usermodel.ConditionFilterType.CONTAINS_TEXT)
    DuplicateValues(org.apache.poi.ss.usermodel.ConditionFilterType.DUPLICATE_VALUES)
    EndsWith(org.apache.poi.ss.usermodel.ConditionFilterType.ENDS_WITH)
    Filter(org.apache.poi.ss.usermodel.ConditionFilterType.FILTER)
    NotContainsBlanks(org.apache.poi.ss.usermodel.ConditionFilterType.NOT_CONTAINS_BLANKS)
    NotContainsErrors(org.apache.poi.ss.usermodel.ConditionFilterType.NOT_CONTAINS_ERRORS)
    NotContainsText(org.apache.poi.ss.usermodel.ConditionFilterType.NOT_CONTAINS_TEXT)
    TimePeriod(org.apache.poi.ss.usermodel.ConditionFilterType.TIME_PERIOD)
    TopTen(org.apache.poi.ss.usermodel.ConditionFilterType.TOP_10)
    UniqueValues(org.apache.poi.ss.usermodel.ConditionFilterType.UNIQUE_VALUES)
  end
  
  methods (Static)
    
    function out = ofJava(j)
      if isempty(j)
        out = [];
      elseif j.equals(org.apache.poi.ss.usermodel.ConditionFilterType.ABOVE_AVERAGE)
        out = jl.office.excel.ConditionFilterType.AboveAverage;
      elseif j.equals(org.apache.poi.ss.usermodel.ConditionFilterType.BEGINS_WITH)
        out = jl.office.excel.ConditionFilterType.BeginsWith;
      elseif j.equals(org.apache.poi.ss.usermodel.ConditionFilterType.CONTAINS_BLANKS)
        out = jl.office.excel.ConditionFilterType.ContainsBlanks;
      elseif j.equals(org.apache.poi.ss.usermodel.ConditionFilterType.CONTAINS_ERRORS)
        out = jl.office.excel.ConditionFilterType.ContainsErrors;
      elseif j.equals(org.apache.poi.ss.usermodel.ConditionFilterType.CONTAINS_TEXT)
        out = jl.office.excel.ConditionFilterType.ContainsText;
      elseif j.equals(org.apache.poi.ss.usermodel.ConditionFilterType.DUPLICATE_VALUES)
        out = jl.office.excel.ConditionFilterType.DuplicateValues;
      elseif j.equals(org.apache.poi.ss.usermodel.ConditionFilterType.ENDS_WITH)
        out = jl.office.excel.ConditionFilterType.EndsWith;
      elseif j.equals(org.apache.poi.ss.usermodel.ConditionFilterType.FILTER)
        out = jl.office.excel.ConditionFilterType.Filter;
      elseif j.equals(org.apache.poi.ss.usermodel.ConditionFilterType.NOT_CONTAINS_BLANKS)
        out = jl.office.excel.ConditionFilterType.NotContainsBlanks;
      elseif j.equals(org.apache.poi.ss.usermodel.ConditionFilterType.NOT_CONTAINS_ERRORS)
        out = jl.office.excel.ConditionFilterType.NotContainsErrors;
      elseif j.equals(org.apache.poi.ss.usermodel.ConditionFilterType.NOT_CONTAINS_TEXT)
        out = jl.office.excel.ConditionFilterType.NotContainsText;
      elseif j.equals(org.apache.poi.ss.usermodel.ConditionFilterType.TIME_PERIOD)
        out = jl.office.excel.ConditionFilterType.TimePeriod;
      elseif j.equals(org.apache.poi.ss.usermodel.ConditionFilterType.TOP_10)
        out = jl.office.excel.ConditionFilterType.TopTen;
      elseif j.equals(org.apache.poi.ss.usermodel.ConditionFilterType.UNIQUE_VALUES)
        out = jl.office.excel.ConditionFilterType.UniqueValues;
      else
        BADSWITCH
      end
    end
    
  end
  
  methods (Access = private)
    
    function this = ConditionFilterType(jObj)
      this.j = jObj;
    end
    
  end
  
end