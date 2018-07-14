% Scratch for figuring out how to create DTClients

dtp = jl.guihacks.MLDesktopParts;
desktop = dtp.desktop;
dtClient = com.mathworks.widgets.desk.DTClient(desktop, 'javax.swing.JLabel', ...
    'Hello World Name', 'Hello World Title');
dtClient.setComponent(javax.swing.JLabel('Hello, World!'));

% Doesn't work because constructor is package-scope
% dtGroup = com.mathworks.widgets.desk.DTGroup(desktop, 'Hello Group', ...
%    desktop.getMainFrame);

% Hack to access the inaccessible constructor
dtGroupClass = jl.util.java.classForName('com.mathworks.widgets.desk.DTGroup');
constructorArgTypes = javaArray('java.lang.Class', 3);
constructorArgTypes(1) = jl.util.java.classForName('com.mathworks.widgets.desk.Desktop');
constructorArgTypes(2) = jl.util.java.classForName('java.lang.String');
constructorArgTypes(3) = jl.util.java.classForName('com.mathworks.widgets.desk.DTFrame');
dtGroupConstructor = dtGroupClass.getDeclaredConstructor(constructorArgTypes);
dtGroupConstructor.setAccessible(true);
constructorArgs = javaArray('java.lang.Object', 3);
constructorArgs(1) = desktop;
constructorArgs(2) = java.lang.String('Hello Group');
constructorArgs(3) = [];
%dtGroup = dtGroupConstructor.newInstance(constructorArgs);

dtGroup = jl.util.java.callPrivateConstructor('com.mathworks.widgets.desk.DTGroup', ...
    { desktop, 'Hello Group', [] }, ...
    { 'com.mathworks.widgets.desk.Desktop', 'java.lang.String', 'com.mathworks.widgets.desk.DTFrame' });

%jl.util.java.callPrivateMethod(desktop, 'addGroup', { dtGroup });
%jl.util.java.callPrivateMethod(desktop, 'createUndockedFrame', { dtGroup });

dtLocation = com.mathworks.widgets.desk.DTLocation.createExternal(int32(100), int32(100));
jl.util.java.callPrivateMethodOn(desktop, 'com.mathworks.widgets.desk.Desktop', ...
    'addClient', { dtClient, true, dtLocation, true }, ...
    { [], [], 'com.mathworks.widgets.desk.DTLocation', [] });
