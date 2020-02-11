classdef ScatterChartSeries < jl.office.excel.draw.ChartSeries
% ScatterChartSeries

  properties
    % The underlying POI org.apache.poi.ss.usermodel.charts.ScatterChartSeries Java object
    j
  end

  properties (Dependent)
    xValues
    yValues
  end
  
  methods

    function this = ScatterChartSeries(varargin)
      this = this@jl.office.excel.draw.ChartSeries(varargin{:});
      if nargin == 0
        return
      end
      mustBeA(varargin{1}, 'org.apache.poi.ss.usermodel.charts.ScatterChartSeries');
    end

    function out = get.xValues(this)
      jObj = this.j.getXValues;
      out = jl.office.excel.draw.ChartDataSource(jObj);
    end
    
    function out = get.yValues(this)
      jObj = this.j.getYValues;
      out = jl.office.excel.draw.ChartDataSource(jObj);
    end
    
  end

end
