classdef java
    % Java-related utilities
   
    methods (Static)
        function out = classForName(name)
        % Get the java.lang.Class metaclass for a named Java class
        %
        % This does a Java Class.forName, but invokes it from within the dynamic
        % classpath's class loader, so all classes on the dynamic Java 
        % classpath are visible.
        out = net.janklab.util.Reflection.classForName(name);
        end
    end
    
    methods (Access = private)
        function this = java()
        % Private constructor to suppress helptext
        end
    end
end