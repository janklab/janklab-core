classdef ClientAnchorType < handle
  
  properties
    j
  end
  
  enumeration
    DontMoveAndResize(jl.util.java.getStaticFieldOnClass(...
      'org.apache.poi.ss.usermodel.ClientAnchor$AnchorType', 'DONT_MOVE_AND_RESIZE'))
    DontMoveDoResize(jl.util.java.getStaticFieldOnClass(...
      'org.apache.poi.ss.usermodel.ClientAnchor$AnchorType', 'DONT_MOVE_DO_RESIZE'))
    MoveAndResize(jl.util.java.getStaticFieldOnClass(...
      'org.apache.poi.ss.usermodel.ClientAnchor$AnchorType', 'MOVE_AND_RESIZE'))
    MoveDontResize(jl.util.java.getStaticFieldOnClass(...
      'org.apache.poi.ss.usermodel.ClientAnchor$AnchorType', 'MOVE_DONT_RESIZE'))
  end
  
  
  methods (Static)
    
    function out = ofJava(jObj)
      if isempty(jObj)
        out = [];
      elseif jObj.equals(jl.util.java.getStaticFieldOnClass(...
          'org.apache.poi.ss.usermodel.ClientAnchor$AnchorType', 'DONT_MOVE_AND_RESIZE'))
        out = jl.office.excel.ClientAnchorType.DontMoveAndResize;
      elseif jObj.equals(jl.util.java.getStaticFieldOnClass(...
          'org.apache.poi.ss.usermodel.ClientAnchor$AnchorType', 'DONT_MOVE_DO_RESIZE'))
        out = jl.office.excel.ClientAnchorType.DontMoveDoResize;
      elseif jObj.equals(jl.util.java.getStaticFieldOnClass(...
          'org.apache.poi.ss.usermodel.ClientAnchor$AnchorType', 'MOVE_AND_RESIZE'))
        out = jl.office.excel.ClientAnchorType.MoveAndResize;
      elseif jObj.equals(jl.util.java.getStaticFieldOnClass(...
          'org.apache.poi.ss.usermodel.ClientAnchor$AnchorType', 'MOVE_DONT_RESIZE'))
        out = jl.office.excel.ClientAnchorType.MoveDontResize;
      else
        BADSWITCH
      end
    end
    
  end
  
  methods
    
    function out = toJava(this)
      out = this.j;
    end
    
  end
  
  methods (Access = private)
    
    function this = ClientAnchorType(jObj)
      this.j = jObj;
    end
    
  end
  
end