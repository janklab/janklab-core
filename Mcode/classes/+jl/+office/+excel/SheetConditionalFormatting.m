classdef (Abstract) SheetConditionalFormatting < jl.util.DisplayableHandle
  % The conditional formatting controls for a single sheet
  %
  % A SheetConditionalFormatting object contains all the conditional formatting
  % controls for a single sheet. This includes the conditional formatting rules
  % and the ranges they apply to.
  
  properties
    j
  end
  
  properties (Dependent)
    numConditionalFormattings
  end
  
  methods
    
    function this = SheetConditionalFormatting(jObj)
      if nargin == 0
        return
      end
      mustBeA(jObj, 'org.apache.poi.ss.usermodel.SheetConditionalFormatting');
    end
    
    function out = get.numConditionalFormattings(this)
      out = this.j.getNumConditionalFormattings;
    end
    
    function removeConditionalFormattingAt(index)
      this.j.removeConditionalFormatting(index - 1);
    end
    
    function out = addConditionalFormatting(this, varargin)
      % Add conditional formatting
      %
      % out = addConditionalFormatting(this, conditionalFormatting)
      % out = addConditionalFormatting(this, rangeAddrs, rules)
      narginchk(2, 3);
      if nargin == 2
        [conditionalFormatting] = varargin{:};
        jIndex = this.j.addConditionalFormatting(conditionalFormatting.j);
        out = jIndex + 1;
      else
        [rangeAddrs, rules] = varargin{:};
        rangeAddrs = jl.office.excel.CellRangeAddress(rangeAddrs);
        mustBeA(rules, 'jl.office.excel.ConditionalFormattingRule');
        jRangeAddrs = rangeAddrs.toJavaArray;
        jRules = rules.rule.toJavaArray;
        jIndex = this.j.addConditionalFormatting(jRangeAddrs, jRules);
        out = jIndex + 1;
      end
    end
    
    function out = createConditionalFormattingColorScaleRule(this)
      out = this.wrapConditionalFormattingRuleObject(...
        this.j.createConditionalFormattingColorScaleRule);
    end
    
    % TODO: The other create* methods and calling forms
    
    function out = createConditionalFormattingRule(this, varargin)
      narginchk(2, 4);
      if nargin == 2
        arg = varargin{1};
        if isstringy(arg)
          jRule = this.j.createConditionalFormattingRule(arg);
        else
          UNIMPLEMENTED
        end
      elseif nargin == 3
        UNIMPLEMENTED
      elseif nargin == 4
        UNIMPLEMENTED
      end
      out = this.wrapConditionalFormattingRuleObject(jRule);
    end
    
    function out = getConditionalFormattingAt(this, index)
      jCondForm = this.j.getConditionalFormattingAt(index - 1);
      out = this.wrapConditionalFormattingObject(jCondForm);
    end
    
  end
  
  methods (Abstract, Access = protected)
    out = wrapConditionalFormattingRuleObject(this, jObj)
    out = wrapConditionalFormattingObject(this, jObj)
  end
  
end