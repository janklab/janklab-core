classdef (Abstract) Chart < handle
  %CHART
  
  properties
    j
  end
  
  methods
    
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

