classdef DataValidationConstraintValidationType
  
  properties
    code
  end
  
  enumeration
    Any(jl.util.java.getStaticFieldOnClass(...
      'org.apache.poi.ss.usermodel.DataValidationConstraint$ValidationType', 'ANY'))
    Date(jl.util.java.getStaticFieldOnClass(...
      'org.apache.poi.ss.usermodel.DataValidationConstraint$ValidationType', 'DATE'))
    Decimal(jl.util.java.getStaticFieldOnClass(...
      'org.apache.poi.ss.usermodel.DataValidationConstraint$ValidationType', 'DECIMAL'))
    Formula(jl.util.java.getStaticFieldOnClass(...
      'org.apache.poi.ss.usermodel.DataValidationConstraint$ValidationType', 'FORMULA'))
    Integer(jl.util.java.getStaticFieldOnClass(...
      'org.apache.poi.ss.usermodel.DataValidationConstraint$ValidationType', 'INTEGER'))
    List(jl.util.java.getStaticFieldOnClass(...
      'org.apache.poi.ss.usermodel.DataValidationConstraint$ValidationType', 'LIST'))
    TextLength(jl.util.java.getStaticFieldOnClass(...
      'org.apache.poi.ss.usermodel.DataValidationConstraint$ValidationType', 'TEXT_LENGTH'))
    Time(jl.util.java.getStaticFieldOnClass(...
      'org.apache.poi.ss.usermodel.DataValidationConstraint$ValidationType', 'TIME'))
  end
  
  methods (Static)
    
    function out = ofJava(jObj)
      if isempty(jObj)
        out = [];
      elseif jObj.equals(jl.util.java.getStaticFieldOnClass(...
          'org.apache.poi.ss.usermodel.DataValidationConstraint$ValidationType', 'ANY'))
        out = jl.office.excel.DataValidationConstraintValidationType.Any;
      elseif jObj.equals(jl.util.java.getStaticFieldOnClass(...
          'org.apache.poi.ss.usermodel.DataValidationConstraint$ValidationType', 'DATE'))
        out = jl.office.excel.DataValidationConstraintValidationType.Date;
      elseif jObj.equals(jl.util.java.getStaticFieldOnClass(...
          'org.apache.poi.ss.usermodel.DataValidationConstraint$ValidationType', 'DECIMAL'))
        out = jl.office.excel.DataValidationConstraintValidationType.Decimal;
      elseif jObj.equals(jl.util.java.getStaticFieldOnClass(...
          'org.apache.poi.ss.usermodel.DataValidationConstraint$ValidationType', 'FORMULA'))
        out = jl.office.excel.DataValidationConstraintValidationType.Formula;
      elseif jObj.equals(jl.util.java.getStaticFieldOnClass(...
          'org.apache.poi.ss.usermodel.DataValidationConstraint$ValidationType', 'INTEGER'))
        out = jl.office.excel.DataValidationConstraintValidationType.Integer;
      elseif jObj.equals(jl.util.java.getStaticFieldOnClass(...
          'org.apache.poi.ss.usermodel.DataValidationConstraint$ValidationType', 'LIST'))
        out = jl.office.excel.DataValidationConstraintValidationType.List;
      elseif jObj.equals(jl.util.java.getStaticFieldOnClass(...
          'org.apache.poi.ss.usermodel.DataValidationConstraint$ValidationType', 'TEXT_LENGTH'))
        out = jl.office.excel.DataValidationConstraintValidationType.TextLength;
      elseif jObj.equals(jl.util.java.getStaticFieldOnClass(...
          'org.apache.poi.ss.usermodel.DataValidationConstraint$ValidationType', 'TIME'))
        out = jl.office.excel.DataValidationConstraintValidationType.Time;
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
    
    function this = DataValidationConstraintValidationType(jVal)
      if nargin == 0
        return
      end
      this.code = jVal;
    end
    
  end
  
end

