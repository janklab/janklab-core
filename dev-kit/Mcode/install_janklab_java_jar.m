function install_janklab_java_jar
%INSTALL_JANKLAB_JAVA_JAR Install our Java component's JAR into dist
%
% This "installs" the janklab-java JAR file from its build directory under
% src/java to the lib directory under dist/lib/java, where the Matlab layer
% will pick it up.
%
% You need to restart Matlab after running this in order to pick up the new
% version.

srcroot = janklab_sourcetree_root;
jarBaseName = 'janklab-java-0.1-SNAPSHOT.jar';
jarInBuild = [srcroot '/src/java/janklab-java/target/' jarBaseName];

if ~exist(jarInBuild, 'file')
    error('JAR file does not exist: %s', jarInBuild);
end

distLibDir = [srcroot '/dist/lib/java'];
[ok,message] = copyfile(jarInBuild, distLibDir, 'f');
if ~ok
    error('Failed installing JAR file to dist/lib/java: %s', message);
end

fprintf('Installed %s to %s\n', jarBaseName, distLibDir);
