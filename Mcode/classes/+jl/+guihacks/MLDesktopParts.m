classdef MLDesktopParts
    % Knows how to find interesting parts of the Matlab desktop IDE
    
    methods
        function out = desktop(obj) %#ok<*MANU>
            out = com.mathworks.mlservices.MatlabDesktopServices.getDesktop;
        end
    end
end