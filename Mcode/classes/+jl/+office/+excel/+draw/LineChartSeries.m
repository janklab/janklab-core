classdef LineChartSeries < jl.office.excel.draw.ChartSeries
% LineChartSeries

  methods

    function this = LineChartSeries(varargin)
      this = this@jl.office.excel.draw.ChartSeries(varargin{:});
      if nargin == 0
        return
      end
      mustBeA(varargin{1}, 'org.apache.poi.ss.usermodel.charts.LineChartSeries');
    end

    function out = getCategoryAxisData(this)
      jObj = this.j.getCategoryAxisData;
      out = jl.office.excel.draw.ChartDataSource(jObj);
    end
    
    function out = getValues(this)
      jObj = this.j.getValues;
      out = jl.office.excel.draw.ChartDataSource(jObj);
    end
    
  end

end
