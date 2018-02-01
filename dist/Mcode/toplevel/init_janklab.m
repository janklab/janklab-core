function init_janklab

% Get source files on path
this_file = mfilename('fullpath');
mcode_dir = fileparts(fileparts(this_file));
janklab_dist_root = fileparts(mcode_dir);
children = dir(mcode_dir);
children = setdiff({ children.name }, {'.', '..'});
for i = 1:numel(children)
    p = [mcode_dir '/' children{i}];
    if isdir(p)
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