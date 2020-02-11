classdef Chart < jl.office.excel.draw.Chart
  %CHART 
  
  properties
  end
  
  methods
    
    function this = Chart(jObj)
      if nargin == 0
        return
      end
      mustBeA(jObj, 'org.apache.poi.xssf.usermodel.Chart');
      this.j = jObj;
    end
    
    function out = getAxis(this)
      jList = this.j.getAxis;
      out = repmat(jl.office.excel.xlsx.draw.Axis, [1 jList.size]);
      for i = 1:numel(out)
        out(i) = jl.office.excel.xlsx.draw.Axis(jList.get(i - 1));
      end
    end
    
    function out = getChartAxisFactory(this)
      out = jl.office.excel.xlsx.draw.ChartAxisFactory(this.j.getChartAxisFactory);
    end
    
    function out = getChartDataFactory(this)
      out = jl.office.excel.xlsx.draw.ChartDataFactory(this.j.getChartDataFactory);
    end
    
    function out = getOrCreateLegend(this)
      out = jl.office.excel.xlsx.draw.ChartLegend(this.j.getOrCreateLegend);
    end
    
  end
end

