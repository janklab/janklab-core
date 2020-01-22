function package_toolbox
% Packages Janklab as a Matlab Toolbox
%
% package_toolbox
%
% The project must be loaded on to the Matlab path in order for this to work.
%
% This script contains Janklab-specific code, so if you want to use it for your
% project, you'll have to edit it a bit.
%
% TODO: Generify this script so it's not Janklab-specific.

tbName = 'Janklab';

if ~isfolder('dist')
  mkdir('dist');
end

targetFile = sprintf('dist/%s-%s.mltbx', tbName, jl.janklab.version);
if isfile(targetFile)
  delete(targetFile);
end

matlab.addons.toolbox.packageToolbox(sprintf('%s.prj', tbName));
movefile([tbName '.mltbx'], targetFile);

fprintf('%s packaged to %s\n', tbName, targetFile);
