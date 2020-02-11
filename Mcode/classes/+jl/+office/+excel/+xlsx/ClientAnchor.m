classdef ClientAnchor < jl.office.excel.ClientAnchor
% ClientAnchor

  methods

    function this = ClientAnchor(varargin)
      this = this@jl.office.excel.ClientAnchor(varargin{:});
      if nargin == 0
        return
      end
      mustBeA(varargin{1}, 'org.apache.poi.xssf.usermodel.XSSFClientAnchor');
    end

  end

end
