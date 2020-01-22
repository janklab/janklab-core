function package_janklab
% Packages Janklab as a Matlab Toolbox
%
% Janklab must be loaded in order for this to work.

if ~isfolder('dist')
  mkdir('dist');
end

targetFile = sprintf('dist/Janklab-%s.mltbx', jl.janklab.version);
if isfile(targetFile)
  delete(targetFile);
end

matlab.addons.toolbox.packageToolbox('Janklab.prj');
movefile('Janklab.mltbx', targetFile);

fprintf('Janklab packaged to %s\n', targetFile);
