function load_janklab
%LOAD_JANKLAB Bootstrap function to load Janklab from the local repo

% Load the Janklab distribution

this_file = mfilename('fullpath');
mcode_dir = fileparts(fileparts(this_file));
cd([mcode_dir '/toplevel']);
init_janklab();
cd(mcode_dir);
