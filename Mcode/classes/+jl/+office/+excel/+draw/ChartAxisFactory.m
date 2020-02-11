classdef ChartAxisFactory < handle
% ChartAxisFactory

  properties
    % The underlying POI org.apache.poi.ss.usermodel.charts.ChartAxisFactory Java object
    j
  end

  methods

    function this = ChartAxisFactory(jObj)
      if nargin == 0
        return
      end
      mustBeA(jObj, 'org.apache.poi.ss.usermodel.charts.ChartAxisFactory');
      this.j = jObj;
    end
    
    function out = createCategoryAxis(position)
      mustBeA(position, 'jl.office.excel.draw.AxisPosition');
      jObj = this.j.createCategoryAxis(position.j);
      out = jl.office.excel.draw.ChartAxis(jObj);
    end

    function out = createDateAxis(position)
      mustBeA(position, 'jl.office.excel.draw.AxisPosition');
      jObj = this.j.createDateAxis(position.j);
      out = jl.office.excel.draw.ChartAxis(jObj);
    end

    function out = createValueAxis(position)
      mustBeA(position, 'jl.office.excel.draw.AxisPosition');
      jObj = this.j.createValueAxis(position.j);
      out = jl.office.excel.draw.ValueAxis(jObj);
    end

  end

end
