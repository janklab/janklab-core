classdef ConditionalFormattingRule < jl.office.excel.ConditionalFormattingRule
  
  %#ok<*INUSL>
  
  methods

    function this = ConditionalFormattingRule(jObj)
      if nargin == 0
        return
      end
      mustBeA(jObj, 'org.apache.poi.hssf.usermodel.HSSFConditionalFormattingRule');
      this.j = jObj;
    end
    
  end
  
  methods (Access = protected)
    function out = wrapBorderFormattingObject(this, jObj)
      out = jl.office.excel.xl.cf.BorderFormatting(jObj);
    end
    
    function out = wrapDataBarFormattingObject(this, jObj)
      out = jl.office.excel.xls.DataBarFormatting(jObj);
    end
    
    function out = wrapFilterConfigurationObject(this, jObj)
      out = jl.office.excel.xls.BorderFormatting(jObj);
    end
    
    function out = wrapFontFormattingObject(this, jObj)
      out = jl.office.excel.xls.FontFormatting(jObj);
    end
    
    function out = wrapIconMultiStateFormattingObject(this, jObj)
      out = jl.office.excel.xls.IconMultiStateFormatting(jObj);
    end
    
    function out = wrapExcelNumberFormatObject(this, jObj)
      UNIMPLEMENTED
    end
    
    function out = wrapPatternFormattingObject(this, jObj)
      out = jl.office.excel.xls.PatternFormatting(jObj);
    end
  end
  
end

