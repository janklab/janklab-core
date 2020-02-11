classdef ConditionalFormattingThresholdRangeType
  %
  
  enumeration
    Formula(jl.util.java.getStaticFieldOnClass(...
      'org.apache.poi.ss.usermodel.ConditionalFormattingThreshold$RangeType', 'FORMULA'))
    Max(jl.util.java.getStaticFieldOnClass(...
      'org.apache.poi.ss.usermodel.ConditionalFormattingThreshold$RangeType', 'MAX'))
    Min(jl.util.java.getStaticFieldOnClass(...
      'org.apache.poi.ss.usermodel.ConditionalFormattingThreshold$RangeType', 'MIN'))
    Number(jl.util.java.getStaticFieldOnClass(...
      'org.apache.poi.ss.usermodel.ConditionalFormattingThreshold$RangeType', 'NUMBER'))
    Percent(jl.util.java.getStaticFieldOnClass(...
      'org.apache.poi.ss.usermodel.ConditionalFormattingThreshold$RangeType', 'PERCENT'))
    Percentile(jl.util.java.getStaticFieldOnClass(...
      'org.apache.poi.ss.usermodel.ConditionalFormattingThreshold$RangeType', 'PERCENTILE'))
    Unallocated(jl.util.java.getStaticFieldOnClass(...
      'org.apache.poi.ss.usermodel.ConditionalFormattingThreshold$RangeType', 'UNALLOCATED'))
  end
  
  properties
    j
  end
  
  methods (Static)
    
    function out = ofJava(jObj)
      if isempty(jObj)
        out = [];
      elseif jObj.equals(jl.util.java.getStaticFieldOnClass(...
          'org.apache.poi.ss.usermodel.ConditionalFormattingThreshold$RangeType', 'FORMULA'))
        out = jl.office.excel.condformat.ConditionalFormattingThresholdRangeType.Formula;
      elseif jObj.equals(jl.util.java.getStaticFieldOnClass(...
          'org.apache.poi.ss.usermodel.ConditionalFormattingThreshold$RangeType', 'MAX'))
        out = jl.office.excel.condformat.ConditionalFormattingThresholdRangeType.Max;
      elseif jObj.equals(jl.util.java.getStaticFieldOnClass(...
          'org.apache.poi.ss.usermodel.ConditionalFormattingThreshold$RangeType', 'MIN'))
        out = jl.office.excel.condformat.ConditionalFormattingThresholdRangeType.Min;
      elseif jObj.equals(jl.util.java.getStaticFieldOnClass(...
          'org.apache.poi.ss.usermodel.ConditionalFormattingThreshold$RangeType', 'NUMBER'))
        out = jl.office.excel.condformat.ConditionalFormattingThresholdRangeType.Number;
      elseif jObj.equals(jl.util.java.getStaticFieldOnClass(...
          'org.apache.poi.ss.usermodel.ConditionalFormattingThreshold$RangeType', 'PERCENT'))
        out = jl.office.excel.condformat.ConditionalFormattingThresholdRangeType.Percent;
      elseif jObj.equals(jl.util.java.getStaticFieldOnClass(...
          'org.apache.poi.ss.usermodel.ConditionalFormattingThreshold$RangeType', 'PERCENTILE'))
        out = jl.office.excel.condformat.ConditionalFormattingThresholdRangeType.Percentile;
      elseif jObj.equals(jl.util.java.getStaticFieldOnClass(...
          'org.apache.poi.ss.usermodel.ConditionalFormattingThreshold$RangeType', 'UNALLOCATED'))
        out = jl.office.excel.condformat.ConditionalFormattingThresholdRangeType.Unallocated;
      else
        BADSWITCH
      end
    end
    
  end
  
  
  methods
    
    function out = toJava(this)
      out = this.j;
    end
    
    function out = toJavaArray(this)
      out = javaArray('org.apache.poi.ss.usermodel.ConditionalFormattingThreshold$RangeType', numel(this));
      for i = 1:numel(this)
        out(i) = this(i).toJava;
      end
    end
    
  end
  
  methods (Access = private)
    
    function this = ConditionalFormattingThresholdRangeType(jObj)
      this.j = jObj;
    end
    
  end
  
end

