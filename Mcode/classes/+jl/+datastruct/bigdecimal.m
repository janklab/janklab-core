classdef bigdecimal
    %BIGDECIMAL Arbitrary-precision decimal values
    %
    % Bigdecimal represents arbitrary-precision exact decimal values. (As
    % opposed to the approximate binary types double and float.)
    %
    % Bigdecimal is *slow*. It is much slower than doubles. Only use it if you
    % really need it. Its major purpose is to be a dumb holder for
    % arbitrary-precision decimal values, not to do much arithmetic or
    % number-crunching on them.
    %
    % The implementation is a wrapper around java.math.BigDecimal.
    
    properties (Constant = true)
        % The value 0, with a scale of 0
        ZERO = jl.types.BigDecimal(java.math.BigDecimal.ZERO);
        % The value 1, with a scale of 0
        ONE = jl.types.BigDecimal(java.math.BigDecimal.ONE);
        % The value 10, with a scale of 0
        TEN = jl.types.BigDecimal(java.math.BigDecimal.TEN);
    end
    
    properties
        % The underlying java.math.BigDecimal value
        jval = java.math.BigDecimal.ZERO;
    end
    
    methods
        function this = BigDecimal(x)
        %BIGDECIMAL Construct a new BigDecimal
        %
        % jl.types.BigDecimal(x)
        % jl.types.BigDecimal(javaBigDecimal)
        %
        % X may be one of:
        %   * double
        %   * a signed or unsigned integer type
        %   * char, string, or cellstr
        %
        % For more advanced construction options, construct a
        % java.math.BigDecimal object directly, and pass it in to the
        % jl.types.BigDecimal constructor to wrap it.
        %
        % The zero-arg constructor returns a BigDecimal of value 0, with a scale
        % of 0. This may change if NaN support is added to BigDecimal.
        import java.math.BigDecimal
        if nargin == 0
            return;
        end
        if isa(x, 'jl.types.BigDecimal')
            this = x;
            return;
        end
        if isa(x, 'java.math.BigDecimal')
            this.jval = x;
        elseif isa(x, 'java.math.BigDecimal[]')
            this = repmat(this, size(x));
            for i = 1:numel(x)
                this(i).jval = x(i);
            end
        elseif isa(x, 'double')
            mustBeReal(x);
            this = repmat(this, size(x));
            for i = 1:numel(x)
                this(i).jval = BigDecimal(x(i));
            end
        elseif ischar(x) || isstring(x) || iscellstr(x)
            x = string(x);
            this = repmat(this, size(x));
            for i = 1:numel(x)
                this(i).jval = BigDecimal(x(i));
            end
        elseif isinteger(x)
            this = repmat(this, size(x));
            if ismember(class(x), {'uint64'})
                % Types requiring munging because Java doesn't have unsigned
                % types
                for i = 1:numel(x)
                    if x(i) > intmax('int64')
                        str = sprintf('%d', x(i));
                        this(i).jval = BigDecimal(str);
                    else
                        this(i).jval = BigDecimal(x(i));
                    end
                end
            else
                for i = 1:numel(x)
                    this(i).jval = BigDecimal(x(i));
                end
            end
        else
            error('jl:InvalidInput', 'Invalid input type: %s', class(x));
        end
        end
        
        function this = set.jval(this, x)
        mustBeA(x, 'java.math.BigDecimal');
        this.jval = x;
        end
        
        function disp(this)
        %DISP Custom display
        if isscalar(this)
            out = this.jval.toString();
        else
            out = sprintf('%s %s', size2str(size(this)), class(this));
        end
        disp(out);
        end
        
        function out = dispstrs(this)
        %DISPSTRS Custom display strings
        out = cell(size(this));
        for i = 1:numel(this)
            out{i} = char(this(i).jval.toString());
        end
        end
        
        %% Conversions
        
        function out = double(this)
        out = NaN(size(this));
        for i = 1:numel(out)
            out(i) = this(i).jval.doubleValue();
        end
        end
        
        function out = toEngineeringString(this)
        out = cell(size(this));
        for i = 1:numel(out)
            out{i} = char(this(i).jval.toEngineeringString());
        end
        end
        
        function out = toPlainString(this)
        out = cell(size(this));
        for i = 1:numel(out)
            out{i} = char(this(i).jval.toPlainString());
        end
        end
        
        
        %% Arithmetic
        
        function out = abs(this)
        out = this;
        for i = 1:numel(out)
            out(i).jval = this(i).jval.abs();
        end
        end
        
        function out = plus(A, B)
        A = jl.types.BigDecimal(A);
        B = jl.types.BigDecimal(B);
        [A, B] = scalarexpand(A, B);
        out = A;
        for i = 1:numel(out)
            out(i).jval = A(i).jval.add(B(i).jval);
        end
        end
        
        function out = uplus(this)
        out = this;
        end
        
        function out = compareTo(A, B)
        A = jl.types.BigDecimal(A);
        B = jl.types.BigDecimal(B);
        [A, B] = scalarexpand(A, B);
        out = NaN(size(a));
        for i = 1:numel(out)
            out(i) = A(i).jval.compareTo(B(i).jval);
        end
        end
        
        function out = rdivide(A, B)
        A = jl.types.BigDecimal(A);
        B = jl.types.BigDecimal(B);
        [A, B] = scalarexpand(A, B);
        out = A;
        for i = 1:numel(out)
            out(i).jval = A(i).jval.divide(B(i).jval);
        end
        end
        
        function out = eq(A, B)
        A = jl.types.BigDecimal(A);
        B = jl.types.BigDecimal(B);
        [A, B] = scalarexpand(A, B);
        out = true(size(A));
        for i = 1:numel(out)
            out(i) = A(i).jval.compareTo(B(i).jval) == 0;
        end
        end
        
        function out = equals(A, B)
        A = jl.types.BigDecimal(A);
        B = jl.types.BigDecimal(B);
        [A, B] = scalarexpand(A, B);
        out = true(size(A));
        for i = 1:numel(out)
            out(i) = A(i).jval.equals(B(i).jval);
        end
        end
        
        function out = max(A, B)
        A = jl.types.BigDecimal(A);
        B = jl.types.BigDecimal(B);
        [A, B] = scalarexpand(A, B);
        out = A;
        for i = 1:numel(out)
            out(i).jval = A(i).jval.max(B(i).jval);
        end
        end
        
        function out = min(A, B)
        A = jl.types.BigDecimal(A);
        B = jl.types.BigDecimal(B);
        [A, B] = scalarexpand(A, B);
        out = A;
        for i = 1:numel(out)
            out(i).jval = A(i).jval.min(B(i).jval);
        end
        end
        
        function out = movePointLeft(this, n)
        [this, n] = scalarexpand(this, n);
        out = this;
        for i = 1:numel(out)
            out(i).jval = this(i).jval.movePointLeft(n(i));
        end
        end
        
        function out = movePointRight(this, n)
        [this, n] = scalarexpand(this, n);
        out = this;
        for i = 1:numel(out)
            out(i).jval = this(i).jval.movePointRight(n(i));
        end
        end
        
        function out = times(A, B)
        A = jl.types.BigDecimal(A);
        B = jl.types.BigDecimal(B);
        [A, B] = scalarexpand(A, B);
        out = A;
        for i = 1:numel(out)
            out(i).jval = A(i).jval.multiply(B(i).jval);
        end
        end
        
        function out = uminus(this)
        out = this;
        for i = 1:numel(out)
            out(i).jval = this(i).jval.negate();
        end
        end
        
        function out = power(this, n)
        this = jl.types.BigDecimal(this);
        [this, n] = scalarexpand(this, n);
        out = this;
        for i = 1:numel(out)
            out(i).jval = this(i).jval.pow(n(i));
        end
        end
        
        function out = precision(this)
        out = NaN(size(this));
        for i = 1:numel(out)
            out(i) = this(i).jval.precision();
        end
        end
        
        function out = scale(this)
        out = NaN(size(this));
        for i = 1:numel(out)
            out(i) = this(i).jval.scale();
        end
        end
        
        function out = signum(this)
        out = NaN(size(this));
        for i = 1:numel(out)
            out(i) = this(i).jval.signum();
        end
        end
        
        function out = rem(A, B)
        A = jl.types.BigDecimal(A);
        B = jl.types.BigDecimal(B);
        [A, B] = scalarexpand(A, B);
        out = A;
        for i = 1:numel(out)
            out(i).jval = A(i).jval.remainder(B(i).jval);
        end
        end
        
        function out = scaleByPowerOfTen(this, n)
        this = jl.types.BigDecimal(this);
        [this, n] = scalarexpand(this, n);
        out = this;
        for i = 1:numel(out)
            out(i).jval = this(i).jval.scaleByPowerOfTen(n(i));
        end
        end
        
        function out = setScale(this, n)
        this = jl.types.BigDecimal(this);
        [this, n] = scalarexpand(this, n);
        out = this;
        for i = 1:numel(out)
            out(i).jval = this(i).jval.setScale(n(i));
        end
        end
        
        function out = stripTrailingZeros(this)
        out = this;
        for i = 1:numel(out)
            out(i).jval = this(i).jval.stripTrailingZeros();
        end
        end
        
        function out = minus(A, B)
        A = jl.types.BigDecimal(A);
        B = jl.types.BigDecimal(B);
        [A, B] = scalarexpand(A, B);
        out = A;
        for i = 1:numel(out)
            out(i).jval = A(i).jval.subtract(B(i).jval);
        end
        end
        
        function out = ulp(this)
        out = this;
        for i = 1:numel(out)
            out(i).jval = this(i).jval.ulp();
        end
        end
        
    end
    
    methods (Static = true)
        function out = ofValueAndScale(unscaledVal, scale)
        unscaledVal = int64(unscaledVal);
        [unscaledVal, scale] = scalarexpand(unscaledVal, scale);
        out = repmat(jl.types.BigDecimal, size(unscaledVal));
        for i = 1:numel(out)
            out(i).jval = java.math.BigDecimal.valueOf(unscaledVal(i), scale(i));
        end
        end
    end
end