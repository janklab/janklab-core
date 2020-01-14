classdef ParamConversionSelector < handle
    
    properties
        fallback jl.sql.ParamConversionSelector
        byParameterIndex cell = {}
        byTypeMappings cell = cell(0,2)
    end
    
    methods
        function this = ParamConversionSelector(fallback)
        % Construct a new ParamConversionSelector
        if nargin == 0
            return;
        end
        this.fallback = fallback;
        end
        
        function out = selectConversion(this, parameterIndex, parameterValue)
        %SELECTCONVERSION Select the conversion to be used for a parameter
        
        out = [];
        if numel(this.byParameterIndex) >= parameterIndex && ...
                ~isempty(this.byParameterIndex{parameterIndex})
            out = this.byParameterIndex{parameterIndex};
            return;
        end
        
        for i = 1:size(this.byTypeMappings, 1)
            [inputType,conversion] = this.byTypeMappings{i,:};
            if isa2(parameterValue, inputType)
                out = conversion;
                return;
            end
        end
        
        if ~isempty(this.fallback)
            out = selectConversion(this.fallback, parameterIndex, parameterValue);
        end
        
        if isempty(out)
            error('No conversion found for param %d (%s)', ...
                parameterIndex, class(parameterValue));
        end
        end
        
        function this = registerByType(this, conversions)
        mustBeCellstr(conversions);
        if size(conversions, 2) ~= 2 || ~ismatrix(conversions)
            error('jl:InvalidInput', 'conversions must be an n-by-2 cellstr; got %s', ...
                sizestr(conversions));
        end
        this.byTypeMappings = [this.byTypeMappings; conversions];
        end
    end
end