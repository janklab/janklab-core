classdef Chart < jl.office.excel.draw.Chart & jl.office.excel.draw.ChartAxisFactory
  %CHART 
  
  % TODO: Should getChart*Factory be properties instead?
  
  properties
    titleFormula
    titleText
    plotOnlyVisibleCells
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
      out = this;
    end
    
    function out = getChartDataFactory(this)
      out = jl.office.excel.xlsx.draw.ChartDataFactory(this.j.getChartDataFactory);
    end
    
    function out = getOrCreateLegend(this)
      jObj = this.j.getOrCreateLegend;
      out = jl.office.excel.xlsx.draw.ChartLegend(jObj);
    end
    
    function out = getAxes(this)
      jList = this.j.getAxis;
      out = repmat(jl.office.excel.draw.ChartAxis, [1 jList.size]);
      for i = 1:numel(out)
        out(i) = jl.office.excel.draw.ChartAxis(jList.get(i - 1));
      end
    end
    
    function out = getGraphicFrame(this)
      jObj = this.j.getGraphicFrame;
      out = jl.office.excel.xlsx.draw.GraphicFrame(jObj);
    end
    
    function out = get.titleFormula(this)
      out = string(this.j.getTitleFormula);
    end
    
    function set.titleFormula(this, val)
      this.j.setTitleFormula(string(val));
    end
    
    function out = get.titleText(this)
      out = string(this.j.getTitleText);
    end
    
    function set.titleText(this, val)
      this.j.setTitleText(string(val));
    end
    
    function out = get.plotOnlyVisibleCells(this)
      out = this.j.isPlotOnlyVisibleCells;
    end
    
    function set.plotOnlyVisibleCells(this, val)
      this.j.setPlotOnlyVisibleCells(val);
    end
    
  end
  
end

