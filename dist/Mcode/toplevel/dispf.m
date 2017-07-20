function dispf(format, varargin)
%DISPF Display, with printf-style formatting
%
% dispf(format, varargin)
%
% Displays the given text, which is defined using FPRINTF-style formatting
% arguments.
%
% This is a convenience wrapper around fprintf that lets you omit the
% trailing newline, and save a couple characters of typing.
%
% See also FPRINTF, DISP

fprintf([format '\n'], varargin{:});