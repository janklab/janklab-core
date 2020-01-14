classdef Birthday < dispstrable
    
    properties
        Month
        Day
    end
    
    methods
        function this = Birthday(month, day)
            this.Month = month;
            this.Day = day;
        end
        
        function out = dispstrs(this)
            out = cell(size(this));
            for i = 1:numel(this)
                out{i} = datestr(datenum(1, this(i).Month, this(i).Day), 'mmm dd');
            end
        end
    end
    
end