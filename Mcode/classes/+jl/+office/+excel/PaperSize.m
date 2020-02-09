classdef PaperSize
  %PAPERSIZE 
  
  properties
    code
  end
  
  enumeration
    A3(org.apache.poi.ss.usermodel.PrintSetup.A3_PAPERSIZE)
    A4Extra(org.apache.poi.ss.usermodel.PrintSetup.A4_EXTRA_PAPERSIZE)
    A4Plus(org.apache.poi.ss.usermodel.PrintSetup.A4_PLUS_PAPERSIZE)
    A4Rotated(org.apache.poi.ss.usermodel.PrintSetup.A4_ROTATED_PAPERSIZE)
    A4Small(org.apache.poi.ss.usermodel.PrintSetup.A4_SMALL_PAPERSIZE)
    A4Transverse(org.apache.poi.ss.usermodel.PrintSetup.A4_TRANSVERSE_PAPERSIZE)
    A5(org.apache.poi.ss.usermodel.PrintSetup.A5_PAPERSIZE)
    B4(org.apache.poi.ss.usermodel.PrintSetup.B4_PAPERSIZE)
    ElevenBySeventeen(org.apache.poi.ss.usermodel.PrintSetup.ELEVEN_BY_SEVENTEEN_PAPERSIZE)
    Envelope10(org.apache.poi.ss.usermodel.PrintSetup.ENVELOPE_10_PAPERSIZE)
    Envelope9(org.apache.poi.ss.usermodel.PrintSetup.ENVELOPE_9_PAPERSIZE)
    EnvelopeC3(org.apache.poi.ss.usermodel.PrintSetup.ENVELOPE_C3_PAPERSIZE)
    EnvelopeC4(org.apache.poi.ss.usermodel.PrintSetup.ENVELOPE_C4_PAPERSIZE)
    EnvelopeC5(org.apache.poi.ss.usermodel.PrintSetup.ENVELOPE_C5_PAPERSIZE)
    EnvelopeC6(org.apache.poi.ss.usermodel.PrintSetup.ENVELOPE_C6_PAPERSIZE)
    EnvelopeCS(org.apache.poi.ss.usermodel.PrintSetup.ENVELOPE_CS_PAPERSIZE)
    EnvelopeDL(org.apache.poi.ss.usermodel.PrintSetup.ENVELOPE_DL_PAPERSIZE)
    EnvelopeMonarch(org.apache.poi.ss.usermodel.PrintSetup.ENVELOPE_MONARCH_PAPERSIZE)
    Executive(org.apache.poi.ss.usermodel.PrintSetup.EXECUTIVE_PAPERSIZE)
    Folio8(org.apache.poi.ss.usermodel.PrintSetup.FOLIO8_PAPERSIZE)
    Ledger(org.apache.poi.ss.usermodel.PrintSetup.LEDGER_PAPERSIZE)
    Legal(org.apache.poi.ss.usermodel.PrintSetup.LEGAL_PAPERSIZE)
    Letter(org.apache.poi.ss.usermodel.PrintSetup.LETTER_PAPERSIZE)
    LetterRotated(org.apache.poi.ss.usermodel.PrintSetup.LETTER_ROTATED_PAPERSIZE)
    LetterSmall(org.apache.poi.ss.usermodel.PrintSetup.LETTER_SMALL_PAPERSIZE)
    Note8(org.apache.poi.ss.usermodel.PrintSetup.NOTE8_PAPERSIZE)
    PrinterDefault(org.apache.poi.ss.usermodel.PrintSetup.PRINTER_DEFAULT_PAPERSIZE)
    Quarto(org.apache.poi.ss.usermodel.PrintSetup.QUARTO_PAPERSIZE)
    Statement(org.apache.poi.ss.usermodel.PrintSetup.STATEMENT_PAPERSIZE)
    Tabloid(org.apache.poi.ss.usermodel.PrintSetup.TABLOID_PAPERSIZE)
    TenByFourteen(org.apache.poi.ss.usermodel.PrintSetup.TEN_BY_FOURTEEN_PAPERSIZE)
  end
  
  methods (Static)
    
    function out = ofJava(jVal)
      if isempty(jVal)
        out = [];
      elseif jVal == org.apache.poi.ss.usermodel.PrintSetup.A3_PAPERSIZE
        out = jl.office.excel.PaperSize.A3;
      elseif jVal == org.apache.poi.ss.usermodel.PrintSetup.A4_EXTRA_PAPERSIZE
        out = jl.office.excel.PaperSize.A4Extra;
      elseif jVal == org.apache.poi.ss.usermodel.PrintSetup.A4_PAPERSIZE
        out = jl.office.excel.PaperSize.A4;
      elseif jVal == org.apache.poi.ss.usermodel.PrintSetup.A4_PLUS_PAPERSIZE
        out = jl.office.excel.PaperSize.A4Plus;
      elseif jVal == org.apache.poi.ss.usermodel.PrintSetup.A4_ROTATED_PAPERSIZE
        out = jl.office.excel.PaperSize.A4Rotated;
      elseif jVal == org.apache.poi.ss.usermodel.PrintSetup.A4_SMALL_PAPERSIZE
        out = jl.office.excel.PaperSize.A4Small;
      elseif jVal == org.apache.poi.ss.usermodel.PrintSetup.A4_TRANSVERSE_PAPERSIZE
        out = jl.office.excel.PaperSize.A4Transverse;
      elseif jVal == org.apache.poi.ss.usermodel.PrintSetup.A5_PAPERSIZE
        out = jl.office.excel.PaperSize.A5;
      elseif jVal == org.apache.poi.ss.usermodel.PrintSetup.B4_PAPERSIZE
        out = jl.office.excel.PaperSize.B4;
      elseif jVal == org.apache.poi.ss.usermodel.PrintSetup.B5_PAPERSIZE
        out = jl.office.excel.PaperSize.B5;
      elseif jVal == org.apache.poi.ss.usermodel.PrintSetup.ELEVEN_BY_SEVENTEEN_PAPERSIZE
        out = jl.office.excel.PaperSize.ElevenBySeventeen;
      elseif jVal == org.apache.poi.ss.usermodel.PrintSetup.ENVELOPE_10_PAPERSIZE
        out = jl.office.excel.PaperSize.Envelope10;
      elseif jVal == org.apache.poi.ss.usermodel.PrintSetup.ENVELOPE_9_PAPERSIZE
        out = jl.office.excel.PaperSize.Envelope9;
      elseif jVal == org.apache.poi.ss.usermodel.PrintSetup.ENVELOPE_C3_PAPERSIZE
        out = jl.office.excel.PaperSize.EnvelopeC3;
      elseif jVal == org.apache.poi.ss.usermodel.PrintSetup.ENVELOPE_C4_PAPERSIZE
        out = jl.office.excel.PaperSize.EnvelopeC4;
      elseif jVal == org.apache.poi.ss.usermodel.PrintSetup.ENVELOPE_C5_PAPERSIZE
        out = jl.office.excel.PaperSize.EnvelopeC5;
      elseif jVal == org.apache.poi.ss.usermodel.PrintSetup.ENVELOPE_C6_PAPERSIZE
        out = jl.office.excel.PaperSize.EnvelopeC6;
      elseif jVal == org.apache.poi.ss.usermodel.PrintSetup.ENVELOPE_CS_PAPERSIZE
        out = jl.office.excel.PaperSize.EnvelopeCS;
      elseif jVal == org.apache.poi.ss.usermodel.PrintSetup.ENVELOPE_DL_PAPERSIZE
        out = jl.office.excel.PaperSize.EnvelopeDL;
      elseif jVal == org.apache.poi.ss.usermodel.PrintSetup.ENVELOPE_MONARCH_PAPERSIZE
        out = jl.office.excel.PaperSize.EnvelopeMonarch;
      elseif jVal == org.apache.poi.ss.usermodel.PrintSetup.EXECUTIVE_PAPERSIZE
        out = jl.office.excel.PaperSize.Executive;
      elseif jVal == org.apache.poi.ss.usermodel.PrintSetup.FOLIO8_PAPERSIZE
        out = jl.office.excel.PaperSize.Folio8;
      elseif jVal == org.apache.poi.ss.usermodel.PrintSetup.LEDGER_PAPERSIZE
        out = jl.office.excel.PaperSize.Ledger;
      elseif jVal == org.apache.poi.ss.usermodel.PrintSetup.LEGAL_PAPERSIZE
        out = jl.office.excel.PaperSize.Legal;
      elseif jVal == org.apache.poi.ss.usermodel.PrintSetup.LETTER_PAPERSIZE
        out = jl.office.excel.PaperSize.Letter;
      elseif jVal == org.apache.poi.ss.usermodel.PrintSetup.LETTER_ROTATED_PAPERSIZE
        out = jl.office.excel.PaperSize.LetterRotated;
      elseif jVal == org.apache.poi.ss.usermodel.PrintSetup.LETTER_SMALL_PAPERSIZE
        out = jl.office.excel.PaperSize.LetterSmall;
      elseif jVal == org.apache.poi.ss.usermodel.PrintSetup.NOTE8_PAPERSIZE
        out = jl.office.excel.PaperSize.Note8;
      elseif jVal == org.apache.poi.ss.usermodel.PrintSetup.PRINTER_DEFAULT_PAPERSIZE
        out = jl.office.excel.PaperSize.PrinterDefault;
      elseif jVal == org.apache.poi.ss.usermodel.PrintSetup.QUARTO_PAPERSIZE
        out = jl.office.excel.PaperSize.Quarto;
      elseif jVal == org.apache.poi.ss.usermodel.PrintSetup.STATEMENT_PAPERSIZE
        out = jl.office.excel.PaperSize.Statement;
      elseif jVal == org.apache.poi.ss.usermodel.PrintSetup.TABLOID_PAPERSIZE
        out = jl.office.excel.PaperSize.Tabloid;
      elseif jVal == org.apache.poi.ss.usermodel.PrintSetup.TEN_BY_FOURTEEN_PAPERSIZE
        out = jl.office.excel.PaperSize.TenByFourteen;
      else
        BADSWITCH
      end
    end
    
  end
  
  methods (Access = private)
    
    function this = PaperSize(jCode)
      this.code = jCode;
    end
    
  end
  
end

