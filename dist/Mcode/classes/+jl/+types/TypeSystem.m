classdef TypeSystem
    %TYPESYSTEM Extended type system support
    %
    % This class has Janklab's support for an "extended" type system which
    % includes a notion of "pseudotypes" in addition to the normal Matlab
    % classes. A pseudotype is not an actual class, but is a value of a
    % different type that meets additional criteria, or is a set of other
    % types.
    
    properties (Constant = true)
        % { name, testFcn; ... }
        pseudotypeTable = {
            'none'          @false
            'any'           @true
            'object'        @isobject
            'primitive'     @jl.types.tests.isPrimitive
            'numeric'       @isnumeric
            'int'           @jl.types.tests.isIntType
            'uint'          @jl.types.tests.isUintType
            'sint'          @jl.types.tests.isSintType
            'cellstr'       @iscellstr
            'cellrec'       @jl.types.tests.isCellrec
            }
        pseudotypeMap = cell2struct(jl.types.TypeSystem.pseudotypeTable(:,2),...
            jl.types.TypeSystem.pseudotypeTable(:,1), 1)
    end
    
    methods (Static = true)
        function out = isa2(value, type)
            %ISA2 Type test that supports pseudotypes
            %
            % out = jl.types.TypeSystem.isa2(value, type)
            %
            % Tests whether the given value is of a particular type. Type
            % may be a normal Matlab class name, or one of the pseudotypes
            % defined by Janklab.
            
            % Test for pseudotypes
            if isfield(jl.types.TypeSystem.pseudotypeMap, type)
                testFcn = jl.types.TypeSystem.pseudotypeMap.(type);
                out = feval(testFcn, value);
            else
                out = isa(value, type);
            end
            
        end
    end
    
    methods (Access = private)
        function obj = TypeSystem
        end
    end
end


