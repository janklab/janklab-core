classdef Cell < jl.util.DisplayableHandle
  
  properties
    % The underlying POI Cell object
    j
    % The parent Row
    row
  end
  
  properties (Dependent)
    address
    cellStyle
    cellType
    comment
    columnIndex
    rowIndex
    errorCode
    value
    formula
    hyperlink
  end
  
  methods
    
    function this = Cell(row, jObj)
      if nargin == 0
        return
      else
        mustBeA(row, 'jl.office.excel.Row');
        mustBeA(jObj, 'org.apache.poi.ss.usermodel.Cell');
        this.row = row;
        this.j = jObj;        
      end
    end
        
    function out = get.address(this)
      out = jl.office.excel.CellAddress(this.j.getAddress);
    end
    
    function out = get.cellStyle(this)
      out = this.wrapCellStyleObject(this.j.getCellStyle);
    end
    
    function out = get.cellType(this)
      out = jl.office.excel.CellType.ofJava(this.j.getCellTypeEnum);
    end
    
    function out = get.comment(this)
      out = jl.office.excel.Comment(this.j.getCellComment);
    end
    
    function out = get.columnIndex(this)
      out = this.j.getColumnIndex;
    end
    
    function out = get.rowIndex(this)
      out = this.j.getRowIndex;
    end
    
    function set.comment(this, val)
      if isempty(val)
        this.j.removeCellComment;
      elseif isstring(val) || ischar(val)
        UNIMPLEMENTED
      elseif isa(val, 'jl.office.excel.Comment')
        this.setCellComment(val.j);
      else
        error('jl:InvalidInput', 'Invalid type for comment: %s', class(val));
      end
    end
    
    function setBlank(this)
      this.j.setBlank;
    end
    
    function out = get.errorCode(this)
      out = this.j.getErrorCellValue;
    end
    
    function set.errorCode(this, val)
      this.j.setCellErrorValue(val);
    end
    
    function out = get.value(this)
      type = this.cellType;
      if type == jl.office.excel.CellType.Blank
        out = [];
      elseif type == jl.office.excel.CellType.Boolean
        out = this.j.getBooleanCellValue;
      elseif type == jl.office.excel.CellType.Error
        UNIMPLEMENTED
      elseif type == jl.office.excel.CellType.Formula
        out = jl.office.excel.Formula(string(this.j.getCellFormula));
      elseif type == jl.office.excel.CellType.None
        out = [];
      elseif type == jl.office.excel.CellType.Numeric
        out = this.j.getNumericCellValue;
      elseif type == jl.office.excel.CellType.String
        % TODO: Return as rich string instead?
        out = string(this.j.getStringCellValue);
      elseif type == jl.office.excel.CellType.Unknown
        out = [];
      else
        out = [];
      end
    end
    
    function set.value(this, val)
      if isempty(val)
        this.j.setBlank;
      elseif isnumeric(val)
        this.j.setCellValue(val);
      elseif isa(val, 'datetime') || isa(val, 'localdate')
        UNIMPLEMENTED;
      elseif ischar(val) || isstring(val)
        this.j.setCellValue(val);
      elseif isa(val, 'jl.office.excel.RichTextString')
        this.j.setCellValue(val.j);
      elseif isa(val, 'jl.office.excel.Formula')
        this.j.setCellFormula(val.str);
      else
        error('jl:InvalidInput', 'Invalid type for cell value: %s', class(val));
      end
    end
    
    function out = get.formula(this)
      out = jl.office.excel.Formula(this.j.getCellFormula);
    end
    
    function set.formula(this, val)
      if isa(val, 'jl.office.excel.Formula')
        this.j.setCellFormula(val.str);
      elseif isempty(val)
        this.removeFormula;
      else
        this.j.setCellFormula(val);
      end
    end
    
    function removeFormula(this)
      this.j.removeFormula;
    end
    
    function removeHyperlink(this)
      this.j.removeHyperlink;
    end
    
    function setAsActiveCell(this)
      this.j.setAsActiveCell;
    end
    
  end
  
  methods (Access = protected)

    function out = dispstr_scalar(this)
      val = this.value;
      out = sprintf('[Cell: r=%d c=%d type=%s val=%s]', ...
        this.rowIndex, this.columnIndex, this.cellType, dispstr(val));
    end

  end

  methods (Abstract, Access = protected)
    out = wrapCellStyleObject(this, jObj)
  end
end
