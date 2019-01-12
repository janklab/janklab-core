function out = isoctave
%ISOCTAVE True if this is running on Octave instead of Matlab

persistent value
if isempty(value)
  % Detect Matlab vs Octave
  v = ver;
  ver_names = {v.Name};
  value = ismember('Octave', ver_names);
end

out = value;

end