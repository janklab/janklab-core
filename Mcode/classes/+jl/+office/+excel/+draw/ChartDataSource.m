classdef ChartDataSource < handle
% ChartDataSource

  properties
    % The underlying POI org.apache.poi.ss.usermodel.charts.ChartDataSource Java object
    j
  end

  properties (Dependent)
    formulaString
    numPoints
    isNumeric
    isReference
  end
  
  methods

    function this = ChartDataSource(jObj)
      if nargin == 0
        return
      end
      mustBeA(jObj, 'org.apache.poi.ss.usermodel.charts.ChartDataSource');
      this.j = jObj;
    end
    
    function out = get.formulaString(this)
      out = string(this.j.getFormulaString);
    end
    
    function out = getPointAt(this, index)
      out = this.j.getPointAt(index - 1);
    end
    
    function out = get.numPoints(this)
      out = this.j.getPointCount;
    end
    
    function out = get.isNumeric(this)
      out = this.j.isNumeric;
    end
    
    function out = get.isReference(this)
      out = this.j.isReference;
    end

  end

end
