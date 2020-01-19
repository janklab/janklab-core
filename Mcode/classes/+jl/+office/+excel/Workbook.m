classdef Workbook < handle
  % An Excel workbook
  
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
    function out = fromFile(file)
      jFile = java.io.File(file);
      jWkbk = org.apache.xssf.usermodel.XSSFWorkbook(jFile);
      out = jl.office.excel.Workbook(jWkbk);
    end
  end
  
  methods
    
    function this = Workbook(varargin)
      %WORKBOOK Construct a new object
      %
      % obj = jl.office.excel.Workbook()
      %
      % If no arguments are given, constructs a new in-memory Workbook.
      if nargin == 0
        this.j = org.apache.poi.xssf.usermodel.XSSFWorkbook();
        return
      end
      if nargin == 1 && isa(varargin{1}, 'org.apache.poi.ss.usermodel.Workbook')
        % Wrap Java object
        this.j = varargin{1};
        return
      end
      error('Invalid input for constructor');
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
      out = jl.office.excel.Sheet(jSheet);
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
      out = jl.office.excel.Sheet(this, jSheet);
    end
    
    function write(this, file)
      %WRITE Write this workbook out to a file in .xlsx format
      %
      % write(obj, file)
      %
      % file (char, str) is the path to the file to write out to. Overwrites any
      % existing file.
      %
      % Throws an error if the write operation fails for any reason.
      jOutStream = java.io.FileOutputStream(file);
      this.j.write(jOutStream);
    end
    
  end
  
end