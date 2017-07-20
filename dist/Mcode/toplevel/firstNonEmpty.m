function out = firstNonEmpty(varargin)
%FIRSTNONEMPTY Returns the first nonempty argument
%
% out = firstNonEmpty(varargin)
%
% Returns the first nonempty argument it is passed. This is useful for defining
% defaults and fallback values. If no arguments are empty, returns [].

for i = 1:nargin
    if ~isempty(varargin{i})
        out = varargin{i};
        return;
    end
end

out = [];

end