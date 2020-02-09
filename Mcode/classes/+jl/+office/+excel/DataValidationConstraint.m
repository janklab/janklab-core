classdef DataValidationConstraint < handle
  %
  
  properties
    j
  end
  
  properties (Dependent)
    explicitListValues
    formula1
    formula2
    operator
    validationType
  end
  
  methods
    
    function this = DataValidationConstraint(jObj)
      if nargin == 0
        return
      end
      mustBeA(jObj, 'org.apache.poi.ss.usermodel.DataValidationConstraint');
      this.j = jObj;
    end
    
    function out = get.explicitListValues(this)
      jStrings = this.j.getExplicitListValues;
      if isempty(jStrings)
        out = [];
        return
      end
      out = jl.util.java.convertJavaStringsToMatlab(jStrings);
    end
    
    function out = get.formula1(this)
      out = string(this.j.getFormula1);
    end
    
    function set.formula1(this, val)
      this.j.setFormula1(val);
    end
    
    function out = get.formula2(this)
      out = string(this.j.getFormula2);
    end
    
    function set.formula2(this, val)
      this.j.setFormula2(val);
    end
    
    function out = get.operator(this)
      out = string(this.j.getOperator);
    end
    
    function set.operator(this, val)
      this.j.setOperator(val);
    end
    
    function out = get.validationType(this)
      out = jl.office.excel.DataValidationConstraintValidationType.ofJava(this.j.getValidationType);
    end
    
  end
  
end

