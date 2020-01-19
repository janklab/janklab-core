classdef Workbook < jl.office.excel.Workbook
  
  properties
  end
  
  methods
    
    function this = Workbook(varargin)
      if nargin == 0
        this.j = org.apache.poi.hssf.usermodel.HSSFWorkbook();
        return
      end
      if nargin == 1 && isa(varargin{1}, 'org.apache.poi.hssf.usermodel.HSSFWorkbook')
        % Wrap Java object
        this.j = varargin{1};
        return
      end
      error('Invalid input for constructor');
    end

    function write(this, file)
      jFile = java.io.File(file);
      this.j.write(jFile);
    end
    
  end
  
  methods (Access = protected)
    
    function out = wrapSheetObject(this, jObj)
      out = jl.office.excel.hssf.Sheet(this, jObj);
    end
    
    function out = wrapCellStyleObject(this, jObj)
      out = jl.office.excel.hssf.CellStyle(this, jObj);
    end
    
  end
  
end