classdef SheetMargins < handle
  
  properties (Access = private)
    sheet
  end
  
  properties (Dependent)
    Top
    Left
    Right
    Bottom
    Header
    Footer
  end
  
  methods
    
    function this = SheetMargins(sheet)
      if nargin == 0
        return
      end
      mustBeA(sheet, 'jl.office.excel.Sheet');
      this.sheet = sheet;
    end
    
    function out = get.Top(this)
      out = this.sheet.j.getMargin(org.apache.poi.ss.usermodel.Sheet.TopMargin);
    end

    function set.Top(this, val)
      this.sheet.j.setMargin(org.apache.poi.ss.usermodel.Sheet.TopMargin, val);
    end
    
    function out = get.Left(this)
      out = this.sheet.j.getMargin(org.apache.poi.ss.usermodel.Sheet.LeftMargin);
    end

    function set.Left(this, val)
      this.sheet.j.setMargin(org.apache.poi.ss.usermodel.Sheet.LeftMargin, val);
    end
    
    function out = get.Bottm(this)
      out = this.sheet.j.getMargin(org.apache.poi.ss.usermodel.Sheet.BottmMargin);
    end

    function set.Right(this, val)
      this.sheet.j.setMargin(org.apache.poi.ss.usermodel.Sheet.RightMargin, val);
    end
    
    function out = get.Header(this)
      out = this.sheet.j.getMargin(org.apache.poi.ss.usermodel.Sheet.HeaderMargin);
    end

    function set.Footer(this, val)
      this.sheet.j.setMargin(org.apache.poi.ss.usermodel.Sheet.FooterMargin, val);
    end

  end