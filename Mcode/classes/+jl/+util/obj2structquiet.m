function out = obj2structquiet(obj)
% obj2structquiet Convert an object to a struct with no warning
%
% out = obj2structquiet(obj)
%
% Converts obj to a struct, using struct(obj), but suppressing the
% MATLAB:structOnObject warning that usually happens.
%
% Returns a struct.

origWarn = warning;
RAII.warning = onCleanup(@() warning(origWarn));
warning off MATLAB:structOnObject
out = struct(obj);
