classdef Sheet < jl.office.excel.Sheet
  % A sheet in an XLSX workbook
  %
  % NOTE: Most of the header/footer stuff is currently broken because the
  % version of Apache POI shipped with Matlab is too old (as of Matlab R2020a).
  % The regular header and footer properties will work, but
  % headerFooterProperties and all the even/odd/first(Header|Footer) properties
  % are probably broken.
  
  %#ok<*INUSL>
  
  properties (Dependent)
    evenFooter
    firstFooter
    oddFooter
    evenHeader
    firstHeader
    oddHeader
    footer
    header
    headerFooterProperties
  end
  
  methods
    
    function this = Sheet(workbook, jObj)
      if nargin == 0
        return
      else
        mustBeA(workbook, 'jl.office.excel.Workbook');
        mustBeA(jObj, 'org.apache.poi.xssf.usermodel.XSSFSheet');
        this.workbook = workbook;
        this.j = jObj;
      end
      this.cells = jl.office.excel.FriendlyCellView(this);
      this.jIoHelper = net.janklab.office.excel.SheetIOHelper(jObj);
    end
    
    function out = get.headerFooterProperties(this)
      out = jl.office.excel.xlsx.HeaderFooterProperties(this.j.getHeaderFooterProperties);
    end
    
    function out = get.evenFooter(this)
      out = jl.office.excel.HeaderFooter(this.j.getEvenFooter);
    end
    
    function out = get.oddFooter(this)
      out = jl.office.excel.HeaderFooter(this.j.getOddFooter);
    end
    
    function out = get.firstFooter(this)
      out = jl.office.excel.HeaderFooter(this.j.getFirstFooter);
    end
    
    function out = get.footer(this)
      out = jl.office.excel.HeaderFooter(this.j.getFooter);
    end
    
    function out = get.evenHeader(this)
      out = jl.office.excel.HeaderFooter(this.j.getEvenHeader);
    end
    
    function out = get.oddHeader(this)
      out = jl.office.excel.HeaderFooter(this.j.getOddHeader);
    end
    
    function out = get.firstHeader(this)
      out = jl.office.excel.HeaderFooter(this.j.getFirstHeader);
    end
    
    function out = get.header(this)
      out = jl.office.excel.HeaderFooter(this.j.getHeader);
    end
    
    function addHyperlink(this, hyperlink)
      mustBeA(hyperlink, 'jl.office.excel.xlsx.Hyperlink');
      this.addHyperlink(hyperlink.j);
    end
    
    function addIgnoredErrors(this, region, ignoredErrorTypes)
      mustBeA(ignoredErrorTypes, 'jl.office.excel.IgnoredErrorType');
      if ~isa(region, 'jl.office.excel.CellRangeAddress') ...
          && ~isa(region, 'jl.office.excel.CellReference')
        error(['region must be a jl.office.excel.CellRangeAddress or a '...
          'jl.office.excel.CellReference; got a %s'], class(region));
      end
      this.j.addIgnoredErrors(region.j, ignoredErrorTypes.toJavaArray);
    end
    
    function out = createDrawingPatriarch(this)
      jObj = this.j.createDrawingPatriarch;
      out = jl.office.excel.xlsx.draw.Drawing(jObj);
    end
    
    function out = createPivotTable(this, source, position, sourceSheet)
      if nargin < 4; sourceSheet = []; end
      mustBeA(position, 'jl.office.excel.CellReference');
      if ~isempty(sourceSheet)
        mustBeA(sourceSheet, 'jl.office.excel.Sheet');
      end
      if ~isa(source, 'jl.office.excel.AreaReference') ...
          && ~isa(source, 'jl.office.excel.Name') ...
          && ~isa(source, 'jl.office.excel.Table')
        error(['source must be a jl.office.excel.AreaReference, jl.office.excel.Name, ' ...
          'or jl.office.excel.Table; got a %s'], class(source));
      end
      if nargin < 4
        jObj = this.j.createPivotTable(source.j, position.j);
      else
        jObj = this.j.createPivotTable(source.j, position.j, sourceSheet.j);
      end
      out = jl.office.excel.xlsx.PivotTable(jObj);
    end
    
    function out = getPivotTables(this)
      jList = this.j.getPivotTables;
      out = repmat(jl.office.excel.xlsx.PivotTable, [1 jList.size]);
      for i = 1:numel(out)
        out(i) = jList.get(i);
      end
    end
    
    function out = createTable(this)
      jObj = this.j.createTable;
      out = jl.office.excel.xlsx.Table(jObj);
    end
    
    function removeTable(this, table)
      mustBeA(table, 'jl.office.excel.xlsx.Table');
      this.j.removeTable(table.j);
    end
    
    function disableLocking(this)
      this.j.disableLocking;
    end
    
    function enableLocking(this)
      this.j.enableLocking;
    end
    
    function out = findEndOfRowOutlineGroup(this, rowIndex)
      out = this.j.findEndOfRowOutlineGroup(rowIndex - 1) + 1;
    end
    
    function out = getIgnoredErrors(this)
      UNIMPLEMENTED
      % TODO: Decide how to represent a Java
      % Map<IgnoredErrorType,CellRangeAddress[]>
    end
    
    function out = hasComments(this)
      out = this.j.hasComments;
    end
    
    function lockAutoFilter(this, val)
      this.j.lockAutoFilter(val);
    end
    
    function lockDeleteColumns(this, val)
      this.j.lockDeleteColumns(val);
    end
    
    function lockDeleteRows(this, val)
      this.j.lockDeleteRows(val);
    end
    
    function lockFormatCells(this, val)
      this.j.lockFormatCells(val);
    end
    
    function lockFormatColumns(this, val)
      this.j.lockFormatColumns(val);
    end
    
    function lockFormatRows(this, val)
      this.j.lockFormatRows(val);
    end
    
    function lockInsertColumns(this, val)
      this.j.lockInsertColumns(val);
    end
    
    function lockInsertHyperlinks(this, val)
      this.j.lockInsertHyperlinks(val);
    end
    
    function lockInsertRows(this, val)
      this.j.lockInsertRows(val);
    end
    
    function lockObjects(this, val)
      this.j.lockObjects(val);
    end
    
    function lockPivotTables(this, val)
      this.j.lockPivotTables(val);
    end
    
    function lockScenarios(this, val)
      this.j.lockScenarios(val);
    end
    
    function lockSelectLockedCells(this, val)
      this.j.lockSelectLockedCells(val);
    end
    
    function lockSelectUnlockedCells(this, val)
      this.j.lockSelectUnlockedCells(val);
    end
    
    function lockSort(this, val)
      this.j.lockSort(val);
    end
    
  end
  
  methods (Access = protected)
    
    function out = wrapRowObject(this, jRow)
      out = jl.office.excel.xlsx.Row(this, jRow);
    end
    
    function out = wrapCellStyleObject(this, jObj)
      out = jl.office.excel.xlsx.CellStyle(jObj);
    end
  
    function out = wrapPrintSetupObject(this, jObj)
      out = jl.office.excel.xlsx.PrintSetup(jObj);
    end
  end
  
end