classdef Workbook < jl.office.excel.Workbook
  % An XLS (Excel 97) format Workbook
  
  % TODO: OLE2 embedding support
  % TODO: backupFlag
  % TODO: getCustomPalette
  % TODO: getEncryptionInfo
  % TODO: NameRecord?
  % TODO: get/setSelectedTabs
  % TODO: [un]writeProtectWorkbook
  % TODO: save back to currently-open file (write() with 0 args)
  
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
    
    function save(this, file)
      jFile = java.io.File(file);
      this.j.write(jFile);
    end
    
    function out = createCellStyle(this)
      out = jl.office.excel.xls.CellStyle(this.j.createCellStyle);
    end
    
    function out = getDataFormatTable(this)
      out = jl.office.excel.xls.DataFormatTable(this.j.createDataFormat);
    end
    
    function out = createFont(this)
      out = jl.office.excel.xls.Font(this.j.createFont);
    end
    
    function out = createName(this)
      out = jl.office.excel.xls.Name(this.j.createName);
    end
    
    function out = getAllPictures(this)
      list = this.j.getAllPictures;
      out = repmat(jl.office.excel.xls.PictureData, [1 list.size]);
      for i = 1:list.size
        out(i) = jl.office.excel.xls.PictureData(list.get(i-1));
      end
    end
    
  end
  
  methods (Access = protected)
    
    function out = fileFormat(this) %#ok<MANU>
      out = 'xls';
    end
    
    function out = wrapSheetObject(this, jObj)
      out = jl.office.excel.xls.Sheet(this, jObj);
    end
    
    function out = wrapCellStyleObject(this, jObj)
      out = jl.office.excel.xls.CellStyle(this, jObj);
    end
    
    function out = wrapPictureDataObject(this, jObj) %#ok<INUSL>
      out = jl.office.excel.xls.PictureData(jObj);
    end
    
    function out = wrapFontObject(this, jObj) %#ok<INUSL>
      out = jl.office.excel.xls.Font(jObj);
    end
    
  end
  
end