classdef FriendlyCellView < handle
  % An adapter that lets you view the cells in a Sheet as a Matlab array
  
  properties (SetAccess = private)
    sheet
  end
  
  methods
    
    function this = FriendlyCellView(sheet)
      mustBeA(sheet, 'jl.office.excel.Sheet');
      this.sheet = sheet;
    end
    
    function out = size(this)
      out = [this.sheet.nRows this.sheet.nCols];
    end
    
    function out = getValueAt(this, ixRow, ixCol)
      row = this.sheet.getRow(ixRow);
      if isempty(row)
        out = [];
        return
      end
      c = row.getCell(ixCol);
      if isempty(c)
        out = [];
      end
    end
    
    function setValueAt(this, ixRow, ixCol, val)
      fprintf('FCV: setValue: (%d, %d) -> %s\n', ...
        ixRow, ixCol, dispstr(val));
      row = this.sheet.vivifyRow(ixRow);
      c = row.vivifyCell(ixCol);
      c.value = val;
    end
    
    function out = subsref(this, S)
      mustBeScalar(S);
      subs = S.subs;
      switch S.type
        case '()'
          UNIMPLEMENTED
        case '{}'
          if numel(subs) == 1
            UNIMPLEMENTED
          elseif numel(subs) == 2
            ixRow = subs{1};
            ixCol = subs{2};
            mustBeScalarNumeric(ixRow);
            mustBeScalarNumeric(ixCol);
            % TODO: Support multiple cell references
            out = this.getValueAt(ixRow, ixCol);
          else
            error('jl:InvalidInput', 'Can only supply 1 or 2 subscripts');
          end
        case '.'
          error('.-indexing is not supported for %s', class(this));
      end
    end
    
    function this = subsasgn(this, S, val)
      mustBeScalar(S);
      subs = S.subs;
      switch S.type
        case '()'
          UNIMPLEMENTED
        case '{}'
          if numel(subs) == 1
            UNIMPLEMENTED
          elseif numel(subs) == 2
            ixRow = subs{1};
            ixCol = subs{2};
            mustBeScalarNumeric(ixRow);
            mustBeScalarNumeric(ixCol);
            % TODO: Support multiple cell references
            this.setValueAt(ixRow, ixCol, val);
          else
            error('jl:InvalidInput', 'Can only supply 1 or 2 subscripts');
          end
        case '.'
          error('.-indexing is not supported for %s', class(this));
      end
    end
    
  end
  
end
