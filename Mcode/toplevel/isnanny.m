function out = isnanny(x)
%ISNANNY True if input is NaN or NaT
%
% out = isnanny(x)
%
% This is a hack to work around the edge case of @datetime, which
% defines an isnat() function instead of supporting isnan() like
% everything else.
%
% Returns a logical array the same size as x.

if isa(x, 'datetime')
	out = isnat(x);
else
	out = isnan(x);
end
end