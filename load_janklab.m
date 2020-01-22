function load_janklab

repoDir = fileparts(mfilename('fullpath'));
toplevelDir = [repoDir '/Mcode/toplevel'];
addpath(toplevelDir);
init_janklab;
