classdef (Abstract) Sheet < jl.util.DisplayableHandle
  % A sheet (worksheet) in an Excel workbook
  
  % TODO: writeTable(), readTable()
  % TODO: Format-specific stuff
  % TODO: DataValidation
  % TODO: Header and Footer
  % TODO: Hyperlinks
  % TODO: PaneInformation
  % TODO: PrintSetup, repeatingColumns/Rows
  % TODO: ConditionalFormatting
  % TODO: removeArrayFormula/setArrayFormula
  % TODO: setAutoFilter
  
  properties (SetAccess = protected)
    % The underlying POI XSSFSheet object
    j
    % The parent workbook
    workbook
    % A FriendlyCellView into this sheet, which lets you view the sheet's
    % cells as a Matlab array
    cells
    % A view into the margins of this sheet
    margins
  end
  properties (Access = protected)
    jIoHelper
  end
  
  properties (Dependent)
    activeCellAddress
    autobreaks
    firstRowNum
    fitToPage
    lastRowNum
    name
    nRows
    nCols
    forceFormulaRecalculation
    displayFormulas
    displayGridlines
    displayRowColHeadings
    displayZeros
    printGridlines
    printRowColHeadings
    displayGuts
    horizontallyCenter
    verticallyCenter
    leftCol
    topRow
    margin
    physicalNumberOfRows
    isProtected
    isRightToLeft
    rowSumsBelow
    rowSumsRight
    scenarioProtect
    selected
  end
  
  methods
        
    function out = get.activeCellAddress(this)
      out = jl.office.excel.CellAddress(this.j.getActiveCell);
    end
    
    function set.activeCellAddress(this, val)
      mustBeA(val, 'jl.office.excel.CellAddress');
      this.j.setActiveCell(val.j);
    end
    
    function out = get.autobreaks(this)
      out = this.j.getAutobreaks;
    end
    
    function set.autobreaks(this, val)
      this.j.setAutobreaks(val);
    end
    
    function out = get.lastRowNum(this)
      out = this.j.getLastRowNum;
    end
    
    function out = get.firstRowNum(this)
      out = this.j.getFirstRowNum + 1;
    end
    
    function out = get.name(this)
      out = string(this.j.getSheetName);
    end
    
    function out = get.nRows(this)
      out = this.j.getLastRowNum;
    end
    
    function out = get.nCols(this)
      out = 0;
      for iRow = 1:this.nRows
        row = this.getRow(iRow);
        out = max(out, row.nCols);
      end
    end
    
    function out = getRow(this, index)
      jRow = this.j.getRow(index - 1);
      if isempty(jRow)
        out = [];
        return
      end
      out = this.wrapRowObject(jRow);
    end
    
    function out = createRow(this, index)
      jRow = this.j.createRow(index - 1);
      out = this.wrapRowObject(jRow);
    end
    
    function out = addMergedRegion(this, region)
      % Add a merged region of cells
      %
      % out = addMergedRegion(this, region)
      %
      % Region is a CellRangeAddress object or something that can be converted
      % to one, like a numeric [up, left, down, right] numeric cell range
      % specification or a string "A1:Z99" cell range specification.
      %
      % Returns a scalar numeric that is the index of the merged region.
      region = jl.office.excel.CellRangeAddress(region);
      out = this.j.addMergedRegion(region.j);
    end
    
    function out = getMergedRegion(this, index)
      out = jl.office.excel.CellRangeAddress(this.j.getMergedRegion(index - 1));
    end
    
    function out = getMergedRegions(this)
      list = this.j.getMergedRegions;
      out = repmat(jl.office.excel.CellRangeAddress, [1 list.size]);
      for i = 1:list.size
        out(i) = list.get(i - 1);
      end
    end
    
    function out = getNumMergedRegions(this)
      out = this.j.getNumMergedRegions;
    end
    
    function autoSizeColumn(this, index, useMergedCells)
      narginchk(2, 3);
      if nargin == 2
        this.j.autoSizeColumn(index - 1);
      else
        this.j.autoSizeColumn(index - 1, useMergedCells);
      end
    end
    
    function createFreezePanes(this, colSplit, rowSplit, leftmostColumn, topRow)
      narginchk(3, 5);
      if nargin == 3
        this.j.createFreezePanes(colSplit - 1, rowSplit - 1);
      else
        this.j.createFreezePanes(colSplit - 1, rowSplit - 1, ...
          leftmostColumn - 1, topRow - 1);
      end
    end
    
    function createSplitPane(this, xSplitPos, ySplitPos, leftmostColumn, topRow, activePane)
      % Creates a split pane, removing any existing freezepane or splitpane
      %
      % createSplitPane(obj, xSplitPos, ySplitPos, leftmostColumn, topRow, activePane)
      %
      % xSplitPos (numeric) is the horizontal position of the split, in 1/20th
      % of a point.
      %
      % ySplitPos (numeric) is the vertical position of the split, in 1/20th
      % of a point.
      %
      % leftmostColumn is the leftmost column visible in the right pane.
      %
      % topRow is the index of the top row visible in the bottom pane.
      %
      % activePane is a SplitPanePosition object which indicates which pane is
      % to become active.
      mustBeA(activePane, 'jl.office.excel.SplitPanePosition');
      this.j.createSplitPane(xSplitPos, ySplitPos, leftmostColumn - 1, ...
        topRow - 1, activePane.toJava);
    end
    
    function out = getCellComment(this, address)
      address = jl.office.excel.CellAddress(address);
      out = this.j.getCellComment(address.j);
    end
    
    function out = getCellComments(this)
      UNIMPLEMENTED
    end
    
    function out = getColumnBreaks(this)
      out = this.j.getColumnBreaks;
    end
    
    function out = getColumnOutlineLevel(this, index)
      out = this.j.getColumnOutlineLevel(index - 1);
    end
    
    function out = getColumnStyle(this, colIndex)
      out = this.wrapCellStyleObject(this.j.getColumnStyle(colIndex - 1));
    end
    
    function out = getColumnWidth(this, colIndex)
      out = this.j.getColumnWidth(colIndex - 1);
    end
    
    function setColumnWidth(this, colIndex, width)
      % Set the width of a column
      %
      % setColumnWidth(obj, colIndex, width)
      %
      % ColIndex is the index of the column to set the width for.
      %
      % Width is the column width in 1/256th of a character width.
      this.j.setColumnWidth(colIndex - 1, width)
    end
    
    function out = getColumnWidthInPixels(this, colIndex)
      out = this.j.getColumnWidthInPixels(colIndex - 1);
    end
    
    function out = getDefaultColumnWidth(this)
      out = this.j.getDefaultColumnWidth;
    end
    
    function out = getDefaultRowHeight(this)
      out = this.j.getDefaultRowHeight;
    end
    
    function out = getDefaultRowHeightInPoints(this)
      out = this.j.getDefaultRowHeightInPoints;
    end
    
    function out = get.displayGuts(this)
      out = this.j.getDisplayGuts;
    end
    
    function set.displayGuts(this, val)
      this.j.setDisplayGuts(val);
    end
    
    function out = get.fitToPage(this)
      out = this.j.getFitToPage;
    end
    
    function set.fitToPage(this, val)
      this.j.setFitToPage(val);
    end
    
    function out = get.forceFormulaRecalculation(this)
      out = this.j.getForceFormulaRecalculation;
    end
    
    function set.forceFormulaRecalculation(this, val)
      this.j.setForceFormulaRecalculation(val);
    end
    
    function out = get.horizontallyCenter(this)
      out = this.j.getHorizontallyCenter;
    end
    
    function set.horizontallyCenter(this, val)
      this.j.setHorizontallyCenter(val);
    end
    
    function out = get.leftCol(this)
      out = this.j.getLeftCol;
    end
    
    function set.leftCol(this, val)
      this.j.setLeftCol(val);
    end
    
    % TODO: The types for this margin are wrong.
    function out = get.margin(this)
       UNIMPLEMENTED
    end
    
    function set.margin(this, val)
      UNIMPLEMENTED
    end
    
    function out = get.physicalNumberOfRows(this)
      out = this.j.getPhysicalNumberOfRows;
    end
    
    function out = get.isProtected(this)
      out = this.j.getProtect;
    end
    
    function set.isProtected(this, val)
      this.j.setProtect(val);
    end
    
    function out = getRowBreaks(this)
      out = this.j.getRowBreaks;
    end
    
    function out = get.rowSumsBelow(this)
      out = this.j.getRowSumsBelow;
    end

    function set.rowSumsBelow(this, val)
      this.j.setRowSumsBelow(val);
    end
    
    function out = get.rowSumsRight(this)
      out = this.j.getRowSumsRight;
    end
    
    function set.rowSumsRight(this, val)
      this.j.setRowSumsRight(val);
    end
    
    function out = get.scenarioProtect(this)
      out = this.j.getScenarioProtect;
    end
    
    function set.scenarioProtect(this, val)
      this.j.setScenarioProtect(val);
    end
    
    function out = get.topRow(this)
      out = this.j.getTopRow;
    end
    
    function set.topRow(this, val)
      this.j.setTopRow(val);
    end
    
    function out = get.verticallyCenter(this)
      out = this.j.getVerticallyCenter;
    end
    
    function set.verticallyCenter(this, val)
      this.j.setVerticallyCenter(val);
    end
    
    function groupColumn(this, fromColIndex, toColIndex)
      this.j.groupColumn(fromColIndex - 1, toColIndex - 1);
    end
    
    function groupRow(this, fromRowIndex, toRowIndex)
      this.j.groupRow(fromRowIndex - 1, toRowIndex - 1);
    end
    
    function out = isColumnBroken(this, index)
      out = this.j.isColumnBroken(index - 1);
    end
    
    function out = isRowBroken(this, index)
      out = this.j.isRowBroken(index - 1);
    end
    
    function out = isColumnHidden(this, index)
      out = this.j.isColumnHidden(index - 1);
    end
    
    function out = get.displayFormulas(this)
      out = this.j.getDisplayFormulas;
    end
    
    function set.displayFormulas(this, val)
      this.j.setDisplayFormulas(val);
    end
    
    function out = get.displayGridlines(this)
      out = this.j.getDisplayGridlines;
    end
    
    function set.displayGridlines(this, val)
      this.j.setDisplayGridlines(val);
    end
    
    function out = get.displayRowColHeadings(this)
      out = this.j.getDisplayRowColHeadings;
    end
    
    function set.displayRowColHeadings(this, val)
      this.j.setDisplayRowColHeadings(val);
    end
    
    function out = get.printRowColHeadings(this)
      out = this.j.getPrintRowColHeadings;
    end
    
    function set.printRowColHeadings(this, val)
      this.j.setPrintRowColHeadings(val);
    end
    
    function out = get.displayZeros(this)
      out = this.j.getDisplayZeros;
    end
    
    function set.displayZeros(this, val)
      this.j.setDisplayZeros(val);
    end
    
    function out = get.printGridlines(this)
      out = this.j.getPrintGridlines;
    end
    
    function set.printGridlines(this, val)
      this.j.setPrintGridlines(val);
    end
    
    function out = get.isRightToLeft(this)
      out = this.j.isRightToLeft;
    end
    
    function set.isRightToLeft(this, val)
      this.j.setRightToLeft(val);
    end
    
    function out = get.selected(this)
      out = this.j.isSelected;
    end
    
    function set.selected(this, val)
      this.j.setSelected(val);
    end
    
    function protectSheet(this, password)
      this.j.protectSheet(password);
    end
    
    function removeColumnBreak(this, index)
      this.j.removeColumnBreak(index - 1);
    end
    
    function removeMergedRegion(this, index)
      if isscalar(index)
        this.j.removeMergedRegion(index - 1);
      else
        error('Multiple indexes are not supported yet.')
      end
    end
    
    function removeRow(this, row)
      mustBeA(row, 'jl.office.excel.Row')
      this.j.removeRow(row.j);
    end
    
    function removeRowBreak(this, index)
      this.j.removeRowBreak(index - 1);
    end
    
    function setColumnGroupCollapsed(this, colIndex, isCollapsed)
      this.j.setColumnGroupCollapsed(colIndex - 1, isCollapsed);
    end
    
    function setRowGroupCollapsed(this, rowIndex, isCollapsed)
      this.j.setRowGroupCollapsed(rowIndex - 1, isCollapsed);
    end
    
    function setColumnBreak(this, index)
      this.setColumnBreak(index - 1);
    end
    
    function setRowBreak(this, index)
      this.setRowBreak(index - 1);
    end
    
    function setColumnHidden(this, index)
      this.setColumnHidden(index - 1);
    end
    
    function setDefaultColumnStyle(this, colIndex, cellStyle)
      mustBeA(cellStyle, 'jl.office.excel.CellStyle');
      this.j.setDefaultColumnStyle(colIndex - 1, cellStyle.j);
    end
    
    function setDefaultColumnWidth(this, width)
      this.j.setDefaultColumnWidth(width);
    end
    
    function setDefaultRowHeight(this, height)
      this.j.setDefaultRowHeight(height);
    end
    
    function setDefaultRowHeightInPoints(this, height)
      this.j.setDefaultRowHeightInPoints(height);
    end
    
    function setZoom(this, scale)
      this.j.setZoom(scale);
    end
    
    function shiftColumns(this, ixStart, ixEnd, n)
      this.j.shiftColumns(ixStart - 1, ixEnd - 1, n);
    end
    
    function shiftRows(this, ixStart, ixEnd, n)
      this.j.shiftRows(ixStart - 1, ixEnd - 1, n);
    end
    
    function showInPane(this, topRow, leftCol)
      this.j.showInPane(topRow - 1, leftCol - 1);
    end
    
    function ungroupColumn(this, fromCol, toCol)
      this.j.ungroupColumn(fromCol - 1, toCol - 1);
    end
    
    function ungroupRow(this, fromRow, toRow)
      this.j.ungroupRow(fromRow - 1, toRow - 1);
    end
    
    function validateMergedRegions(this)
      this.j.validateMergedRegions;
    end
    
    function out = readRangeNumeric(this, rangeAddress)
      rangeAddress = jl.office.excel.CellRangeAddress(rangeAddress);
      data = this.jIoHelper.readRangeNumeric(rangeAddress.j);
      out = reshapeReadData(data, rangeAddress);      
    end
    
    function out = readRangeDatetimeWithJavaDates(this, rangeAddress)
      rangeAddress = jl.office.excel.CellRangeAddress(rangeAddress);
      data = this.jIoHelper.readRangeDatenum(rangeAddress.j);
      dnums = reshapeReadData(data, rangeAddress);
      out = datetime(dnums, 'ConvertFrom','datenum');
    end
    
    function out = readRangeDatetime(this, rangeAddress)
      rangeAddress = jl.office.excel.CellRangeAddress(rangeAddress);
      data = this.jIoHelper.readRangeNumeric(rangeAddress.j);
      xdates = reshapeReadData(data, rangeAddress);
      if isa(this.workbook, 'jl.office.xlsx.Workbook')
        is1904 = this.workbookisDate1904;
      else
        is1904 = false;
      end
      out = x2mdate(xdates, is1904, 'datetime');
      out.Format = 'yyyy-MM-dd HH:mm:SS';
    end
    
    function out = readRangeString(this, rangeAddress)
      rangeAddress = jl.office.excel.CellRangeAddress(rangeAddress);
      data = this.jIoHelper.readRangeString(rangeAddress.j);
      data = string(cellstr(data));
      out = reshapeReadData(data, rangeAddress);
    end
    
    function out = readRangeCategorical(this, rangeAddress)
      rangeAddress = jl.office.excel.CellRangeAddress(rangeAddress);
      data = this.jIoHelper.readRangeCategoricalish(rangeAddress.j);
      codes = data.getCodes;
      levels = cellstr(jl.util.java.convertJavaStringsToMatlab(data.getLevels));
      ixs = codes + 1;
      ctgLevels = categorical(levels);
      out = ctgLevels(ixs);
      out = reshapeReadData(out, rangeAddress);
    end
    
    function writeRange(this, rangeAddress, vals)
      if iscategorical(vals)
        this.writeRangeCategorical(rangeAddress, vals);
      elseif isstring(vals) || iscellstr(vals)
        this.writeRangeString(rangeAddress, vals);
      elseif isa(vals, 'datetime')
        this.writeRangeDatetime(rangeAddress, vals);
      elseif isobject(vals)
        valStrs = dispstrs(vals);
        this.writeRangeString(rangeAddress, valStrs);
      else
        this.writeRangeGeneric(rangeAddress, vals);
      end
    end
    
  end

  methods (Access = protected)
    
    function writeRangeGeneric(this, rangeAddress, vals)
      rowMajorVals = vals';
      rowMajorVals = rowMajorVals(:);
      this.jIoHelper.writeRange(rangeAddress, rowMajorVals);
    end
    
    function writeRangeDatetime(this, rangeAddress, vals)
      %TODO: Need to figure out cell formatting in addition to the value
      %conversion.
      UNIMPLEMENTED
    end

    function writeRangeString(this, rangeAddress, vals)
      vals = string(vals);
      rowMajorVals = vals';
      rowMajorVals = rowMajorVals(:);
      jVals = jl.util.java.convertMatlabStringsToJava(rowMajorVals);
      this.jIoHelper.writeRange(rangeAddress, jVals);
    end
    
    function writeRangeCategorical(this, rangeAddress, vals)
      rangeAddress = jl.office.excel.CellRangeAddress(rangeAddress);
      jLevelStrs = jl.util.java.convertMatlabStringsToJava(categories(vals));
      jCodes = int32(vals) - 1;
      jCodes = jCodes'; % row-major-ify
      jCodes = jCodes(:);
      jCtgArray = net.janklab.util.CategoricalArrayList(jCodes, jLevelStrs);
      this.jIoHelper.writeRange(rangeAddress, jCtgArray);
    end
    
    function this = Sheet
      this.margins = jl.office.excel.SheetMargins(this);
    end
    
    function out = dispstr_scalar(this)
      out = sprintf('[Sheet: name=''%s'']', ...
        this.name);
    end
    
  end
  
  methods (Abstract, Access = protected)
    out = wrapRowObject(this, jObj)
    out = wrapCellStyleObject(this, jObj)
  end
  
end

function out = reshapeReadData(data, rangeAddress)
data = data(:);
out = reshape(data, [rangeAddress.numCols rangeAddress.numRows]);
out = out';
end
