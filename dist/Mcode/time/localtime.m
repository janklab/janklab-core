classdef localtime
    %LOCALTIME A time of day, without a time zone, precise to the millisecond.
    %
    % TODO: Determine if we want this to really be precise to the nanosecond and go with
    % an integer representation, or make it precise to double's eps(0) like datenum is,
    % and get rid of the rounding and quantization. The current data model is a kludgey
    % compromise.
    
    properties (Constant)
        Midnight = localtime(0, 0, 0);
        MillisPerDay = 1000 * 60 * 60 * 24;
    end
    
    properties
        % Number of milliseconds since midnight. Should be integer.
        millis;
    end
    
    methods
        function this = localtime(varargin)
        %LOCALTIME Create a new localtime
        %
        % localtime()
        % localtime(millisOfDay)
        % localtime(H, M, S)
        % localtime(H, M, S, MillisOfSecond)
        if nargin == 0
            this.millis = localtime.currentMillisOfDay;
        elseif nargin == 1
            if isa(varargin{1}, 'double')
                this.millis = varargin{1};
            else
                error('jl:InvalidInput', 'Invalid argument type');
            end
        elseif nargin == 3 || nargin == 4
            h = varargin{1};
            m = varargin{2};
            s = varargin{3};
            if nargin < 4; millisOfSec = 0; end
            mustBeInteger(h);
            mustBeInteger(m);
            mustBeInteger(s);
            mustBeInteger(millisOfSec);
            millis = localtime.hmsmToMillisOfDay(h, m, s, millisOfSec);
            this.millis = millis;
        else
            error('jl:InvalidInput', 'Invalid number of arguments');
        end
        end
        
        function disp(this)
        %DISP Custom display
        if isscalar(this)
            javaLocalTime = this.toJavaLocalTime();
            disp(javaLocalTime.toString());
        else
            dispf('%s %s', size2str(size(this)), class(this));
        end
        end
        
        function out = toJavaLocalTime(this)
        %TOJAVALOCALTIME Convert to Java Time LocalTime
        mustBeScalar(this);
        out = java.time.LocalTime.ofNanoOfDay(uint64(this.millis) * 1000);
        end
    end
    
    methods (Static = true)
        function out = ofMillisOfDay(millis)
        %OFMILLISOFDAY Create localtime from millisecond-of-day value
        if any(millis < 0 | millis > localtime.MillisPerDay)
            error('Value for millis is out of range');
        end
        mustBeInteger(millis);
        out = localtime;
        out.millis = millis;
        end
        
        function out = currentMillisOfDay()
        %CURRENTMILLISOFDAY Current time, as milliseconds of the day
        c = clock;
        out = localtime.hmsmToMillisOfDay(c(4), c(5), c(6));
        end
        
        function out = hmsmToMillisOfDay(h, m, s, millisOfSec)
        %HMSMTOMILLISOFDAY Convert hour/minute/second/millisOfSec to millis of day
        if nargin < 4; millisOfSec = 0; end
        out = (h * 60 * 60 * 1000) + (m * 60 * 1000) ...
            + round(s * 1000) + millisOfSec;
        end
        
        function out = fromJavaLocalTime(jtime)
        %FROMJAVALOCALTIME Convert from Java LocalTime to Janklab localtime
        if isempty(jtime)
            out = localtime.NaT;
        elseif isa(jtime, 'java.time.LocalTime')
            out = localtime.NaT;
            out.millis = round(jtime.toNanoOfDay() / 1000);
        elseif isa(jtime, 'java.time.LocalTime[]')
            out = repmat(localtime, size(jtime));
            for i = 1:numel(jtime)
                out_i = localtime.fromJavaLocalTime(jtime(i));
                out.millis(i) = out_i.millis;
            end
        else
            error('Invalid input type: %s', class(jtime));
        end
        end
        
		function out = NaT(sz)
		%NAT Create Not-a-Time localtimes
		if nargin < 1; sz = [1 1]; end
		out = localtime(NaN(sz));
		end
		
        
    end
    
    
    methods
        % Structural planar-organization methods
        
        function varargout = size(this, varargin)
        %SIZE Size of array
        varargout = cell(1, max(1, nargout));
        [varargout{:}] = size(this.millis, varargin{:});
        end
        
        function out = numel(this)
        %NUMEL Number of elements in array
        out = numel(this.millis);
        end
        
        function out = ndims(this)
        %NDIMS Number of dimensions
        out = ndims(this.millis);
        end
        
        function out = isempty(this)
        %ISEMPTY True for empty array
        out = isempty(this.millis);
        end
        
        function out = isscalar(this)
        %ISSCALAR True if input is scalar
        out = isscalar(this.millis);
        end
        
        function out = isvector(this)
        %ISVECTOR True if input is a vector
        out = isvector(this.millis);
        end
        
        function out = iscolumn(this)
        %ISCOLUMN True if input is a column vector
        out = iscolumn(this.millis);
        end
        
        function out = isrow(this)
        %ISROW True if input is a row vector
        out = isrow(this.millis);
        end
        
        function out = ismatrix(this)
        %ISMATRIX True if input is a matrix
        out = ismatrix(this.millis);
        end
        
        function this = reshape(this, varargin)
        %RESHAPE Reshape array
        this.millis = reshape(this.millis, varargin{:});
        end
        
        function this = squeeze(this)
        %SQUEEZE Remove singleton dimensions
        this.millis = squeeze(this.millis);
        end
        
        function [this, nshifts] = shiftdim(this, n)
        %SHIFTDIM Shift dimensions
        if nargin > 1
            [this.millis, nshifts] = shiftdim(this.millis, n);
        else
            this.millis = shiftdim(this.millis);
        end
        end
        
        function this = circshift(this, varargin)
        %CIRCSHIFT Shift positions of elements circularly
        this.millis = circshift(this.millis, varargin{:});
        end
        
        function this = permute(this, order)
        %PERMUTE Permute array dimensions
        this.millis = permute(this.millis, order);
        end
        
        function this = ipermute(this, order)
        %IPERMUTE Inverse permute array dimensions
        this.millis = ipermute(this.millis, order);
        end
        
        function this = repmat(this, varargin)
        %REPMAT Replicate and tile array
        this.millis = repmat(this.millis, varargin{:});
        end
        
        function this = subsasgn(this, s, b)
        %SUBSASGN Subscripted assignment
        
        % Chained subscripts
        if numel(s) > 1
            rhs_in = subsref(this, s(1));
            rhs = subsasgn(rhs_in, s(2:end), b);
        else
            rhs = b;
        end
        
        % Base case
        switch s(1).type
            case '()'
                if ~isa(rhs, class(this))
                    error('jl:TypeMismatch', 'Cannot assign %s in to a %s',...
                        class(rhs), class(this));
                end
                if ~isequal(class(rhs), class(this))
                    error('jl:TypeMismatch', 'Cannot assign a subclass in to a %s (got a %s)',...
                        class(this), class(rhs));
                end
                this.millis(s(1).subs{:}) = rhs.date;
            case '{}'
                error('jl:BadOperation',...
                    '{}-subscripting is not supported for class %s', class(this));
            case '.'
                this.(s(1).subs) = rhs;
        end
        end
        
        function out = subsref(this, s)
        %SUBSREF Subscripted reference
        
        % Base case
        switch s(1).type
            case '()'
                out = this;
                out.date = this.millis(s(1).subs{:});
            case '{}'
                error('jl:bad_operation',...
                    '{}-subscripting is not supported for class %s', class(this));
            case '.'
                out = this.(s(1).subs);
        end
        
        % Chained reference
        if numel(s) > 1
            out = subsref(out, s(2:end));
        end
        end
        
        function out = eq(a, b)
        %EQ Equality comparison
        [ap, bp] = localtime.getCmpProxies(a, b);
        out = eq(ap, bp);
        end
        
        function out = ne(a, b)
        %NE Not equal
        [ap, bp] = localtime.getCmpProxies(a, b);
        out = ne(ap, bp);
        end
        
        function out = lt(a, b)
        %LT Less than
        [ap, bp] = localtime.getCmpProxies(a, b);
        out = lt(ap, bp);
        end
        
        function out = le(a, b)
        %LE Less than or equal
        [ap, bp] = localtime.getCmpProxies(a, b);
        out = le(ap, bp);
        end
        
        function out = gt(a, b)
        %GT Greater than
        [ap, bp] = localtime.getCmpProxies(a, b);
        out = gt(ap, bp);
        end
        
        function out = ge(a, b)
        %GE Greater than or equal
        [ap, bp] = localtime.getCmpProxies(a, b);
        out = ge(ap, bp);
        end
        
        function out = cmp(a, b)
        %CMP Compare for ordering
        [ap, bp] = localtime.getCmpProxies(a, b);
        out = sign(ap - bp);
        end
        
        function out = isequal(varargin)
        %ISEQUAL True if localtime arrays are equal
        proxies = localtime.getEqProxies(varargin{:});
        out = isequal(proxies{:});
        end
        
        function out = isequaln(varargin)
        %ISEQUAL True if localtime arrays are equal, treating NaT elements as equal
        proxies = localtime.getEqProxies(varargin{:});
        out = isequaln(proxies{:});
        end
    end
    
end