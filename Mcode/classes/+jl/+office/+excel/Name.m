classdef Name < jl.util.DisplayableHandle
  % Represents a defined name for a range of cells
  %
  % A name is a meaningful shorthand that makes it easier to understand the
  % purpose of a cell reference, constant or a formula.
  
  properties
    % The underlying Java POI object
    j
  end
  properties (Dependent)
    comment
    name
    refersToFormula
    sheetIndex
    sheetName
    isDeleted
  end
  
  methods
    
    function this = Name(jObj)
      if nargin == 0
        return
      end
      mustBeA(jObj, 'org.apache.poi.ss.usermodel.Name');
      this.j = jObj;
    end
    
    function out = get.comment(this)
      out = string(this.j.getComment);
    end
    
    function set.comment(this, val)
      this.j.setComment(val);
    end
    
    function out = get.name(this)
      out = string(this.j.getNameName);
    end
    
    function set.name(this, val)
      this.j.setNameName(val);
    end
    
    function out = get.refersToFormula(this)
      out = this.j.getRefersToFormula;
    end
    
    function set.refersToFormula(this, val)
      this.j.setRefersToFormula(val);
    end
    
    function out = get.sheetIndex(this)
      out = this.j.getSheetIndex;
    end
    
    function set.sheetIndex(this, val)
      this.j.setSheetIndex(val);
    end
    
    function out = get.sheetName(this)
      out = string(this.j.getSheetName);
    end
    
    function out = get.isDeleted(this)
      out = this.j.isDeleted;
    end
    
    function out = isFunctionName(this)
      out = this.j.isFunctionName;
    end
    
  end
  
  methods (Access = protected)
    
    function out = dispstr_scalar(this)
      out = sprintf('[Name: "%s", sheet %d (%s)', ...
        this.name, this.sheetIndex, this.sheetName);
      if ~isempty(this.comment)
        out = sprintf('%s, comment="%s"', out, this.comment);
      end
      if this.isFunctioName
        out = sprintf('%s, isFunction', out);
      end
      if ~isempty(this.refersToFormula)
        out = sprintf('%s, refersToFormula="%s"', out, this.refersToFormula);
      end
      if this.isDeleted
        out = [out ', DELETED'];
      end
      out = [out ']'];
    end
    
  end
end