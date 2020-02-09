classdef IconMultiStateFormattingIconSet
  %ICONMULTISTATEFORMATTINGICONSET
  
  properties
    j
  end
  
  enumeration
    Grey3Arrows(jl.util.java.getStaticFieldOnClass(...
      'org.apache.poi.ss.usermodel.IconMultiStateFormatting$IconSet', 'GREY_3_ARROWS'))
    Grey4Arrows(jl.util.java.getStaticFieldOnClass(...
      'org.apache.poi.ss.usermodel.IconMultiStateFormatting$IconSet', 'GREY_4_ARROWS'))
    Grey5Arrows(jl.util.java.getStaticFieldOnClass(...
      'org.apache.poi.ss.usermodel.IconMultiStateFormatting$IconSet', 'GREY_5_ARROWS'))
    Gyr3Arrow(jl.util.java.getStaticFieldOnClass(...
      'org.apache.poi.ss.usermodel.IconMultiStateFormatting$IconSet', 'GYR_3_ARROW'))
    Gyr3Flags(jl.util.java.getStaticFieldOnClass(...
      'org.apache.poi.ss.usermodel.IconMultiStateFormatting$IconSet', 'GYR_3_FLAGS'))
    Gyr3Symbols(jl.util.java.getStaticFieldOnClass(...
      'org.apache.poi.ss.usermodel.IconMultiStateFormatting$IconSet', 'GYR_3_SYMBOLS'))
    Gyr3SymbolsCircle(jl.util.java.getStaticFieldOnClass(...
      'org.apache.poi.ss.usermodel.IconMultiStateFormatting$IconSet', 'GYR_3_SYMBOLS_CIRCLE'))
    Gyr3TrafficLights(jl.util.java.getStaticFieldOnClass(...
      'org.apache.poi.ss.usermodel.IconMultiStateFormatting$IconSet', 'GYR_3_TRAFFIC_LIGHTS'))
    Gyr3TrafficLightsBox(jl.util.java.getStaticFieldOnClass(...
      'org.apache.poi.ss.usermodel.IconMultiStateFormatting$IconSet', 'GYR_3_TRAFFIC_LIGHTS_BOX'))
    Gyr4Arrows(jl.util.java.getStaticFieldOnClass(...
      'org.apache.poi.ss.usermodel.IconMultiStateFormatting$IconSet', 'GYR_4_ARROWS'))
    Gyrb4TrafficLights(jl.util.java.getStaticFieldOnClass(...
      'org.apache.poi.ss.usermodel.IconMultiStateFormatting$IconSet', 'GYRB_4_TRAFFIC_LIGHTS'))
    Gyyyr5Arrows(jl.util.java.getStaticFieldOnClass(...
      'org.apache.poi.ss.usermodel.IconMultiStateFormatting$IconSet', 'GYYYR_5_ARROWS'))
    Quarters5(jl.util.java.getStaticFieldOnClass(...
      'org.apache.poi.ss.usermodel.IconMultiStateFormatting$IconSet', 'QUARTERS_5'))
    Ratings4(jl.util.java.getStaticFieldOnClass(...
      'org.apache.poi.ss.usermodel.IconMultiStateFormatting$IconSet', 'RATINGS_4'))
    Ratings5(jl.util.java.getStaticFieldOnClass(...
      'org.apache.poi.ss.usermodel.IconMultiStateFormatting$IconSet', 'RATINGS_5'))
    Rb4TrafficLights(jl.util.java.getStaticFieldOnClass(...
      'org.apache.poi.ss.usermodel.IconMultiStateFormatting$IconSet', 'RB_4_TRAFFIC_LIGHTS'))
  end
  
  methods (Static)
    
    function out = ofJava(jObj)
      if isempty(jObj)
        out = [];
      elseif jObj.equals(jl.util.java.getStaticFieldOnClass(...
          'org.apache.poi.ss.usermodel.IconMultiStateFormatting$IconSet', 'GREY_3_ARROWS'))
        out = jl.office.excel.cf.IconMultiStateFormattingIconSet.Grey3Arrows;
      elseif jObj.equals(jl.util.java.getStaticFieldOnClass(...
          'org.apache.poi.ss.usermodel.IconMultiStateFormatting$IconSet', 'GREY_4_ARROWS'))
        out = jl.office.excel.cf.IconMultiStateFormattingIconSet.Grey4Arrows;
      elseif jObj.equals(jl.util.java.getStaticFieldOnClass(...
          'org.apache.poi.ss.usermodel.IconMultiStateFormatting$IconSet', 'GREY_5_ARROWS'))
        out = jl.office.excel.cf.IconMultiStateFormattingIconSet.Grey5Arrows;
      elseif jObj.equals(jl.util.java.getStaticFieldOnClass(...
          'org.apache.poi.ss.usermodel.IconMultiStateFormatting$IconSet', 'GYR_3_ARROW'))
        out = jl.office.excel.cf.IconMultiStateFormattingIconSet.Gyr3Arrow;
      elseif jObj.equals(jl.util.java.getStaticFieldOnClass(...
          'org.apache.poi.ss.usermodel.IconMultiStateFormatting$IconSet', 'GYR_3_FLAGS'))
        out = jl.office.excel.cf.IconMultiStateFormattingIconSet.Gyr3Flags;
      elseif jObj.equals(jl.util.java.getStaticFieldOnClass(...
          'org.apache.poi.ss.usermodel.IconMultiStateFormatting$IconSet', 'GYR_3_SYMBOLS'))
        out = jl.office.excel.cf.IconMultiStateFormattingIconSet.Gyr3Symbols;
      elseif jObj.equals(jl.util.java.getStaticFieldOnClass(...
          'org.apache.poi.ss.usermodel.IconMultiStateFormatting$IconSet', 'GYR_3_SYMBOLS_CIRCLE'))
        out = jl.office.excel.cf.IconMultiStateFormattingIconSet.Gyr3SymbolsCircle;
      elseif jObj.equals(jl.util.java.getStaticFieldOnClass(...
          'org.apache.poi.ss.usermodel.IconMultiStateFormatting$IconSet', 'GYR_3_TRAFFIC_LIGHTS'))
        out = jl.office.excel.cf.IconMultiStateFormattingIconSet.Gyr3TrafficLights;
      elseif jObj.equals(jl.util.java.getStaticFieldOnClass(...
          'org.apache.poi.ss.usermodel.IconMultiStateFormatting$IconSet', 'GYR_3_TRAFFIC_LIGHTS_BOX'))
        out = jl.office.excel.cf.IconMultiStateFormattingIconSet.Gyr3TrafficLightsBox;
      elseif jObj.equals(jl.util.java.getStaticFieldOnClass(...
          'org.apache.poi.ss.usermodel.IconMultiStateFormatting$IconSet', 'GYR_4_ARROWS'))
        out = jl.office.excel.cf.IconMultiStateFormattingIconSet.Gyr4Arrows;
      elseif jObj.equals(jl.util.java.getStaticFieldOnClass(...
          'org.apache.poi.ss.usermodel.IconMultiStateFormatting$IconSet', 'GYRB_4_TRAFFIC_LIGHTS'))
        out = jl.office.excel.cf.IconMultiStateFormattingIconSet.Gyrb4TrafficLights;
      elseif jObj.equals(jl.util.java.getStaticFieldOnClass(...
          'org.apache.poi.ss.usermodel.IconMultiStateFormatting$IconSet', 'GYYYR_5_ARROWS'))
        out = jl.office.excel.cf.IconMultiStateFormattingIconSet.Gyyyr5Arrows;
      elseif jObj.equals(jl.util.java.getStaticFieldOnClass(...
          'org.apache.poi.ss.usermodel.IconMultiStateFormatting$IconSet', 'QUARTERS_5'))
        out = jl.office.excel.cf.IconMultiStateFormattingIconSet.Quarters5;
      elseif jObj.equals(jl.util.java.getStaticFieldOnClass(...
          'org.apache.poi.ss.usermodel.IconMultiStateFormatting$IconSet', 'RATINGS_4'))
        out = jl.office.excel.cf.IconMultiStateFormattingIconSet.Ratings4;
      elseif jObj.equals(jl.util.java.getStaticFieldOnClass(...
          'org.apache.poi.ss.usermodel.IconMultiStateFormatting$IconSet', 'RATINGS_5'))
        out = jl.office.excel.cf.IconMultiStateFormattingIconSet.Ratings5;
      elseif jObj.equals(jl.util.java.getStaticFieldOnClass(...
          'org.apache.poi.ss.usermodel.IconMultiStateFormatting$IconSet', 'RB_4_TRAFFIC_LIGHTS'))
        out = jl.office.excel.cf.IconMultiStateFormattingIconSet.Rb4TrafficLights;
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
    
    function this = IconMultiStateFormattingIconSet(jObj)
      this.j = jObj;
    end
    
  end
  
end

