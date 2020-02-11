classdef ValueAxis < jl.office.excel.draw.ChartAxis
% ValueAxis

  methods

    function this = ValueAxis(varargin)
      this = this@jl.office.excel.draw.ChartAxis(varargin{:});
    end

    function out = getCrossBetween(this)
      jObj = this.j.getCrossBetween;
      out = jl.office.excel.draw.AxisCrossBetween.ofJava(jObj);
    end
    
    function setCrossBetween(this, crossBetween)
      mustBeA(crossBetween, 'jl.office.excel.draw.AxisCrossBetween');
      this.j.setCrossBetween(crossBetween.j);
    end
    
  end

end
