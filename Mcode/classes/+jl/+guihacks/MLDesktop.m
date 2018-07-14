classdef MLDesktop < handle
    %MLDESKTOP A wrapper for Matlab's MLDesktop
    %
    % This class provides methods that are not readily accessible on MLDesktop
    % itself.
    
    properties
        % The MLDesktop Java object
        desktop
    end
    
    methods (Static)
        function out = instance
        %INSTANCE Get the singleton instance of MLDesktop
        persistent singleton
        if isempty(singleton)
            dtp = jl.guihacks.MLDesktopParts;
            singleton = jl.guihacks.MLDesktop(dtp.desktop);
        end
        out = singleton;
        end
    end
    
    methods
        function out = getClients(this)
        %GETCLIENTS Get all DTClients in this Desktop
        %
        % Returns a Java com.mathworks.widdets.desk.DTClient[] array.
        clientList = jl.util.java.callPrivateMethodOn(this.desktop, ...
            'com.mathworks.widgets.desk.Desktop', 'getClients');
        out = javaArray('com.mathworks.widgets.desk.DTClient', clientList.size);
        for i = 1:numel(out)
            out(i) = clientList.get(i-1);
        end
        end
        
        function out = getClientWithName(this, name)
        %GETCLIENTWITHNAME Get DTClient with the given name
        clients = this.getClients;
        for i = 1:numel(clients)
            if isequal(char(clients(i).getName), name)
                out = clients(i);
                return
            end
        end
        out = [];
        end
        
        function out = getClientWithTitle(this, title)
        %GETCLIENTWITHTITLE Get DTClient with the given title
        clients = this.getClients;
        for i = 1:numel(clients)
            if isequal(char(clients(i).getTitle), title)
                out = clients(i);
                return
            end
        end
        out = [];
        end
        
        function showClient(this, dtClient, dtLocation, tf1, tf2)
        %SHOWCLIENT
        jl.util.java.callPrivateMethodOn(this.desktop, ...
            'com.mathworks.widgets.desk.Desktop', 'showClient', ...
            { dtClient, dtLocation, tf1, tf2 }, ...
            { 'com.mathworks.widgets.desk.DTClient', 'com.mathworks.widgets.desk.DTLocation', ...
            [], [] });
        end
        
        function showAnchoredClient(this, dtClient)
        %SHOWCLIENT
        jl.util.java.callPrivateMethodOn(this.desktop, ...
            'com.mathworks.widgets.desk.Desktop', 'showAnchoredClient', ...
            { dtClient }, ...
            { 'com.mathworks.widgets.desk.DTClient' });
        end
    end
    
    methods (Access = private)
        function this = MLDesktop(jDesktop)
        this.desktop = jDesktop;
        end
    end
end