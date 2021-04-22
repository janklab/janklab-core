function [C, Indx, Jndx, Kndxs] = unique2(A, varargin)
%UNIQUE2 Unique values, plus index lists for groups
%
% [C, Indx, Jndx, Kndxs] = jl.util.unique2(A, varargin)
%
% This is just like Matlab's UNIQUE, except it also returns Kndxs, a
% cell array of the same size as C, where Kndxs{i} returns the
% indexes into A of the values matching C(i). (This is useful, trust me!)

[C, Indx, Jndx] = unique(A, varargin{:});
Kndxs = jl.util.jndx2kndxs(Jndx);

end

