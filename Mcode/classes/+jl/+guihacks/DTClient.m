classdef DTClient < handle
    %DTCLIENT A wrapper for Matlab's DTClient
    %
    % This class provides methods that are not readily accessible on DTClient
    % itself.
    
    properties
        % The underlying Java DTClient, blessed with javaObjectEDT()
        dtclient
    end
    
    methods
        function this = DTClient(dtclient)
            if nargin == 0
                return
            end
            if isa(dtclient, 'jl.guihacks.DTClient')
                this = dtclient;
                return
            end
            mustBeType(dtclient, 'com.mathworks.widgets.desk.DTClient');
            this.dtclient = javaObjectEDT(dtclient);
        end
        
        function out = getLocation(this)
            out = jl.util.java.callPrivateMethodOn(this.dtclient, ...
                'com.mathworks.widgets.desk.DTOccupant', 'getLocation');
        end
        
        function setLocation(this, newLocation)
            jl.util.java.callPrivateMethod(this.dtclient, 'setLocation', ...
                { newLocation }, { 'com.mathworks.widgets.desk.DTLocation' });
        end
        
        function out = getLastLocation(this)
            out = jl.util.java.callPrivateMethodOn(this.dtclient, ...
                'com.mathworks.widgets.desk.DTOccupant', 'getLastLocation');
        end
        
        function out = getName(this)
            out = char(this.dtclient.getName);
        end
        
        function out = getTitle(this)
            out = char(this.dtclient.getTitle);
        end
        
        function setComponent(this, component)
            this.dtclient.setComponent(component);
        end
    end
    
    methods (Static)
    end
end