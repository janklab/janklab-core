function init_janklab

if verLessThan('matlab', '9.3.0')
    error('Janklab requires Matlab version 9.3.0 (R2017b) or later. This is version %s.', ...
        version);
end

% Get source files on path
this_file = mfilename('fullpath');
mcode_dir = fileparts(fileparts(this_file));
janklab_dist_root = fileparts(mcode_dir);
children = dir(mcode_dir);
children = setdiff({ children.name }, {'.', '..'});
for i = 1:numel(children)
    p = [mcode_dir '/' children{i}];
    if isFolder(p)
        addpath(p);
    end
end

% Get Java libraries on classpath
% There are "static" variants here to support static-classpath loading of things
% that need it, like JDBC drivers.

% Java libs redistributed with Janklab
java_lib_dir = [janklab_dist_root '/lib/java'];
add_jars_under_directory(java_lib_dir);
java_lib_static_dir = [janklab_dist_root '/lib/java-static'];
add_jars_under_directory_static(java_lib_static_dir);
% And another dir for users to drop their own JAR downloads in, like non-Apache
% JDBC drivers and so on
java_lib_ext_dir = [janklab_dist_root '/lib/java-ext'];
add_jars_under_directory(java_lib_ext_dir);
java_lib_ext_static_dir = [janklab_dist_root '/lib/java-ext-static'];
add_jars_under_directory_static(java_lib_ext_static_dir);
% As a total hack, Java files in the user's Dropbox directory
userHomeDir = char(java.lang.System.getProperty('user.home'));
userDropboxDir = fullfile(userHomeDir, 'Dropbox');
dropboxJavaLibExtStaticDir = fullfile(userDropboxDir, 'Documents', 'Matlab', ...
    'Janklab', 'java', 'lib-ext-static');
if isFolder(dropboxJavaLibExtStaticDir)
    add_jars_under_directory_static(dropboxJavaLibExtStaticDir);
end

% Pull in external Matlab libaries
mat_lib_dir = [janklab_dist_root '/lib/matlab'];
my_mat_libs = {
    'matlab-jarext-inspector/matlab-jarext-inspector-1.0.1'
    };
mcode_dirs = strcat(mat_lib_dir, '/', my_mat_libs, '/Mcode');
addpath(mcode_dirs{:});

% Run initialization code
jl.janklab.init_janklab;

end

function add_jars_under_directory(java_lib_dir)
d = dir(java_lib_dir);
for i = 1:numel(d)
    file = d(i).name;
    if endsWith(file, '.jar')
        jar_file_path = [java_lib_dir '/' file];
        javaaddpath(jar_file_path);
    end
end
end

function add_jars_under_directory_static(java_lib_dir)
hacker = jl.util.StaticClasspathHacker;
d = dir(java_lib_dir);
for i = 1:numel(d)
    file = d(i).name;
    if endsWith(file, '.jar')
        jar_file_path = [java_lib_dir '/' file];
        hacker.addToStaticClasspath(jar_file_path);
    end
end
end

function out = isFolder(file)
jFile = java.io.File(file);
out = jFile.isDirectory;
end