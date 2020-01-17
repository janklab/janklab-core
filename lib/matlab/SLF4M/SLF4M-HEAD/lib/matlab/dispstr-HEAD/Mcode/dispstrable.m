classdef dispstrable
%DISPSTRABLE Mixin that implements DISP and DISPSTR from DISPSTRS
%
% This is a convenience mixin class provided for class authors to make it easier
% to write classes that use DISPSTR and DISPSTRS.
%
% To use it, inherit from DISPSTRABLE and define a custom DISPSTRS method.
% DISPSTRABLE will take care of defining DISP an DISPSTR methods based on it.
% The custom DISP method will respect DISPSTR, which will in turn respect 
% DISPSTRS.
%
% See also:
% DISPSTR
% DISPSTRS

methods
    function disp(this)
        %DISP Custom display
        disp(dispstr(this));
    end
    
    function out = dispstr(this)
        %DISPSTR Display string for array
        if isscalar(this)
            strs = dispstrs(this);
            out = strs{1};
        else
            out = sprintf('%s %s', dispstrlib.internal.size2str(size(this)), ...
                class(this));
        end
    end
end

end