classdef java
    % Java-related utilities
   
    methods (Static)
        function out = classForName(name)
        % Get the java.lang.Class metaclass for a named Java class
        %
        % This does a Java Class.forName, but invokes it from within the dynamic
        % classpath's class loader, so all classes on the dynamic Java 
        % classpath are visible.
        out = net.janklab.util.Reflection.classForName(name);
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
            out = jl.types.copyfields(out, s.(scopes{iScope}));
        end
        end
        
        function out = getPrivateFields(jobj)
        % Get the field contents of a Java object, including private fields
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
            if nargin < 2; argTypes = []; end
            
            if ischar(klass)
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
            ctorArgs = wrapArgs(args);
            out = ctor.newInstance(ctorArgs);
        end
    end
    
    
    methods (Access = private)
        function this = java()
        % Private constructor to suppress helptext
        end
    end
end

function out = argTypeNames2argTypes(names)
names = cellstr(names);
out = javaArray('java.lang.Class', numel(names));
for i = 1:numel(names)
    out(i) = jl.util.java.classForName(names{i});
end
end

function out = wrapArgs(args)
out = javaArray('java.lang.Object', numel(args));
for i = 1:numel(args)
    if ischar(args{i})
        args{i} = java.lang.String(args{i});
    end
    out(i) = args{i};
end
end