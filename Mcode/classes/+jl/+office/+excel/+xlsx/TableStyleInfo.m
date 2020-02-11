classdef TableStyleInfo < handle
% TableStyleInfo

  properties
    % The underlying POI org.apache.poi.xssf.usermodel.XSSFTableStyleInfo Java object
    j
  end

  properties (Dependent)
    name
    style
    showColumnStripes
    showFirstColumn
    showLastColumn
    showRowStripes
  end
  
  methods

    function this = TableStyleInfo(jObj)
      if nargin == 0
        return
      end
      mustBeA(jObj, 'org.apache.poi.xssf.usermodel.XSSFTableStyleInfo');
      this.j = jObj;
    end

    function out = get.name(this)
      out = string(this.j.getName);
    end
    
    function set.name(this, val)
      this.j.setName(val);
    end
    
    function out = get.style(this)
      jObj = this.j.getStyle;
      out = jl.office.excel.xlsx.TableStyle(jObj);
    end
    
    function out = get.showColumnStripes(this)
      out = this.j.isShowColumnStripes;
    end
    
    function set.showColumnStripes(this, val)
      this.j.setShowColumnStripes(val);
    end
    
    function out = get.showFirstColumn(this)
      out = this.j.isShowFirstColumn;
    end
    
    function set.showFirstColumn(this, val)
      this.j.setFirstColumn(val);
    end
      
    function out = get.showLastColumn(this)
      out = this.j.isShowLastColumn;
    end
    
    function set.showLastColumn(this, val)
      this.j.setLastColumn(val);
    end
    
    function out = get.showRowStripes(this)
      out = this.j.isShowRowStripes;
    end
    
    function set.showRowStripes(this, val)
      this.j.setShowRowStripes(val);
    end
    
  end

end
