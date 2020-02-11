classdef LineChartData < jl.office.excel.draw.ChartData
% LineChartData

  properties
    % The underlying POI org.apache.poi.ss.usermodel.charts.LineChartData Java object
    j
  end

  methods

    function this = LineChartData(jObj)
      this = this@jl.office.excel.draw.ChartData(jObj);
      mustBeA(jObj, 'org.apache.poi.ss.usermodel.charts.LineChartData');
    end

    function out = addSeries(this, categories, values)
      mustBeA(categories, 'jl.office.excel.draw.LineChartSeries');
      mustBeA(values, 'jl.office.excel.draw.ChartDataSource');
      jObj = this.j.addSeries(categories.toJavaArray, values.j);
      out = jl.office.excel.draw.LineChartSeries(jObj);
    end
    
    function out = getSeries(this)
      jList = this.j.getSeries;
      out = repmat(jl.office.excel.draw.LineChartSeries, [1 jList.size]);
      for i = 1:numel(out)
        out(i) = jl.office.excel.draw.LineChartSeries(jList.get(i - 1));
      end
    end
    
  end

end
