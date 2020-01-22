classdef (Abstract) Workbook < jl.util.DisplayableHandle
  % An Excel workbook
  %
  % A Workbook object represents an Excel workbook, of either XLS (Office 97) or
  % XLSX (Office 2007) format. There are format-specific subclasses for each
  % format, but you can generally get by with just coding against the interface
  % of this generic superclass.
  %
  % This class also contains the methods for reading or creating Workbooks of
  % either format.
  %
  % Examples:
  %
  % % Open an existing Excel workbook file for reading
  % wkbk = jl.office.excel.Workbook.openFile('MyExcelFile.xlsx')
  %
  % % Create a new in-memory workbook in Excel 2007 format
  % wkbk = jl.office.excel.Workbook.createNew()
  %
  % % You can also specify the format explicitly:
  % wkbk = jl.office.excel.Workbook.createNew('xlsx')
  %
  % % Create a new in-memory workbook in the legacy Excel 97 format
  % wkbk = jl.office.excel.Workbook.createNew('xls')
  %
  % See also:
  % jl.office.excel.xls.Workbook
  % jl.office.excel.xlsx.Workbook
  
  % TODO: MissingCellPolicy
  % TODO: Sheet reordering
  % TODO: Cross-workbook linking (linkExternalWorkbook())
  % TODO: XLS- and XLSX-specific stuff
  
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
    % Whether this workbook is hidden
    hidden
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
        case {'.xlsx' '.xlsm'}
          jWkbk = org.apache.poi.xssf.usermodel.XSSFWorkbook(jFile);
          out = jl.office.excel.xlsx.Workbook(jWkbk);
        otherwise
          error('jl:InvalidInput', ['Invalid file extension: ''%s''. ' ...
            'Must be ''.xls'', ''.xlsx'', or ''.xlsm'''], ...
            extn);
      end
    end
    
    function out = createNew(format)
      % Create a new workbook
      %
      % out = jl.office.excel.Workbook.createNew(format)
      %
      % Creates a new in-memory workbook in the specified format.
      %
      % Format (string) is the workbook/file format to use. May be "xls" for
      % Excel 97 (".xls") format, or "xlsx" for Excel 2007 (".xlsx") format.
      % Format is optional; the default is "xlsx" (Excel 2007).
      %
      % Returns a new Workbook object of the appropriate subclass.
      if nargin < 1 || isempty(format); format = "xlsx"; end
      
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
    
    % Get the table of data formats used in this workbook.
    %
    % Returns a DataFormatTable object.
    out = getDataFormatTable(this)
    
    % Create a new font and add it to the workbook's font table
    %
    % Returns a Font object.
    out = createFont(this)
    
    % Get all pictures defined in this workbook
    %
    % Returns an array of PictureData objects.
    out = getAllPictures(this)
    
  end
  
  methods
        
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
    
    function out = get.hidden(this)
      out = this.j.isHidden;
    end
    
    function set.hidden(this, val)
      this.j.setHidden(val);
    end
    
    function out = getFontAt(this, idx)
      %GETFONTAT Get font at the given index
      out = this.wrapFontObject(this.j.getFontAt(idx-1));
    end
    
    function out = getPrintArea(this, index)
      % Get the print area for specified sheet
      %
      % out = getPrintArea(obj, index)
      %
      % Index (numeric) is the index of the sheet to get the print area for.
      %
      % Returns a string.
      out = string(this.j.getPrintArea(index-1));
    end
    
    function removePrintArea(this, index)
      % Delete the print area for the specified sheet
      %
      % out = removePrintArea(obj, index)
      %
      % Removes (resets) the print area for the sheet at the given index.
      this.j.removePrintArea(index-1);
    end
    
    function out = getSheet(this, ref)
      %GETSHEET Get a sheet by name or index
      %
      % out = getSheet(this, name)
      % out = getSheet(this, index)
      if isnumeric(ref)
        jSheet = this.j.getSheetAt(ref-1);
      elseif ischar(ref) || isstring(ref)
        jSheet = this.j.getSheet(ref);
      else
        error('Invalid input. Expecting numeric or string; got a %s', class(ref));
      end
      out = this.createSheetObject(this, jSheet);
    end
    
    function removeSheetAt(this, index)
      % Remove the sheet at the given index
      %
      % removeSheetAt(obj, index)
      %
      % Index (scalar numeric) is the index of the sheet to remove.
      this.j.removeSheetAt(index-1);
    end
    
    function setActiveSheet(this, index)
      % Set the active sheet
      %
      % setActiveSheet(obj, index)
      %
      % Sets the sheet at the given index to be the active sheet.
      %
      % Index (scalar numeric) is the index of the sheet to become active.
      this.j.setActiveSheet(index-1);
    end
    
    function out = getSheetIndex(this, sheet)
      % Gets the index of a given sheet
      %
      % out = getSheetIndex(obj, sheet)
      % out = getSheetIndex(obj, sheet)
      %
      % Sheet is a Sheet object from this workbook.
      %
      % Returns a numeric.
      if isstring(sheet)
        out = this.j.getSheetIndex(sheet);
      elseif isa(sheet, jl.office.excel.Sheet)
        out = this.j.getSheetIndex(sheet.j);
      else
        error('jl:InvalidInput', 'Invalid type for sheet; got a %s', class(sheet));
      end
    end
    
    function out = getSheetName(this, index)
      % Get the name for the sheet at a given index
      %
      % out = getSheetName(obj, index)
      %
      % Returns a string.
      out = string(this.j.getSheetName(index-1));
    end
    
    function out = getSheetVisibility(this, index)
      % Get the visibility for a given sheet
      %
      % out = getSheetVisibility(obj, index)
      %
      % Index (numeric) is the index of the sheet to get the visibility for.
      %
      % Returns a SheetVisibility object.
      out = jl.office.excel.SheetVisibility.ofJava(this.j.getSheetVisibility(index-1));
    end
    
    function setSheetVisibility(this, index, visibility)
      mustBeA(visibility, 'jl.office.excel.SheetVisibility');
      this.j.setSheetVisibility(index-1, visibility.j);
    end
    
    function out = isSheetHidden(this, index)
      out = this.j.isSheetHidden(index-1);
    end
    
    function out = isSheetVeryHidden(this, index)
      out = this.j.isSheetVeryHidden(index-1);
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
    
    function out = cloneSheet(this, index)
      out = this.createSheetObject(this.j.cloneSheet(index-1));
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
      out = this.wrapPictureDataObject(this.j.addPicture(pictureData, jFormat));
    end
    
    function out = createName(this)
      % Create a new (uninitialized) defined name in this workbook
      %
      % out = createName(obj)
      %
      % Returns a Name object.
      out = jl.office.excel.Name(this.j.createName);
    end
    
    function removeName(this, name)
      % Remove a previously-defined Name
      %
      % removeName(obj, name)
      %
      % Name (Name object) is the Name to remove.
      this.j.removeName(name.j);
    end
    
    function out = getName(this, name)
      % Looks up a previously-defined Name
      %
      % out = getName(obj, name)
      %
      % Name (string) is the name of the defined Name.
      %
      % Returns a Name object, or empty if not found.
      out = jl.office.excel.Name(this.j.getName(name));
    end
    
    function out = getNames(this, name)
      % Gets all previously-defined Names with the given name
      %
      % out = getNames(obj, name)
      %
      % Name (string) is the name to search for.
      %
      % Returns a Name array, which may be empty if no Names matched the given
      % name.
      list = this.j.getNames(name);
      out = repmat(jl.office.excel.Name, [1 list.size]);
      for i = 1:list.size
        out(i) = jl.office.excel.Name(list.get(i-1));
      end
    end
    
    function out = getAllNames(this)
      % Get all defined Names in this workbook
      %
      % out = getAllNames(obj)
      list = this.j.getAllNames;
      out = repmat(jl.office.excel.Name, [1 list.size]);
      for i = 1:list.size
        out(i) = jl.office.excel.Name(list.get(i-1));
      end
    end
    
    function out = getCellStyleAt(this, index)
      % Get the CellStyle object for a given index
      %
      % out = getCellStyleAt(obj, index)
      %
      % Returns a CellStyle object.
      out = this.wrapCellStyleObject(this.j.getCellStyleAt(index-1));
    end
    
    function out = getSpreadsheetVersion(this)
      % Get the version (format) of this spreadsheet
      %
      % out = getSpreadsheetVersion(obj)
      %
      % This lets you get information about the size limits and other aspects of
      % this version of the Excel spreadsheet format.
      %
      % Returns a SpreadsheetVersion object.
      out = jl.office.excel.SpreadsheetVersion(this.j.getSpreadsheetVersion);
    end
    
    function setSelectedTab(this, index)
      % Set the tab whose data is actually seen when the workbook is opened
      %
      % setSelectedTab(this, index)
      %
      % Index (scalar numeric) is the index of the sheet.
      this.j.setSelectedTab(index-1);
    end
    
    function setSheetHidden(this, index, hidden)
      % Hide or unhide a sheet
      %
      % setSheetHidden(this, index, hidden)
      %
      % Index (scalar numeric) is the index of the sheet to hide or unhide.
      %
      % Hidden (scalar logical) is whether it should be visible.
      this.j.setSheetHidden(index-1, hidden);
    end
    
    function setSheetName(this, index, name)
      this.j.setSheetName(index-1, name);
    end
      
    function close(this)
      % Close the connection to the file, if there is one
      %
      % After this method is called, the Workbook object can no longer be used.
      % (I think.)
      this.j.close;
    end
    
  end
  
  methods (Access = protected)
    
    function this = Workbook()
      %WORKBOOK Construct a new object
      %
      % obj = jl.office.excel.Workbook()
      
      % Nothing to do in the superclass; everything is done by the subclass.
    end
    
    function out = dispstr_scalar(this)
      out = sprintf('[Workbook: format=%s, %d sheets]', ...
        this.fileFormat, this.numberOfSheets);
    end
    
  end
  
  methods (Abstract, Access = protected)
    out = wrapSheetObject(this, jObj)
    out = wrapCellStyleObject(this, jObj)
    out = wrapPictureDataObject(this, jObj)
    out = wrapFontObject(this, jObj)
    out = fileFormat(this)
  end
  
end