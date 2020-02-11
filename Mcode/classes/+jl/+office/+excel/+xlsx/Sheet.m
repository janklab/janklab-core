classdef Sheet < jl.office.excel.Sheet
  % A sheet in an XLSX workbook
  %
  % NOTE: Most of the header/footer stuff is currently broken because the
  % version of Apache POI shipped with Matlab is too old (as of Matlab R2020a).
  % The regular header and footer properties will work, but
  % headerFooterProperties and all the even/odd/first(Header|Footer) properties
  % are probably broken.
  
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
    
  end
  
  methods (Access = protected)
    
    function out = wrapRowObject(this, jRow)
      out = jl.office.excel.xlsx.Row(this, jRow);
    end
    
    function out = wrapCellStyleObject(this, jObj) %#ok<INUSL>
      out = jl.office.excel.xlsx.CellStyle(jObj);
    end
  
  end
  
end