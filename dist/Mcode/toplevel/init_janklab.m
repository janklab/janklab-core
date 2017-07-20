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
java_lib_dir = [janklab_dist_root '/lib/java'];
d = dir(java_lib_dir);
for i = 1:numel(d)
	file = d(i).name;
	if endsWith(file, '.jar')
		jar_file_path = [java_lib_dir '/' file];
		javaaddpath(jar_file_path);
	end
end

% Run initialization code
jl.janklab.init_janklab;

end

