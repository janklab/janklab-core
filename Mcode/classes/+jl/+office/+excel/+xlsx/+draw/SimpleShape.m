classdef SimpleShape < jl.office.excel.draw.SimpleShape & jl.office.excel.xlsx.draw.Shape
  % SimpleShape
  
  properties (Dependent)
    bottomInset
    leftInset
    RightInset
    shapeType
    text
    textAutofit
    textDirection
    textHorizontalOverflow
    textVerticalOverflow
    topInset
    verticalAlignment
    wordWrap
  end
  
  methods
    
    function this = SimpleShape(varargin)
      this = this@jl.office.excel.xlsx.draw.Shape(varargin{:});
      if nargin == 0
        return
      end
      mustBeA(varargin{1}, 'org.apache.poi.xssf.usermodel.XSSFSimpleShape');
    end
    
    % TODO: Finish this class
    
  end
  
end