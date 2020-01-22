function load_janklab
%LOAD_JANKLAB Bootstrap function to load Janklab from the local repo

% Load the Janklab distribution

this_file = mfilename('fullpath');
repo_dir = fileparts(fileparts(this_file));
mcode_dir = [repo_dir '/Mcode'];
cd([mcode_dir '/toplevel']);
init_janklab();
cd(mcode_dir);

% Check the version

if verLessThan('matlab', '9.7.0')
  warning(['This version of Matlab is too old. Janklab requires Matlab R2019b ' ...
    'or newer. Some parts of Janklab will not work.\n']);
end
