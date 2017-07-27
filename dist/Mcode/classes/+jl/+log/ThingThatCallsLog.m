classdef ThingThatCallsLog
    
    methods
        function foo(this)
        this.bar;
        end
        
        function bar(this)
        jl.log.error('whatever');
        end
    end
end
