function out = CRLF()
%CRLF The carriage return - linefeed ("\r\n") sequence
%
% out = CRLF()
%
% Returns the two-character CRLF carriagereturn-linefeed sequence. This is
% equivalent to `sprintf('\r\n')` and is intended as a shorthand for it.
%
% See also:
% LF

persistent value
if isempty(value)
	value = sprintf('\r\n');
end

out = value;
