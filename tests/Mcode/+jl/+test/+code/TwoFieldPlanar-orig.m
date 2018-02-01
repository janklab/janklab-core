classdef TwoFieldPlanar < jl.code.PlanarClassBase
    
    % @planarclass
    
    properties
        x = NaN; % @planar
        y = NaN; % @planar
    end
    
    methods
        function this = TwoFieldPlanar(x, y)
        if nargin == 0
            return;
        end
        this.x = x;
        this.y = y;
        end
        
        function out = isnan(this)
        out = isnan(this.x) | isnan(this.y);
        end
    end
    
end