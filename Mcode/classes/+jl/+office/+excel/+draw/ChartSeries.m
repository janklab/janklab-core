classdef ChartSeries < handle
% ChartSeries

  properties
    % The underlying POI org.apache.poi.ss.usermodel.charts.ChartSeries Java object
    j
  end

  methods

    function this = ChartSeries(jObj)
      if nargin == 0
        return
      end
      mustBeA(jObj, 'org.apache.poi.ss.usermodel.charts.ChartSeries');
      this.j = jObj;
    end

    function out = getTitleCellReference(this)
      out = jl.office.excel.CellReference(this.j.getTitleCellReference);
    end
    
    function out = getTitleString(this)
      out = string(this.j.getTitleString);
    end
    
    function out = getTitleType(this)
      out = jl.office.excel.draw.TitleType.ofJava(this.j.getTitleType);
    end
    
    function setTitle(this, val)
      if isa(val, 'jl.office.excel.CellReference')
        this.j.setTitle(val.j);
      elseif isstringy(val)
        this.j.setTitle(string(val));
      else
        error('jl:InvalidInput', 'Invalid input type: need CellReference or string, got %s', ...
          class(val));
      end
    end
    
  end

end
