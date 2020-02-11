classdef (Abstract) Chart < jl.office.excel.draw.ManuallyPositionable
  %CHART
  
  properties (SetAccess = protected)
    j
  end
  
  methods
    
    function this = ChartLegend(jObj)
      if nargin == 0
        return
      end
      mustBeA(jObj, 'org.apache.poi.ss.usermodel.Chart');
      this.j = jObj;
    end
    
    function deleteLegend(this)
      this.j.deleteLegend;
    end
    
    function plot(this, data, axes)
      jAxes = javaArray('org.apache.poi.ss.usermodel.ChartAxis', [1 numel(axes)]);
      for i = 1:numel(axes)
        jAxes(i) = axes(i).j;
      end
      this.j.plot(data.j, axes.toJavaArray);
    end
    
  end

  methods (Abstract)
    out = getAxis(this)
    out = getChartAxisFactory(this)
    out = getChartDataFactory(this)
    out = getOrCreateLegend(this)
  end
  
end

