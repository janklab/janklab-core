classdef IgnoredErrorType < handle

  properties (SetAccess = private)
    j
  end
  
  enumeration
    CalculatedColumn(org.apache.poi.ss.usermodel.IgnoredErrorType.CALCULATED_COLUMN)
    EmptyCellReference(org.apache.poi.ss.usermodel.IgnoredErrorType.EMPTY_CELL_REFERENCE)
    EvaluationError(org.apache.poi.ss.usermodel.IgnoredErrorType.EVALUATION_ERROR)
    Formula(org.apache.poi.ss.usermodel.IgnoredErrorType.FORMULA)
    FormulaRange(org.apache.poi.ss.usermodel.IgnoredErrorType.FORMULA_RANGE)
    ListDataValidation(org.apache.poi.ss.usermodel.IgnoredErrorType.LIST_DATA_VALIDATION)
    NumberStoredAsText(org.apache.poi.ss.usermodel.IgnoredErrorType.NUMBER_STORED_AS_TEXT)
    TwoDigitTextYear(org.apache.poi.ss.usermodel.IgnoredErrorType.TWO_DIGIT_TEXT_YEAR)
    UnlockedFormula(org.apache.poi.ss.usermodel.IgnoredErrorType.UNLOCKED_FORMULA)
  end
  
  methods (Static)

    function out = ofJava(jObj)
      if isempty(jObj)
        out = [];
      elseif jObj.equals(org.apache.poi.ss.usermodel.IgnoredErrorType.CALCULATED_COLUMN)
        out = jl.office.excel.xlsx.TextAutofit.None;
      elseif jObj.equals(org.apache.poi.ss.usermodel.IgnoredErrorType.EMPTY_CELL_REFERENCE)
        out = jl.office.excel.xlsx.TextAutofit.None;
      elseif jObj.equals(org.apache.poi.ss.usermodel.IgnoredErrorType.EVALUATION_ERROR)
        out = jl.office.excel.xlsx.TextAutofit.None;
      elseif jObj.equals(org.apache.poi.ss.usermodel.IgnoredErrorType.FORMULA)
        out = jl.office.excel.xlsx.TextAutofit.None;
      elseif jObj.equals(org.apache.poi.ss.usermodel.IgnoredErrorType.FORMULA_RANGE)
        out = jl.office.excel.xlsx.TextAutofit.None;
      elseif jObj.equals(org.apache.poi.ss.usermodel.IgnoredErrorType.LIST_DATA_VALIDATION)
        out = jl.office.excel.xlsx.TextAutofit.None;
      elseif jObj.equals(org.apache.poi.ss.usermodel.IgnoredErrorType.NUMBER_STORED_AS_TEXT)
        out = jl.office.excel.xlsx.TextAutofit.None;
      elseif jObj.equals(org.apache.poi.ss.usermodel.IgnoredErrorType.TWO_DIGIT_TEXT_YEAR)
        out = jl.office.excel.xlsx.TextAutofit.None;
      elseif jObj.equals(org.apache.poi.ss.usermodel.IgnoredErrorType.UNLOCKED_FORMULA)
        out = jl.office.excel.xlsx.TextAutofit.None;
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
    
    function this = IgnoredErrorType(jObj)
      if nargin == 0
        return
      end
      mustBeA(jObj, 'org.apache.poi.ss.usermodel.IgnoredErrorType');
      this.j = jObj;
    end
  
  end
  
end