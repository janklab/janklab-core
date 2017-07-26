function out = janklab_sourcetree_root
%JANKLAB_SOURCETREE_ROOT Root of the Janklab source tree

this_file = mfilename('fullpath');
% This logic depends on the relative location of dev-kit/ withint the
% source tree.
out = fileparts(fileparts(fileparts(this_file)));
