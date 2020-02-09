classdef (Abstract) ConditionalFormattingRule < handle
  
  properties
    j
  end
  
  properties (Dependent)
    colorScaleFormatting
    comparisonOperation
    conditionFilterType
    conditionType
    dataBarFormatting
    filterConfiguration
    fontFormatting
    formula1
    formula2
    multiStateFormatting
    numberFormat
    patternFormatting
    priority
    stopIfTrue
    text
  end
  
  methods
    
    function this = ConditionalFormattingRule(jObj)
      if nargin == 0
        return
      end
      mustBeA(jObj, 'org.apache.poi.ss.usermodel.ConditionalFormattingRule');
      this.j = jObj;
    end
    
    function out = createBorderFormatting(this)
      out = this.wrapBorderFormattingObject(this.j.createBorderFormatting);
    end
    
    function out = createFontFormatting(this)
      out = this.wrapFontFormattingObject(this.j.createFontFormatting);
    end
    
    function out = createPatternFormatting(this)
      out = this.wrapPatternFormattingObject(this.j.createPatternFormatting);
    end
    
    function out = get.colorScaleFormatting(this)
      jObj = this.j.getColorScaleFormatting;
      if isempty(jObj)
        out = [];
      else
        out = this.wrapColorScaleFormattingObject(jObj);
      end
    end
    
    function out = get.comparisonOperation(this)
      out = this.j.getComparisonOperation;
    end
    
    function out = get.conditionFilterType(this)
      jObj = this.j.getConditionFilterType;
      if isempty(jObj)
        out = [];
      else
        out = this.wrapConditionFilterTypeObject(jObj);
      end
    end
    
    function out = get.conditionType(this)
      out = jl.office.excel.ConditionType(this.j.getConditionType);
    end
    
    function out = get.dataBarFormatting(this)
      jObj = this.j.getDataBarFormatting;
      if isempty(jObj)
        out = [];
      else
        out = this.wrapDataBarFormattingObject(jObj);
      end
    end
    
    function out = get.filterConfiguration(this)
      jObj = this.j.getFilterConfiguration;
      if isempty(jObj)
        out = [];
      else
        out = this.wrapFilterConfigurationObject(jObj);
      end
    end
    
    function out = get.fontFormatting(this)
      jObj = this.j.getFontFormatting;
      if isempty(jObj)
        out = [];
      else
        out = this.wrapConditionFontFormattingObject(jObj);
      end
    end
    
    function out = get.formula1(this)
      out = string(this.j.getFormula1);
    end
      
    function out = get.formula2(this)
      out = string(this.j.getFormula2);
    end
    
    function out = get.multiStateFormatting(this)
      jObj = this.j.getMultiStateFormatting;
      if isempty(jObj)
        out = [];
      else
        out = this.wrapIconMultiStateFormattingObject(jObj);
      end
    end
    
    function out = get.numberFormat(this)
      jObj = this.j.getNubmerFormat;
      if isempty(jObj)
        out = [];
      else
        out = this.wrapExcelNumberFormatObject(jObj);
      end
    end
    
    function out = get.patternFormatting(this)
      jObj = this.j.getPatternFormatting;
      if isempty(jObj)
        out = [];
      else
        out = this.wrapPatternFormattingObject(jObj);
      end
    end
    
    function out = get.priority(this)
      out = this.j.getPriority;
    end
    
    function out = get.stopIfTrue(this)
      out = this.j.getStopIfTrue;
    end
    
    function out = get.text(this)
      out = string(this.j.getText);
    end
    
  end
  
  methods (Abstract, Access = protected)
    out = wrapBorderFormattingObject(this, jObj)
    out = wrapDataBarFormattingObject(this, jObj)
    out = wrapFilterConfigurationObject(this, jObj)
    out = wrapFontFormattingObject(this, jObj)
    out = wrapIconMultiStateFormattingObject(this, jObj)
    out = wrapExcelNumberFormatObject(this, jObj)
    out = wrapPatternFormattingObject(this, jObj)
  end
  
end