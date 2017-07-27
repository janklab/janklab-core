classdef localtime
    %LOCALTIME A time of day, without a time zone.
    %
    % A localtime is a local (wall) time of day, zoneless. It is represented as
    % a double indicating the fractional amount of a day that has passed, like
    % the time part of a datenum or datetime. This representation is chosen to fit
    % nicely with Matlab's datenum and datetime, and because it has precision finer
    % than a nanosecond.
    %
    % See also:
    % localdate, jl.time.duration, datetime
    
    properties (Constant)
        % localtime representing midnight (the start of the day)
        Midnight = jl.time.localtime(0, 0, 0);
    end

    properties (Constant, Access = private)
        % Number of milliseconds per day
        MillisPerDay = 24 * 60 * 60 * 1000;
        NanosPerDay = 24 * 60 * 60 * 1000000000;
    end
    
    properties
        % Fractional amount of day that has passed
        time double {mustBeValidTimeValue} = NaN;
    end
    
    methods
        function this = localtime(varargin)
        %LOCALTIME Create a new localtime.
        %
        % jl.time.localtime()
        % jl.time.localtime(timeOfDay)
        % jl.time.localtime(H, M, S)
        % jl.time.localtime(H, M, S, timeOfSecond)
        if nargin == 0
            this.time = jl.time.localtime.currenttimeOfDay;
        elseif nargin == 1
            if isa(varargin{1}, 'double')
                this.time = varargin{1};
            elseif isa(varargin{1}, 'jl.time.localtime')
                this = varargin{1};
            else
                error('jl:InvalidInput', 'Invalid argument type');
            end
        elseif nargin == 3 || nargin == 4
            h = varargin{1};
            m = varargin{2};
            s = varargin{3};
            if nargin < 4
                timeOfSec = 0;
            end
            mustBeInteger(h);
            mustBeInteger(m);
            mustBeInteger(s);
            time = jl.time.localtime.hmsmTotimeOfDay(h, m, s, timeOfSec);
            this.time = time;
        else
            error('jl:InvalidInput', 'Invalid number of arguments');
        end
        end
        
        function disp(this)
        %DISP Custom display.
        if ~isscalar(this)
            dispf('%s %s', size2str(size(this)), class(this));
            return
        end
        javaLocalTime = this.toJavaLocalTime();
        disp(javaLocalTime.toString());
        end
        
        function out = toJavaLocalTime(this)
        %TOJAVALOCALTIME Convert to Java-Time LocalTime.
        %
        % Converts this to a Java-Time LocalTime object, rounding to the nearest
        % nanosecond.
        mustBeScalar(this);
        nanos = round(this.time * jl.time.localtime.NanosPerDay);
        out = java.time.LocalTime.ofNanoOfDay(uint64(nanos));
        end
        
        function out = eps(this)
        %EPS Precision of time representation at this value.
        out = jl.time.duration(eps(this.time));
        end
        
        function out = minus(A, B)
        %MINUS Difference between two localtimes.
        %
        % A - B
        %
        % Takes the difference between two localtimes.
        %
        % Returns a jl.time.duration.
        A = jl.time.localtime(A);
        B = jl.time.localtime(B);
        out = jl.time.duration(A.time - B.time);
        end
        
        function out = plus(A, B)
        %PLUS Add a duration to a localtime.
        %
        % A + B
        %
        % A is converted to a localtime, and B is converted to a duration. If the
        % result is greater than 1 day, it is an error.
        A = jl.time.localtime(A);
        B = jl.time.duration(B);
        out = jl.time.localtime(A.time + B.time);
        end
        
    end
    
    methods (Static = true)
        function out = oftimeOfDay(time)
        %OFtimeOFDAY Create localtime from timeecond-of-day value
        if any(time < 0 | time > localtime.timePerDay)
            error('Value for time is out of range');
        end
        out = jl.time.localtime;
        out.time = time;
        end
        
        function out = currenttimeOfDay()
        %CURRENTtimeOFDAY Current time, as timeeconds of the day
        c = clock;
        out = jl.time.localtime.hmsmTotimeOfDay(c(4), c(5), c(6));
        end
        
        function out = hmsmTotimeOfDay(h, m, s, timeOfSec)
        %HMSMTOtimeOFDAY Convert hour/minute/second/timeOfSec to time of day
        if nargin < 4; timeOfSec = 0; end
        nanos = (h * 60 * 60 * 1000000000) + (m * 60 * 1000000000) ...
            + round((s + timeOfSec) * 1000000000);
        out = nanos ./ jl.time.localtime.NanosPerDay;
        end
        
        function out = fromJavaLocalTime(jtime)
        %FROMJAVALOCALTIME Convert from Java-Time LocalTime to Janklab localtime
        if isempty(jtime)
            out = jl.time.localtime.NaT;
        elseif isa(jtime, 'java.time.LocalTime')
            out = jl.time.localtime.NaT;
            out.time = jtime.toNanoOfDay() / jl.time.localtime.NanosPerDay;
        elseif isa(jtime, 'java.time.LocalTime[]')
            out = repmat(localtime, size(jtime));
            for i = 1:numel(jtime)
                out_i = jl.time.localtime.fromJavaLocalTime(jtime(i));
                out.time(i) = out_i.time;
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
        
        function out = NaN(sz)
        %NAN Alias for NaT
        out = jl.time.NaT(sz);
        end
        
        function out = now()
        %NOW Current time of day in the local time zone
        out = jl.time.localtime(rem(now, 1));
        end
        		
    end
    
    methods
        function out = isnat(this)
        %ISNAT True if value is Not-A-Time.
        out = isnan(this);
        end
        
        function out = isnan(this)
        %ISNAN Alias for ISNAT.
        out = isnan(this.time);
        end
        
        % Structural planar-organization methods
        
        function varargout = size(this, varargin)
        %SIZE Size of array.
        varargout = cell(1, max(1, nargout));
        [varargout{:}] = size(this.time, varargin{:});
        end
        
        function out = numel(this)
        %NUMEL Number of elements in array.
        out = numel(this.time);
        end
        
        function out = ndims(this)
        %NDIMS Number of dimensions.
        out = ndims(this.time);
        end
        
        function out = isempty(this)
        %ISEMPTY True for empty array.
        out = isempty(this.time);
        end
        
        function out = isscalar(this)
        %ISSCALAR True if input is scalar.
        out = isscalar(this.time);
        end
        
        function out = isvector(this)
        %ISVECTOR True if input is a vector.
        out = isvector(this.time);
        end
        
        function out = iscolumn(this)
        %ISCOLUMN True if input is a column vector.
        out = iscolumn(this.time);
        end
        
        function out = isrow(this)
        %ISROW True if input is a row vector.
        out = isrow(this.time);
        end
        
        function out = ismatrix(this)
        %ISMATRIX True if input is a matrix.
        out = ismatrix(this.time);
        end
        
        function this = reshape(this, varargin)
        %RESHAPE Reshape array.
        this.time = reshape(this.time, varargin{:});
        end
        
        function this = squeeze(this)
        %SQUEEZE Remove singleton dimensions.
        this.time = squeeze(this.time);
        end
        
        function [this, nshifts] = shiftdim(this, n)
        %SHIFTDIM Shift dimensions.
        if nargin > 1
            [this.time, nshifts] = shiftdim(this.time, n);
        else
            this.time = shiftdim(this.time);
        end
        end
        
        function this = circshift(this, varargin)
        %CIRCSHIFT Shift positions of elements circularly.
        this.time = circshift(this.time, varargin{:});
        end
        
        function this = permute(this, order)
        %PERMUTE Permute array dimensions.
        this.time = permute(this.time, order);
        end
        
        function this = ipermute(this, order)
        %IPERMUTE Inverse permute array dimensions.
        this.time = ipermute(this.time, order);
        end
        
        function this = repmat(this, varargin)
        %REPMAT Replicate and tile array.
        this.time = repmat(this.time, varargin{:});
        end
        
        function this = subsasgn(this, s, b)
        %SUBSASGN Subscripted assignment.
        
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
                    error('jl:TypeMismatch', ...
                        'Cannot assign a subclass in to a %s (got a %s)',...
                        class(this), class(rhs));
                end
                this.time(s(1).subs{:}) = rhs.date;
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
                out.date = this.time(s(1).subs{:});
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
        %EQ Equality comparison.
        [ap, bp] = jl.time.localtime.getCmpProxies(a, b);
        out = eq(ap, bp);
        end
        
        function out = ne(a, b)
        %NE Not equal.
        [ap, bp] = jl.time.localtime.getCmpProxies(a, b);
        out = ne(ap, bp);
        end
        
        function out = lt(a, b)
        %LT Less than.
        [ap, bp] = jl.time.localtime.getCmpProxies(a, b);
        out = lt(ap, bp);
        end
        
        function out = le(a, b)
        %LE Less than or equal.
        [ap, bp] = jl.time.localtime.getCmpProxies(a, b);
        out = le(ap, bp);
        end
        
        function out = gt(a, b)
        %GT Greater than
        [ap, bp] = jl.time.localtime.getCmpProxies(a, b);
        out = gt(ap, bp);
        end
        
        function out = ge(a, b)
        %GE Greater than or equal.
        [ap, bp] = jl.time.localtime.getCmpProxies(a, b);
        out = ge(ap, bp);
        end
        
        function out = cmp(a, b)
        %CMP Compare for ordering.
        [ap, bp] = jl.time.localtime.getCmpProxies(a, b);
        out = sign(ap - bp);
        end
        
        function out = isequal(varargin)
        %ISEQUAL True if localtime arrays are equal.
        proxies = jl.time.localtime.getEqProxies(varargin{:});
        out = isequal(proxies{:});
        end
        
        function out = isequaln(varargin)
        %ISEQUAL True if localtime arrays are equal, treating NaT elements as equal.
        proxies = jl.time.localtime.getEqProxies(varargin{:});
        out = isequaln(proxies{:});
        end
    end
    
	methods (Static = true, Access = 'private')
		function varargout = getCmpProxies(varargin)
		%GETCMPPROXIES Get proxy values for use in relational comparisons
		varargout = cell(size(varargin));
		for i = 1:numel(varargin)
			x = varargin{i};
			if isa(x, 'jl.time.localtime')
				y = x.time;
			elseif isnumeric(x)
				y = x;
			else
				error('jl:InvalidInput', 'Cannot compare a %s to a jl.time.localtime',...
					class(x));
			end
			varargout{i} = y;
		end
		end
		
		function varargout = getEqProxies(varargin)
		%GETEQPROXIES Get proxy values for use in ISEQUAL
		varargout = cell(size(varargin));
		for i = 1:numel(varargin)
			x = varargin{i};
			if isa(x, 'jl.time.localtime')
				varargout{i} = x.time;
			else
				error('jl:InvalidLocalDateEqType', ...
                    'Cannot compare a %s to a jl.time.localtime',...
					class(x));
			end
		end
		end
		
    end
    
end

function mustBeValidTimeValue(x)
tfValid = isnan(x) | (x >= 0 & x < 1.0);
if ~all(tfValid)
    error('Invalid time values: %s', ...
        strjoin(jl.util.num2cellstr(x(~tfValid)), ', '));
end
end
