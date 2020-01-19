classdef HyperlinkType
  
  enumeration
    Document, Email, File, None, Url
  end
  
  methods (Static)
    
    function out = ofJava(j)
      if isempty(j)
        out = jl.office.excel.HyperlinkType.None;
      elseif j.equals(org.apache.poi.common.usermodel.HyperlinkType.DOCUMENT)
        out = jl.office.excel.HyperlinkType.Document;
      elseif j.equals(org.apache.poi.common.usermodel.HyperlinkType.EMAIL)
        out = jl.office.excel.HyperlinkType.Email;
      elseif j.equals(org.apache.poi.common.usermodel.HyperlinkType.FILE)
        out = jl.office.excel.HyperlinkType.File;
      elseif j.equals(org.apache.poi.common.usermodel.HyperlinkType.NONE)
        out = jl.office.excel.HyperlinkType.None;
      elseif j.equals(org.apache.poi.common.usermodel.HyperlinkType.URL)
        out = jl.office.excel.HyperlinkType.Url;
      else
        error('jl:InvalidInput', 'Invalid input');
      end
    end
    
  end
  
end