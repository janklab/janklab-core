classdef ThreeFieldPlanar
    
    % @planarprecedence(foo, bar, baz)
    % @planarsetops
    
    properties
        foo = NaN % @planar
        bar = NaN % @planar
        baz = NaN % @planar
    end
    
    methods
        function this = ThreeFieldPlanar(foo, bar, baz)
        this.foo = foo;
        this.bar = bar;
        this.baz = baz;
        end
    end

end

