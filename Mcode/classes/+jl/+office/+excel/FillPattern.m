classdef FillPattern
  
  properties (SetAccess = private)
    code
  end
  
  enumeration
    AltBars(org.apache.poi.ss.usermodel.PatternFormatting.ALT_BARS)
    BigSpots(org.apache.poi.ss.usermodel.PatternFormatting.BIG_SPOTS)
    Bricks(org.apache.poi.ss.usermodel.PatternFormatting.BRICKS)
    Diamonds(org.apache.poi.ss.usermodel.PatternFormatting.DIAMONDS)
    FineDots(org.apache.poi.ss.usermodel.PatternFormatting.FINE_DOTS)
    LeastDots(org.apache.poi.ss.usermodel.PatternFormatting.LEAST_DOTS)
    LessDots(org.apache.poi.ss.usermodel.PatternFormatting.LESS_DOTS)
    NoFill(org.apache.poi.ss.usermodel.PatternFormatting.NO_FILL)
    SolidForeground(org.apache.poi.ss.usermodel.PatternFormatting.SOLID_FOREGROUND)
    SparseDots(org.apache.poi.ss.usermodel.PatternFormatting.SPARSE_DOTS)
    Squares(org.apache.poi.ss.usermodel.PatternFormatting.SQUARES)
    ThickBackwardDiag(org.apache.poi.ss.usermodel.PatternFormatting.THICK_BACKWARD_DIAG)
    ThickForwardDiag(org.apache.poi.ss.usermodel.PatternFormatting.THICK_FORWARD_DIAG)
    ThickHorzBands(org.apache.poi.ss.usermodel.PatternFormatting.THICK_HORZ_BANDS)
    ThickVertBands(org.apache.poi.ss.usermodel.PatternFormatting.THICK_VERT_BANDS)
    ThinBackwardDiag(org.apache.poi.ss.usermodel.PatternFormatting.THIN_BACKWARD_DIAG)
    ThinForwardDiag(org.apache.poi.ss.usermodel.PatternFormatting.THIN_FORWARD_DIAG)
    ThinHorzBands(org.apache.poi.ss.usermodel.PatternFormatting.THIN_HORZ_BANDS)
    ThinVertBands(org.apache.poi.ss.usermodel.PatternFormatting.THIN_VERT_BANDS)
  end
  
  methods (Static)
    
    function out = ofJava(jVal)
      switch jVal
        case org.apache.poi.ss.usermodel.PatternFormatting.ALT_BARS
          out = jl.office.excel.FillPattern.AltBars;
        case org.apache.poi.ss.usermodel.PatternFormatting.BIG_SPOTS
          out = jl.office.excel.FillPattern.BigSpots;
        case org.apache.poi.ss.usermodel.PatternFormatting.BRICKS
          out = jl.office.excel.FillPattern.Bricks;
        case org.apache.poi.ss.usermodel.PatternFormatting.DIAMONDS
          out = jl.office.excel.FillPattern.Diamonds;
        case org.apache.poi.ss.usermodel.PatternFormatting.FINE_DOTS
          out = jl.office.excel.FillPattern.FineDots;
        case org.apache.poi.ss.usermodel.PatternFormatting.LEAST_DOTS
          out = jl.office.excel.FillPattern.LeastDots;
        case org.apache.poi.ss.usermodel.PatternFormatting.LESS_DOTS
          out = jl.office.excel.FillPattern.LessDots;
        case org.apache.poi.ss.usermodel.PatternFormatting.NO_FILL
          out = jl.office.excel.FillPattern.NoFill;
        case org.apache.poi.ss.usermodel.PatternFormatting.SOLID_FOREGROUND
          out = jl.office.excel.FillPattern.SolidForeground;
        case org.apache.poi.ss.usermodel.PatternFormatting.SPARSE_DOTS
          out = jl.office.excel.FillPattern.SparseDots;
        case org.apache.poi.ss.usermodel.PatternFormatting.SQUARES
          out = jl.office.excel.FillPattern.Squares;
        case org.apache.poi.ss.usermodel.PatternFormatting.THICK_BACKWARD_DIAG
          out = jl.office.excel.FillPattern.ThickBackwardDiag;
        case org.apache.poi.ss.usermodel.PatternFormatting.THICK_FORWARD_DIAG
          out = jl.office.excel.FillPattern.ThickForwardDiag;
        case org.apache.poi.ss.usermodel.PatternFormatting.THICK_HORZ_BANDS
          out = jl.office.excel.FillPattern.ThickHorzBands;
        case org.apache.poi.ss.usermodel.PatternFormatting.THICK_VERT_BANDS
          out = jl.office.excel.FillPattern.ThickVertBands;
        case org.apache.poi.ss.usermodel.PatternFormatting.THIN_BACKWARD_DIAG
          out = jl.office.excel.FillPattern.ThinBackwardDiag;
        case org.apache.poi.ss.usermodel.PatternFormatting.THIN_FORWARD_DIAG
          out = jl.office.excel.FillPattern.ThinForwardDiag;
        case org.apache.poi.ss.usermodel.PatternFormatting.THIN_HORZ_BANDS
          out = jl.office.excel.FillPattern.ThinHorzBands;
        case org.apache.poi.ss.usermodel.PatternFormatting.THIN_VERT_BANDS
          out = jl.office.excel.FillPattern.ThinVertBands;
        otherwise
          BADSWITCH
      end
    end
    
  end
  
  methods
    
    function out = toJava(this)
      out = this.code;
    end
    
  end
  
  methods (Access = private)
    
    function this = FillPattern(jCode)
      this.code = jCode;
    end
    
  end
  
end