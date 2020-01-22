classdef (Abstract) Workbook < jl.util.DisplayableHandle
  % An Excel workbook
  %
  
  properties
    % The underlying Java POI XSSFWorkbook object
    j
  end
  
  properties (Dependent)
    % Index of the "active" sheet; the one that is displayed when the workbook
    % is opened.
    activeSheetIndex
    % Whether the Excel GUI will back up the workbook when saving
    backupFlag
    % The index of the first tab that is displayed in the tab list in the Excel
    % GUI
    firstVisibleTab
    % Whether Exel will be asked to recalculate all formulas upon opening
    forceFormulaRecalculation
    % Number of fonts in the font table
    numberOfFonts
    % Number of Names in this workbook
    numberOfNames
    % Number of Sheets in this workbook
    numberOfSheets
    % Number of cell styles in this workbook
    numberOfCellStyles
  end
  
  methods (Static)
    function out = openFile(file)
      % Open an existing .xls or .xlsx file for reading
      %
      % out = jl.office.excel.Workbook.openFile(file)
      %
      % Opens an existing Excel file for reading. The format (Excel 97 or Excel
      % 2007) is detected based on the file extension.
      %
      % file (string) is the path to the file to open. It must end in the
      % extension '.xls' or '.xlsx' (case-insensitive).
      %
      % Returns a Workbook subclass of the appropriate type for the workbook
      % file's format.
      [~,~,extn] = fileparts(file);
      jFile = java.io.File(file);
      switch lower(extn)
        case '.xls'
          jWkbk = org.apache.poi.hssf.usermodel.HSSFWorkbook(jFile);
          out = jl.office.excel.xls.Workbook(jWkbk);
        case '.xlsx'
          jWkbk = org.apache.poi.xssf.usermodel.XSSFWorkbook(jFile);
          out = jl.office.excel.xlsx.Workbook(jWkbk);
        otherwise
          error('jl:InvalidInput', ['Invalid file extension: ''%s''. ' ...
            'Must be ''.xls'' or ''.xlsx'''], ...
            extn);
      end
    end
    
    function out = createNew(format)
      narginchk(1, 1);
      switch lower(format)
        case 'xls'
          jWkbk = org.apache.poi.hssf.usermodel.HSSFWorkbook();
          out = jl.office.excel.xls.Workbook(jWkbk);
        case 'xlsx'
          jWkbk = org.apache.poi.xssf.usermodel.XSSFWorkbook();
          out = jl.office.excel.xlsx.Workbook(jWkbk);
        otherwise
          error('jl:InvalidInput', 'Invalid format: ''%s''. Must be ''xls'' or ''xlsx''', ...
            format);
      end
    end
  end
  
  methods (Abstract)
    % Save this workbook to a file
    %
    % save(obj, file)
    %
    % File (char) is the path to the file to save the workbook to. Overwrites
    % any existing file at that location.
    %
    % Raises an error if the file I/O operation fails.
    save(this, file)
    
    % Create a new cell style
    %
    % out = createCellStyle(obj)
    %
    % Creates a new cell style and adds it to this workbook's style table.
    %
    % Returns a jl.office.excel.CellStyle object.
    out = createCellStyle(this)
    
    
  end
  
  methods
    
    function this = Workbook(varargin)
      %WORKBOOK Construct a new object
      %
      % obj = jl.office.excel.Workbook()
    end
    
    function out = get.activeSheetIndex(this)
      out = this.j.getActiveSheetIndex;
    end
    
    function out = get.backupFlag(this)
      out = this.j.getBackupFlag;
    end
    
    function set.backupFlag(this, val)
      mustBeScalarLogical(val);
      this.j.setBackupFlag(val);
    end
    
    function out = get.firstVisibleTab(this)
      out = this.j.getFirstVisibleTab;
    end
    
    function set.firstVisibleTab(this, val)
      mustBeScalarNumeric(val);
      this.j.setFirstVisibleTab(val);
    end
    
    function out = get.forceFormulaRecalculation(this)
      out = this.j.getForceFormulaRecalculation;
    end
    
    function set.forceFormulaRecalculation(this, val)
      this.j.setForceFormulaRecalculation(val);
    end
    
    function out = get.numberOfFonts(this)
      out = this.j.getNumberOfFontsAsInt;
    end
    
    function out = get.numberOfNames(this)
      out = this.j.getNumberOfNames;
    end
    
    function out = get.numberOfSheets(this)
      out = this.j.getNumberOfSheets;
    end
    
    function out = get.numberOfCellStyles(this)
      out = this.j.getNumCellStyles;
    end
    
    function out = getFontAt(this, idx)
      %GETFONTAT Get font at the given index
      out = jl.office.excel.Font(this.j.getFontAt(idx));
    end
    
    function out = getSheet(this, ref)
      %GETSHEET Get a sheet by name or index
      %
      % out = getSheet(this, name)
      % out = getSheet(this, index)
      if isnumeric(ref)
        jSheet = this.j.getSheetAt(ref);
      elseif ischar(ref) || isstring(ref)
        jSheet = this.j.getSheet(ref);
      else
        error('Invalid input. Expecting numeric or string; got a %s', class(ref));
      end
      out = this.createSheetObject(this, jSheet);
    end
    
    function out = createSheet(this, name)
      %CREATESHEET Create a new sheet
      %
      % out = createSheet(obj)
      % out = createSheet(obj, name)
      %
      % Creates a new sheet in this workbook.
      %
      % name (char, string) is an optional name to give the new sheet. If
      % omitted, it uses whatever default name the library wants to pick.
      %
      % Returns a jl.office.excel.Sheet object.
      if nargin == 1
        jSheet = this.j.createSheet;
      else
        jSheet = this.j.createSheet(name);
      end
      out = this.createSheetObject(this, jSheet);
    end
    
    function out = cloneSheet(this, sheetNum)
      out = this.createSheetObject(this.j.cloneSheet(sheetNum));
    end
    
    function out = addPicture(this, pictureData, format)
      % Adds a picture to the workbook
      %
      % pictureData (uint8) is the bytes of picture data.
      %
      % format (char) is the format the picture data is in. Valid values: 'DIB',
      % 'EMF', 'JPEG', 'PICT', 'PNG', 'WMF'.
      %
      % Returns the index to this picture.
      mustBeA(pictureData, 'uint8');
      mustBeMember(upper(format), ["DIB" "EMF" "JPEG" "PICT" "PNG" "WMF"]);
      switch upper(format)
        case 'DIB'
          jFormat = org.apache.poi.ss.usermodel.Workbook.PICTURE_TYPE_DIB;
        case 'EMF'
          jFormat = org.apache.poi.ss.usermodel.Workbook.PICTURE_TYPE_EMF;
        case 'JPEG'
          jFormat = org.apache.poi.ss.usermodel.Workbook.PICTURE_TYPE_JPEB;
        case 'PICT'
          jFormat = org.apache.poi.ss.usermodel.Workbook.PICTURE_TYPE_PICT;
        case 'PNG'
          jFormat = org.apache.poi.ss.usermodel.Workbook.PICTURE_TYPE_PNG;
        case 'WMF'
          jFormat = org.apache.poi.ss.usermodel.Workbook.PICTURE_TYPE_WMF;
        otherwise
          BADSWITCH
      end
      out = this.j.addPicture(pictureData, jFormat);
    end
    
    function out = getDataFormats(this)
      out = this.createDataFormat;
    end
    
    function close(this)
      this.j.close;
    end
    
  end
  
  methods (Access = protected)
    
    function out = dispstr_scalar(this)
      out = sprintf('[Workbook: format=%s, %d sheets]', ...
        this.fileFormat, this.numberOfSheets);
    end
    
  end
  
  methods (Abstract, Access = protected)
    out = wrapSheetObject(this, jObj)
    out = wrapCellStyleObject(this, jObj)
    out = fileFormat(this)
  end
  
end