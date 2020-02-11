classdef ScatterChartData < jl.office.excel.draw.ChartData
% ScatterChartData

  properties
    % The underlying POI org.apache.poi.ss.usermodel.charts.ScatterChartData Java object
    j
  end

  methods

    function this = ScatterChartData(jObj)
      this = this@jl.office.excel.draw.ChartData(jObj);
      mustBeA(jObj, 'org.apache.poi.ss.usermodel.charts.ScatterChartData');
    end
    
    function out = addSeries(this, xData, yData)
      mustBeA(xData, 'jl.office.excel.draw.ChartDataSource');
      mustBeA(yData, 'jl.office.excel.draw.ChartDataSource');
      % Yes, that's a typo in the POI API
      jObj = this.j.addSerie(xData.j, yData.toJavaArray);
      out = jl.office.excel.draw.ScatterChartSeries(jObj);
    end
    
    function out = getSeries(this)
      jList = this.j.getSeries;
      out = repmat(jl.office.excel.draw.ScatterChartSeries, [1 jList.size])
      for i = 1:numel(out)
        out(i) = jList.get(i);
      end
    end
    
  end

end
