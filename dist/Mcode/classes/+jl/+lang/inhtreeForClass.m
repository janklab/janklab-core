function inhtreeForClass(className)
  %INHTREEFORCLASS Display inverse inheritance tree for named class
  %
  % See also:
  % INHTREE
  
  % Matlab classes take precedence
  klass = meta.class.fromName(className);
  if ~isempty(klass)
    inhtreeForClass_matlab(klass);
    return
  end
  % Next try Java classes
  klass = [];
  try
    klass = java.lang.Class.forName(className);
  catch
    % quash
  end
  if ~isempty(klass)
    inhtreeForClass_java(klass);
    return
  end
  
  error('Could not resolve class: %s', className);
  
end

function inhtreeForClass_matlab(klass)
  inhtreeForClass_matlab_step(klass, '');
end

function inhtreeForClass_matlab_step(klass, prefix)
  fprintf('%s%s\n', prefix, klass.Name);
  supers = klass.SuperclassList;
  for i = 1:numel(supers)
    inhtreeForClass_matlab_step(supers(i), ['  ' prefix]);
  end
end

function inhtreeForClass_java(klass)
  inhtreeForClass_java_step(klass, '');
end

function inhtreeForClass_java_step(klass, prefix)
  if klass.isInterface()
    descr = [ '[' char(klass.getName()) ']' ];
  else
    descr = char(klass.getName());
  end
  fprintf('%s%s\n', prefix, descr);
  interfaces = klass.getInterfaces();
  for i = 1:numel(interfaces)
    interface = interfaces(i);
    %fprintf('%s  [%s]\n', prefix, interface.getName());
    inhtreeForClass_java_step(interface, ['  ' prefix]);
  end
  super = klass.getSuperclass();
  if ~isempty(super)
    inhtreeForClass_java_step(super, ['  ' prefix]);
  end
end