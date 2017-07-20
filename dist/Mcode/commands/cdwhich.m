function cdwhich(name)
%CDWHICH CD to the location where a function is defined
%
%   cdwhich foo
%
% Cd's to the directory that the foo.m defining 'foo' is located in. Prints
% the directory it cd'ed to.
%
% If foo does not correspond to a file, then a message is displayed and the
% cwd is not changed.

s = which(name);

if isempty(s)
	dispf('cdwhich: no such function: %s', name);
	return
elseif isequal(s, 'variable')
	dispf('cdwhich: %s is a variable', name)
	return
elseif ~exist(s, 'file')
	dispf('cdwhich: %s: no such file: %s', name, s);
	return
end

target_dir = fileparts(s);
cd(target_dir)
disp(target_dir);
