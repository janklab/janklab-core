classdef TextBox < jl.office.excel.xlsx.draw.SimpleShape
% TextBox

  methods

    function this = TextBox(varargin)
      this = this@jl.office.excel.xlsx.draw.SimpleShape(varargin{:});
      if nargin == 0
        return
      end
      mustBeA(varargin{1}, 'org.apache.poi.xssf.usermodel.XSSFTextBox');
    end

  end

end
