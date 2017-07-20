function load_janklab
%LOAD_JANKLAB Bootstrap function to load Janklab from the local repo

% Load the Janklab distribution

this_file = mfilename('fullpath');
repo_dir = fileparts(fileparts(this_file));
dist_dir = [repo_dir '/dist'];
mcode_dir = [dist_dir '/Mcode'];
cd([mcode_dir '/toplevel']);
init_janklab();