% Scratch for figuring out how to create DTClients

dtp = jl.guihacks.MLDesktopParts;
desktop = dtp.desktop;
dtClient = com.mathworks.widgets.desk.DTClient(desktop, 'javax.swing.JLabel', ...
    'Hello World Name', 'Hello World Title');
dtClient.setComponent(javax.swing.JLabel('Hello, World!'));

% dtGroup = jl.util.java.callPrivateConstructor('com.mathworks.widgets.desk.DTGroup', ...
%     { desktop, 'Hello Group', [] }, ...
%     { 'com.mathworks.widgets.desk.Desktop', ...
%     'java.lang.String', 'com.mathworks.widgets.desk.DTFrame' });

%jl.util.java.callPrivateMethod(desktop, 'addGroup', { dtGroup });
%jl.util.java.callPrivateMethod(desktop, 'createUndockedFrame', { dtGroup });

dtLocation = com.mathworks.widgets.desk.DTLocation.createExternal(int32(100), int32(100));
jl.util.java.callPrivateMethodOn(desktop, 'com.mathworks.widgets.desk.Desktop', ...
    'addClient', { dtClient, true, dtLocation, true }, ...
    { [], [], 'com.mathworks.widgets.desk.DTLocation', [] });
