classdef ChartDataFactory < handle
% ChartDataFactory

  properties
    % The underlying POI org.apache.poi.ss.usermodel.charts.ChartDataFactory Java object
    j
  end

  methods

    function this = ChartDataFactory(jObj)
      if nargin == 0
        return
      end
      mustBeA(jObj, 'org.apache.poi.ss.usermodel.charts.ChartDataFactory');
      this.j = jObj;
    end

    function out = createLineChartData(this)
      jObj = this.j.createLineChartData;
      out = jl.office.excel.draw.LineChartData(jObj);
    end
    
    function out = createScatterChartData(this)
      jObj = this.j.createScatterChartData;
      out = jl.office.excel.draw.ScatterChartData(jObj);
    end
    
  end

end
