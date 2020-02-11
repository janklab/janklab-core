classdef ChartData < handle
% ChartData

  properties
    % The underlying POI org.apache.poi.ss.usermodel.charts.ChartData Java object
    j
  end

  methods

    function this = ChartData(jObj)
      if nargin == 0
        return
      end
      mustBeA(jObj, 'org.apache.poi.ss.usermodel.charts.ChartData');
      this.j = jObj;
    end

    function fillChart(this, chart, axes)
      mustBeA(chart, 'jl.office.excel.draw.Chart');
      mustBeA(axes, 'jl.office.excel.draw.ChartAxis');
      this.j.fillChart(chart.j, axes.toJavaArray);
    end
    
  end

end
