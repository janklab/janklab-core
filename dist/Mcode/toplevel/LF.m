function out = LF()
%LF The linefeed ("\n") character
%
% out = LF()
%
% Returns the linefeed character. This is the one-character end-of-line indicator
% for Unix systems, and what Matlab uses internally.
%
% This is a shorthand for sprintf('\n'). It is intended for use as a pseudo-literal
% or constant, so typically you won't use the function-call parentheses.
%
% Examples:
%
% two_lines = [ 'line_one' LF 'line_two' LF ];
%
% See also:
% CRLF

persistent value
if isempty(value)
	value = sprintf('\n');
end

out = value;
