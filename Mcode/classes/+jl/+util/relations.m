classdef relations
    %RELATIONS Utilities for working with relation objects
    
    methods (Static)
        
        function [S,P,SP] = supplierPartsExample()
        %SUPPLIERPARTSEXAMPLE The classic "Supplier Parts" example database
        [S,P,SP] = jl.util.tables.supplierPartsExample;
        S = relation(S);
        P = relation(P);
        SP = relation(SP);
        
        if nargout == 1
            tmp = S;
            S = struct;
            S.S = tmp;
            S.P = P;
            S.SP = SP;
        end
        end
        
    end
    
    methods (Access=private)
        function this = relations()
        %RELATIONS Private constructor to suppress helptext
        end
    end
end