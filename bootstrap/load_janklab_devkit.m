function load_janklab_devkit
%LOAD_JANKLAB_DEVKIT Load Janklab and its dev kit from the local repo
%
% The Janklab "dev kit" is a set of additional tools used for developing 
% Janklab itself.

% Load the Janklab distribution

this_file = mfilename('fullpath');
repo_dir = fileparts(fileparts(this_file));
mcode_dir = [repo_dir '/Mcode'];
cd([mcode_dir '/toplevel']);

init_janklab();

cd(mcode_dir);

% Load the dev kit (and scratch dir)

devkit_dir = [repo_dir '/dev-kit'];
devkit_mcode_dir = [devkit_dir '/Mcode'];
addpath(devkit_mcode_dir);
scratch_dir = [repo_dir '/scratch'];
addpath(scratch_dir);

% Load the unit tests

testsuite_dir = [repo_dir '/tests'];
testsuite_mcode_dir = [testsuite_dir '/Mcode'];
addpath(testsuite_mcode_dir);

disp('Janklab Dev Kit loaded');
