classdef TestNoDef
    
    properties
        foo = NaN;
        bar = NaN;
    end
    
    methods
        function this = TestNoDef(foo, bar)
        this.foo = foo;
        this.bar = bar;
        end
    end
end
