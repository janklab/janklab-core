classdef (Abstract) ManuallyPositionable < handle
  %
  %
  % This is a mix-in-ish interface class. Implementing subclasses must define a
  % property "j" which contains a Java object that implements
  % org.apache.poi.ss.usermodel.charts.ManuallyPositionable.
  
  methods
    
    function out = getManualLayout(this)
      jObj = this.j.getManualLayout;
      out = jl.office.excel.draw.ManualLayout(jObj);
    end
    
  end
  
end