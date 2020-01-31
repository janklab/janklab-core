function disp_struct(x)

s = x;

if ~isscalar(s)
  disp(s);
  return
end

flds = fieldnames(s);
for i = 1:numel(flds)
  val = s.(flds{i});
  if isobject(val)
    if isa(val, 'datetime') || isa(val, 'duration') || isa(val, 'calendarduration')
      % NOP
    else
      s.(flds{i}) = dispstr(val);
    end
  end
end

disp(s);
