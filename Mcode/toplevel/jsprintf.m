function out = jsprintf(fmt, varargin)
% jsprintf Sprintf, but using Java's extended formatting support
%
% out = jsprintf(fmt, varargin)
%
% This lets you call sprintf in a way that uses Java's sprintf formatting
% (from java.lang.String.format) instead of Matlab's built-in sprintf. This
% supports formatting extensions like "%,f" for thousands-separator commas.
%
% Dispstr support and sprintfv "vectorization" are also built in.

args = varargin;
for 