function init_janklab

% Detect Matlab vs Octave
v = ver;
ver_names = {v.Name};
is_octave = ismember('Octave', ver_names);

if ~is_octave
  if verLessThan('matlab', '9.3.0')
      error('Janklab requires Matlab version 9.3.0 (R2017b) or later. This is version %s.', ...
          version);
  end
end

% Get source files on path
this_file = mfilename('fullpath');
mcode_dir = fileparts(fileparts(this_file));
janklab_project_root = fileparts(mcode_dir);
children = dir(mcode_dir);
children = setdiff({ children.name }, {'.', '..'});
for i = 1:numel(children)
    p = [mcode_dir '/' children{i}];
    if isFolder(p)
        addpath(p);
    end
end

% Get the root dir on the path, because that has info.xml, and making that
% available gets our toolbox doco in the Matlab documentation browser
addpath(janklab_project_root);

% Get libraries on classpath
lib_root = [janklab_project_root '/lib'];

% Get Java libraries on classpath
% There are "static" variants here to support static-classpath loading of things
% that need it, like JDBC drivers.

% Java libs redistributed with Janklab
java_lib_dir = [lib_root '/java'];
add_jars_under_directory(java_lib_dir, is_octave);
java_lib_static_dir = [lib_root '/java-static'];
add_jars_under_directory_static(java_lib_static_dir, is_octave);
% And another dir for users to drop their own JAR downloads in, like non-Apache
% JDBC drivers and so on
java_lib_ext_dir = [lib_root '/java-ext'];
add_jars_under_directory(java_lib_ext_dir, is_octave);
java_lib_ext_static_dir = [lib_root '/java-ext-static'];
add_jars_under_directory_static(java_lib_ext_static_dir, is_octave);
% As a total hack, load Java files in the user's Dropbox directory
user_home_dir = char(javaMethod('getProperty', 'java.lang.System', 'user.home'));
user_dropbox_dir = fullfile(user_home_dir, 'Dropbox');
dropbox_java_lib_ext_static_dir = fullfile(user_dropbox_dir, 'Documents', 'Matlab', ...
    'Janklab', 'java', 'lib-ext-static');
if isFolder(dropbox_java_lib_ext_static_dir)
    add_jars_under_directory_static(dropbox_java_lib_ext_static_dir, is_octave);
end

% Pull in external Matlab libaries
mat_lib_dir = [lib_root '/matlab'];
my_mat_libs = {
    'matlab-jarext-inspector/matlab-jarext-inspector-1.0.1'
    'dispstr/dispstr-1.1.0'
    'SLF4M/SLF4M-HEAD'
    };
mcode_dirs = strcat(mat_lib_dir, '/', my_mat_libs, '/Mcode');
addpath(mcode_dirs{:});

% Run initialization code
jl.janklab.init_janklab;

end

function add_jars_under_directory(java_lib_dir, is_octave)
	add_jars_under_directory_impl(java_lib_dir, 'dynamic', is_octave);
end

function add_jars_under_directory_static(java_lib_dir, is_octave)
	add_jars_under_directory_impl(java_lib_dir, 'static', is_octave);
end

function add_jars_under_directory_impl(java_lib_dir, path_type, is_octave)
d = dir(java_lib_dir);
for i = 1:numel(d)
    file = d(i).name;
		if ismember(file, {'.', '..'})
			continue
		end
    if myEndsWith(file, '.jar') && ~d(i).isdir
        jar_file_path = [java_lib_dir '/' file];
        javaaddpath_type(jar_file_path, path_type, is_octave);
    end
		% Pull in one level of subdirs, too
		if d(i).isdir
			subdir = [java_lib_dir '/' file];
			d2 = dir(subdir);
			for j = 1:numel(d2)
				file2 = d2(j).name;
				if myEndsWith(file2, '.jar')
						jar_file_path = [subdir '/' file2];
						javaaddpath_type(jar_file_path, path_type, is_octave);
				end
			end
		end
end
end

function out = myEndsWith(str, pattern)
  if numel(str) < numel(pattern)
    out = false;
  else
    n = numel(pattern);
    out = isequal(str(end-(n-1):end), pattern);
  end
end

function javaaddpath_type(path_dir, path_type, is_octave)
switch path_type
	case 'dynamic'
		javaaddpath(path_dir);
	case 'static'
    if is_octave
      % static classpath hacking is not supported in Octave
      javaaddpath(path_dir);
    else
      hacker = jl.util.StaticClasspathHacker;
      hacker.addToStaticClasspath(path_dir);
    end
	otherwise
		error('Invalid path type: %s', path_type);
end
end

function out = isFolder(file)
jFile = javaObject('java.io.File', file);
out = jFile.isDirectory;
end