classdef ConditionalFormatting < jl.util.DisplayableHandle
  % A Conditional Formatting directive
  %
  % This consists of a list of conditional formatting rules, and a set of ranges
  % to which they are applied.
  
  properties
    j
  end
  properties (Dependent)
    numRules
    numFormattingRanges
  end
  
  methods
    
    function this = ConditionalFormatting(jObj)
      if nargin == 0
        return
      end
      mustBeA(jObj, 'org.apache.poi.ss.usermodel.ConditionalFormatting');
      this.j = jObj;
    end
    
    function out = get.numRules(this)
      out = this.j.getNumberOfRules;
    end
    
    function out = get.numFormattingRanges(this)
      jRanges = this.j.getFormattingRanges;
      out = numel(jRanges);
    end
    
    function addRule(this, cfRule)
      mustBeA(cfRule, 'jl.office.excel.ConditionalFormattingRule');
      this.j.addRule(cfRule.j);
    end
    
    function out = getFormattingRanges(this)
      out = jl.office.excel.CellRangeAddress(this.j.getFormattingRanges);
    end
    
    function setFormattingRanges(this, rangeAddrs)
      rangeAddrs = jl.office.excel.CellRangeAddress(rangeAddrs);
      this.j.setFormattingRanges(rangeAddrs.toJavaArray);
    end
    
    function setRule(this, index, cfRule)
      mustBeA(cfRule, 'jl.office.excel.ConditionalFormattingRule');
      this.j.setRule(index - 1, cfRule.j);
    end
    
  end
  
  methods (Access = protected)
    
    function out = dispstr_scalar(this)
      out = sprintf('[ConditionalFormatting: %d rules, %d ranges]', ...
        this.numRules, this.numFormattingRanges);
    end
    
  end
  
end