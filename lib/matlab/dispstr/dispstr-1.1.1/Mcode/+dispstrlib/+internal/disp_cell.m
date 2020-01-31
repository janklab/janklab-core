function disp_cell(x)

if ~iscell(x)
  error('input must be a cell; got a %s', class(x));
end

for i = 1:numel(x)
  if isobject(x{i})
    if isa(x{i}, 'datetime') || isa(x{i}, 'duration') || isa(x{i}, 'calendarduration')
      % NOP
    else
      x{i} = dispstr(x{i});
    end
  end
end

disp(x);
