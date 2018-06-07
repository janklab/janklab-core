function out = CR()
%CR The carriage return ("\r") character
%
% out = CR
%
% Returns the carriage return character. This is the one-character 
% end-of-line indicator for old school Macintoshes.
%
% This is a shorthand for sprintf('\r'). It is intended for use as a pseudo-literal
% or constant, so typically you won't use the function-call parentheses.
%
% Examples:
%
% two_lines = [ 'line_one' CR 'line_two' CR ];
%
% See also:
% CRLF, LF

persistent value
if isempty(value)
	value = sprintf('\r');
end

out = value;