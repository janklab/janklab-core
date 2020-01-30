function varargout = scalarexpand(varargin)
%SCALAREXPAND Expand scalar inputs to be same size as nonscalar inputs
%
% varargout = scalarexpand(varargin)

sz = [];

for i = 1:nargin
	if ~isscalar(varargin{i})
		sz_i = size(varargin{i});
		if isempty(sz)
			sz = sz_i;
		else
			if ~isequal(sz, sz_i)
				error('jl:InconsistentDimensions', 'Matrix dimensions must agree (%s vs %s)',...
					size2str(sz), size2str(sz_i))
			end
		end
	end
end

varargout = varargin;

if isempty(sz)
	return
end

for i = 1:nargin
	if isscalar(varargin{i})
    varargout{i} = repmat(varargin{i}, sz);
	end
end

end
