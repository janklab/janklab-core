classdef java
  %JAVA Java-related utilities
  %
  % Note: the methods with "private" in their names are dirty tricks that
  % violate encapsulation and may break things. You probably shouldn't use
  % them.
  
  methods (Static)
    
    function out = classForName(name)
      % Get the java.lang.Class metaclass for a named Java class
      %
      % This does a Java Class.forName, but invokes it from within the dynamic
      % classpath's class loader, so all classes on the dynamic Java
      % classpath are visible.
      % 
      % If you want an inner (nested) class, you need to reference it with
      % "$" notation, not "." notation. E.g.
      % "java.lang.ProcessBuilder$Redirect", not
      % "java.lang.ProcessBuilder.Redirect".
      %
      % Returns a java.lang.Class object.
      out = net.janklab.util.Reflection.classForName(name);
    end
    
    function out = getStaticFieldOnClass(className, fieldName)
      % Get a static field for a class
      %
      % Returns whatever Java value was in that static field.
      %
      % Examples:
      % pipe = jl.util.java.getStaticFieldOnClass('java.lang.ProcessBuilder$Redirect', 'PIPE')
      klass = jl.util.java.classForName(className);
      reflectField = klass.getField(fieldName);
      out = reflectField.get(klass);
    end
    
    function out = getPrivateFieldsCombined(jobj)
      % Get the field contents of a Java object, including private fields
      %
      % THIS IS A HACK. Using it may well break stuff.
      %
      % Example:
      %   jobj = java.util.ArrayList;
      %   s = jl.util.java.getPrivateFieldsCombined(jobj)
      s = jl.util.java.getPrivateFields(jobj);
      out = struct;
      scopes = fieldnames(s);
      for iScope = 1:numel(scopes)
        out = jl.datastruct.copyfields(out, s.(scopes{iScope}));
      end
    end
    
    function out = getPrivateFields(jobj)
      %GETPRIVATEFIELDS Get the field contents of a Java object, including privates
      %
      % THIS IS A HACK. Using it may well break stuff.
      %
      % Example:
      %   jobj = java.util.ArrayList;
      %   s = jl.util.java.getPrivateFields(jobj)
      out.public = struct;
      out.package = struct;
      out.protected = struct;
      out.private = struct;
      klass = jobj.getClass;
      fields = klass.getDeclaredFields;
      for iField = 1:numel(fields)
        field = fields(iField);
        fieldName = char(field.getName);
        safeFieldName = strrep(fieldName, '$', 'DOLLAR_');
        isAccessible = field.isAccessible;
        if ~isAccessible
          field.setAccessible(true);
        end
        value = field.get(jobj);
        if ~isAccessible
          field.setAccessible(false);
        end
        modifiers = field.getModifiers;
        if java.lang.reflect.Modifier.isPrivate(modifiers)
          out.private.(safeFieldName) = value;
        elseif java.lang.reflect.Modifier.isPublic(modifiers)
          out.public.(safeFieldName) = value;
        elseif java.lang.reflect.Modifier.isProtected(modifiers)
          out.protected.(safeFieldName) = value;
        else
          out.package.(safeFieldName) = value;
        end
      end
    end
    
    function dumpFullMethodList(klass)
      %DUMPFULLMETHODLIST Dump the full method list of a class, including privates
      if ischar(klass)
        klass = jl.util.java.classForName(klass);
      end
      methods = klass.getDeclaredMethods;
      for i = 1:numel(methods)
        method = methods(i);
        fprintf('%s\n', char(method.toString));
      end
    end
    
    function out = callPrivateConstructor(klass, args, argTypes)
      %CALLPRIVATECONSTRUCTOR Call a non-accessible constructor
      %
      % THIS IS A HACK. Using it may well break stuff.
      if nargin < 3; argTypes = []; end
      
      if ischar(klass) || isstring(klass)
        klass = jl.util.java.classForName(klass);
      end
      
      % Find the constructor
      if isempty(argTypes) && ~iscell(argTypes)
        % Class must have a single constructor
        ctors = klass.getDeclaredConstructors;
        % TODO: Add disambiguation by argument count
        if numel(ctors) > 1
          error('Class %s declares multiple constructors. Must supply arg types to disambiguate', ...
            klass.getName.toString);
        end
        ctor = ctors(1);
      else
        % Locate constructor by argument types
        ctor = klass.getDeclaredConstructor(argTypeNames2argTypes(argTypes));
      end
      
      % Invoke the constructor
      ctorArgs = boxArgsInJava(args);
      out = ctor.newInstance(ctorArgs);
    end
    
    function out = callPrivateMethod(obj, methodName, args, argTypes)
      %CALLPRIVATEMETHOD Call a non-accessible method on an object
      %
      % THIS IS A HACK. Using it may well break stuff.
      if nargin < 3; args = {}; end
      if nargin < 4; argTypes = {}; end
      if nargout == 0
        jl.util.java.callPrivateMethodOn(obj, [], methodName, args, argTypes);
      else
        out = jl.util.java.callPrivateMethodOn(obj, [], methodName, args, argTypes);
      end
    end
    
    function out = callPrivateMethodOn(obj, objClass, methodName, args, argTypes)
      %CALLPRIVATEMETHODON Call a non-accessible method on an object, by class
      %
      % THIS IS A HACK. Using it may well break stuff.
      if nargin < 4; args = {}; end
      if nargin < 5; argTypes = {}; end
      if isempty(objClass)
        objClass = class(obj);
      end
      
      % Find the method
      argClasses = argTypes2argClasses(args, argTypes);
      klass = jl.util.java.classForName(objClass);
      method = klass.getDeclaredMethod(methodName, argClasses);
      % TODO: Walk up the inheritance list for obj to find superclass methods
      if ~method.isAccessible
        method.setAccessible(true);
      end
      methodArgs = boxArgsInJava(args);
      out = method.invoke(obj, methodArgs);
    end
    
    function out = callStaticMethod(klass, methodName, args, argTypes)
      % Call a static method on a given class
      if nargin < 3; args = {}; end
      if nargin < 4; argTypes = {}; end
      
      if ischar(klass) || isstring(klass)
        klass = jl.util.java.classForName(klass);
      end
      
      % Find the method
      argClasses = argTypes2argClasses(args, argTypes);
      method = klass.getDeclaredMethod(methodName, argClasses);
      methodArgs = boxArgsInJava(args);
      out = method.invoke([], methodArgs);
    end
    
    function out = convertJavaStringsToMatlab(jObj)
      % Convert Java strings or string arrays to Matlab strings
      %
      % Be aware that java.lang.String objects lose their identity in this
      % conversion; only their values are preserved.
      %
      % Returns a string array.
      if isa(jObj, 'java.lang.String')
        out = string(jObj);
      elseif isa(jObj, 'java.lang.String[]')
        out = string(jObj);
      elseif isa(jObj, 'java.lang.Iterable')
        if isa(jObj, 'java.lang.Collection')
          out = repmat(string(missing), [1 jObj.size]);
        else
          out = string.empty;
        end
        it = jObj.iterator;
        i = 0;
        while it.hasNext
          i = i + 1;
          jOb = it.next;
          if isa(jOb, 'java.lang.String')
            out(i) = string(jOb);
          elseif isnumeric(jOb) && isempty(jOb)
            % Leave that element as missing
          elseif ischar(jOb) || isstring(jOb)
            out(i) = jOb;
          else
            error('jl:InvalidInput', ['Element %d of input Iterable was not ' ...
              'a java.lang.String; got a %s'], i, class(jOb));
          end
        end
      else
        error('jl:InvalidInput', "Don't know how to convert a %s to Matlab string array", ...
          class(jObj));
      end
    end
    
    function out = convertMatlabStringsToJava(strs)
      strs = string(strs);
      out = javaArray('java.lang.String', numel(strs));
      for i = 1:numel(strs)
        out(i) = java.lang.String(char(strs(i)));
      end
    end
    
  end
  
  methods (Access = private)
    function this = java()
      % Private constructor to suppress helptext
    end
  end
end

function out = argTypes2argClasses(args, argTypes)
if isempty(argTypes)
  argTypes = cell(size(args));
end
out = javaArray('java.lang.Class', numel(args));
args = boxArgsInJava(args);
for i = 1:numel(out)
  if ~isempty(argTypes{i})
    out(i) = jl.util.java.classForName(argTypes{i});
  else
    className = class(args(i));
    switch className
      case 'logical'
        javaClass = java.lang.Boolean.TYPE;
      otherwise
        javaClass = jl.util.java.classForName(className);
    end
    out(i) = javaClass;
  end
end
end

function out = argTypeNames2argTypes(argTypes)
argTypes = cellstr(argTypes);
out = javaArray('java.lang.Class', numel(argTypes));
for i = 1:numel(argTypes)
  out(i) = jl.util.java.classForName(argTypes{i});
end
end

function out = boxArgsInJava(args)
out = javaArray('java.lang.Object', numel(args));
for i = 1:numel(args)
  if ischar(args{i})
    out(i) = java.lang.String(args{i});
  elseif islogical(args{i})
    if args{i}
      out(i) = java.lang.Boolean.TRUE;
    else
      out(i) = java.lang.Boolean.FALSE;
    end
  else
    out(i) = args{i};
  end
end
end