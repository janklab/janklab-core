function out = parseOpts(opts, defaults)
%PARSEOPTS Parse a Janklab-style "option" argument
%
% out = jl.util.parseOpts(opts, defaults)
%
% Parses a Janklab-style "option" argument into a struct, optionally applying
% defaults. Generally you will want to supply a defaults with all fields
% present, so you don't have to check for the existence of a field before
% referencing it.
%
% Options and defaults may both be of type:
%   * struct
%   * cellrec
% 
out = parseOptsArg(opts);
if nargin > 1
    defaults = parseOptsArg(defaults);
    out = jl.datastruct.copyfields(defaults, out);
end
end

function out = parseOptsArg(opts)
if isempty(opts)
    opts = struct;
end
if isstruct(opts)
    out = opts;
elseif iscell(opts)
    opts = jl.datastruct.cellrec(opts);
    out = jl.datastruct.cellrec2struct(opts);
else
    error('jl:InvalidInput', 'Unsupported input type: %s', class(opts));
end
end