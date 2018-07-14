% Scratch for figuring out how to create DTClients

clientName = 'Hello World';
clientTitle = 'Hello, World';

mdesktop = jl.guihacks.MLDesktop.instance;
desktop = mdesktop.desktop;

% Reuse existing client or create a new one
dtClient = mdesktop.getClientWithName(clientName);
lastLocation = [];
if ~isempty(dtClient)
    disp('Reusing existing client');
    dtClientLocation = jl.util.java.callPrivateMethodOn(dtClient, 'com.mathworks.widgets.desk.DTOccupant', ...
        'getLocation');
    if isempty(dtClientLocation)
        disp('Client location is empty. Ditching and creating new client.');
        lastLocation = jl.util.java.callPrivateMethodOn(dtClient, 'com.mathworks.widgets.desk.DTOccupant', ...
            'getLastLocation');
        desktop.removeClient(clientName);
        dtClient = [];
    end
end
if isempty(dtClient)
    disp('Creating new client');
    dtClient = com.mathworks.widgets.desk.DTClient(desktop, 'javax.swing.JLabel', ...
        clientName, clientTitle);
    defaultLocation = com.mathworks.widgets.desk.DTLocation.createExternal(int32(100), int32(100), ...
        int32(300), int32(200));
    % Using this lastLocation causes Matlab to hang. Maybe it needs an EDT call?
%     if isempty(lastLocation)
%         dtLocation = defaultLocation;
%     else
%         dtLocation = lastLocation;
%     end
    dtLocation = defaultLocation;
    jl.util.java.callPrivateMethodOn(desktop, 'com.mathworks.widgets.desk.Desktop', ...
        'addClient', { dtClient, true, dtLocation, true }, ...
        { [], [], 'com.mathworks.widgets.desk.DTLocation', [] });
end

dtClient.setComponent(javax.swing.JLabel('Hello, World!'));

dtClientLocation = jl.util.java.callPrivateMethodOn(dtClient, 'com.mathworks.widgets.desk.DTOccupant', ...
    'getLocation');

% This doesn't work: showClient() and its variations seem to have no effect
% if isempty(dtClientLocation)
%     lastLocation = jl.util.java.callPrivateMethodOn(dtClient, 'com.mathworks.widgets.desk.DTOccupant', ...
%         'getLastLocation');
%     jl.util.java.callPrivateMethodOn(dtClient, 'com.mathworks.widgets.desk.DTOccupant', ...
%         'setLocation', { lastLocation }, { 'com.mathworks.widgets.desk.DTLocation' });
%     mdesktop.showClient(dtClient, lastLocation, false, true);
% end
