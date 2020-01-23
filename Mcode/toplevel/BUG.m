function BUG(fmt, varargin)
%BUG Indicates that an "unreachable" code path has been reached
%
% Stick this in code branches that you think

if nargin < 1
  msg = [];
else
  msg = sprintf(fmt, varargin{:});
end

errmsg = 'BUG! An "unreachable" code path has been hit!';
if ~isempty(msg)
  errmsg = [errmsg ' Message: ' msg];
end
error('jl:Bug', errmsg);
