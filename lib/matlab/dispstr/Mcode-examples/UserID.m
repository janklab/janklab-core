classdef UserID < dispstrable
    
    properties
        id
    end
    
    methods
        function this = UserID(idstr)
            this.id = idstr;
        end
        
        function out = dispstrs(this)
            out = cell(size(this));
            for i = 1:numel(this)
                out{i} = this(i).id;
            end
        end
        
    end
end
