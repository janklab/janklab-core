classdef localtime
    %LOCALTIME A time of day, without a time zone.
    %
    % A localtime is a local (wall) time of day, without a time zone. It is precise to
    % the nanosecond.
    %
    % The range is from 00:00:00 to 24:00:00. 24:00:00 is not necessarily
    % well-defined, but it is included for compatibility with other systems
    % which have that value.
    %
    % The localtime is internally represented as a double indicating the the
    % number of nanoseconds within the day. This representation is chosen
    % because it has greater than nanosecond precision, which compares well with LocalTimes
    % in other languages (like Java and SQL), and because it can represent NaNs
    % (unlike int64).
    %
    % See also:
    % jl.time.localdate, jl.time.duration, datetime
    
    properties (Constant)
        % A localtime representing midnight (the start of the day)
        Midnight = jl.time.localtime(0, 0, 0);
        % A localtime representing noon (12:00:00)
        Noon = jl.time.localtime(12, 0, 0);
    end
    
    properties (Constant, Access = private)
        % Number of milliseconds per day
        MillisPerDay = 24 * 60 * 60 * 10^3;
        % Number of nanoseconds per day
        NanosPerDay = 24 * 60 * 60 * 10^9;
    end
    
    properties
        % Time of day, as nanoseconds since midnight
        time double = NaN;
    end
    
    methods
        function this = localtime(varargin)
        %LOCALTIME Create a new localtime.
        %
        % jl.time.localtime()
        % jl.time.localtime(timeOfDay)
        % jl.time.localtime(H, M, S)
        % jl.time.localtime(H, M, S, timeOfSecond)
        %
        % The zero-arg constructor produces NaT. Use jl.time.localtime.now() to
        % get the current time of day.
        %
        % TimeOfDay (double) is the fractional time of day. It is a value
        % between 0.0 (inclusive) and 1.0 (exclusive).
        %
        % Time of second, if provided, is a fractional number of seconds.
        % For example, timeOfSecond = 0.5 indicates 500 milliseconds.
        %
        % If timeOfSecond is greater than or equal to 1.0, it carries over into
        % the seconds value. This may be a design flaw, and changed in the
        % future to require timeOfSecond to be <= 1.0.
        if nargin == 0
            return;
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
            else
                timeOfSec = varargin{4};
            end
            mustBeInteger(h);
            mustBeInteger(m);
            mustBeInteger(s);
            time = jl.time.localtime.hmsmToNanosOfDay(h, m, s, timeOfSec);
            this.time = time;
        else
            error('jl:InvalidInput', 'Invalid number of arguments');
        end
        end
        
        function this = set.time(this, newValue)
        mustBeValidNanosOfDayValue(newValue);
        this.time = newValue;
        end
        
        function out = getNanosOfDay(this)
        out = this.time;
        end
        
        function disp(this)
        %DISP Custom display.
        disp(dispstr(this));
        end
        
        function out = dispstr(this)
        %DISPSTR Custom display string
        if ~isscalar(this)
            dispf('%s %s', size2str(size(this)), class(this));
            return
        end
        strs = dispstrs(this);
        out = strs{1};
        end
        
        function out = dispstrs(this)
        %DISPSTRS Custom display strings.
        out = cell(size(this));
        for i = 1:numel(this)
            t = this.time(i);
            if isnan(t)
                out{i} = 'NaT';
                continue;
            end
            nanosPerSecond = 10^9;
            nanosPerMinute = 60 * nanosPerSecond;
            nanosPerHour = 60 * nanosPerMinute;
            hours = floor(t / nanosPerHour);
            t = t - hours * nanosPerHour;
            minutes = floor(t / nanosPerMinute);
            t = t - minutes * nanosPerMinute;
            seconds = floor(t / nanosPerSecond);
            t = t - seconds * nanosPerSecond;
            str = sprintf('%02d:%02d:%02d', hours, minutes, seconds);
            if t > 0
                if rem(t, 1000) > 0
                    % Has nanos-of-microsecond
                    str = sprintf('%s.%09d', str, t);
                elseif rem(t, 1000000) > 0
                    % Has microseconds-of-millisecond
                    str = sprintf('%s.%06d', str, t / 10^3);
                else
                    str = sprintf('%s.%03d', str, t / 10^6);
                end
            end
            out{i} = str;
        end
        end
        
        function out = toJavaLocalTime(this)
        %TOJAVALOCALTIME Convert to Java-Time LocalTime.
        %
        % Converts this to a Java-Time LocalTime object, rounding to the nearest
        % nanosecond.
        mustBeScalar(this);
        out = java.time.LocalTime.ofNanoOfDay(uint64(this.time));
        end
        
        function out = datenum(this)
        %DATENUM Convert to a datenum
        %
        % Converts this to a datenum, whose year, month, and day are zero, and
        % whose time of day is equal to this.
        out = this.time / jl.time.localtime.NanosPerDay;
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
        out = jl.time.localtime(A.time + (B.time * jl.time.localtime.NanosPerDay));
        end
        
    end
    
    methods (Static = true)
        function out = ofTimeOfDay(time)
        %OFTIMEOFDAY Create localtime from fractional time-of-day value
        if any(time < 0 | time > 1)
            error('jl:InvalidInput', 'Value for time is out of range');
        end
        out = jl.time.localtime;
        out.time = time * jl.time.localtime.NanosPerDay;
        end
        
        function out = ofHMS(h, m, s)
        time = (h * 60 * 60 * 10^9) + (m * 60 * 10^9) + (s * 10^9);
        time = floor(time);
        out = jl.time.localtime;
        out.time = time;
        end
        
        function out = currentTimeOfDay()
        %CURRENTTIMEOFDAY Current time, as fractional time of the day
        out = rem(now, 1);
        end
        
        function out = currentNanosOfDay()
        %CURRENTNANOSOFDAY Current time, as nanoseconds of the day
        %
        % The time value is drawn from Matlab's CLOCK function, and has the same
        % accuracy and precision.
        c = clock;
        out = c(4) * 60 * 60 * 10^9 ...
            + c(5) * 60 * 10^9 ...
            + round(c(6) * 10^9);
        end
        
        function out = hmsmToNanosOfDay(h, m, s, timeOfSec)
        %HMSMTOTIMEOFDAY Convert hour/minute/second/timeOfSec to time of day
        %
        % Rounds to nanoseconds.
        %
        % s may contain fractional values.
        if nargin < 4; timeOfSec = 0; end
        out = (h * 60 * 60 * 10^9) ...
            + (m * 60 * 10^9) ...
            + round((s + timeOfSec) * 10^9);
        end
        
        function out = fromJavaLocalTime(jtime)
        %FROMJAVALOCALTIME Convert from Java-Time LocalTime to Janklab localtime
        if isempty(jtime)
            out = jl.time.localtime.NaT;
        elseif isa(jtime, 'java.time.LocalTime')
            out = jl.time.localtime;
            out.time = double(jtime.toNanoOfDay());
        elseif isa(jtime, 'java.time.LocalTime[]')
            out = repmat(jl.time.localtime, size(jtime));
            for i = 1:numel(jtime)
                out.time(i) = double(jtime(i).toNanoOfDay());
            end
        else
            error('jl:InvalidInput', 'Invalid input type: %s', class(jtime));
        end
        end
        
        function out = ofNanosOfDay(nanosOfDay)
        %OFNANOSOFDAY Convert a nanoseconds-of-day value to localtime
        out = jl.time.localtime;
        out.time = nanosOfDay;
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
        %
        % The precision of NOW is that of Matlab's CLOCK() function.
        %
        % See also: CLOCK, NOW
        out = jl.time.localtime;
        out.time = jl.time.localtime.currentNanosOfDay();
        end
        
        function out = nowHMS()
        %NOWHMS Current time of day in local time zone, rounded to seconds
        nanos = jl.time.localtime.currentNanosOfDay();
        nanosToSecond = round(nanos / 10^9) * 10^9;
        out = jl.time.localtime;
        out.time = nanosToSecond;
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
        
        function this = ctranspose(this)
        %CTRANSPOSE Complex conjugate transpose
        this.time = this.time';
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
        
        function out = cat(dim, varargin)
        %CAT Concatenate array
        for i = 1:numel(varargin)
            if ~isa(varargin{i}, 'jl.time.localtime')
                varargin{i} = jl.time.localtime(varargin{i});
            end
        end
        out = jl.time.localtime;
        inFields = cell(size(varargin));
        for i = 1:numel(varargin)
            inFields{i} = varargin{i}.time;
        end
        out.time = cat(dim, inFields{:});
        end
        
        function out = horzcat(varargin)
        %HORZCAT Horizontal concatenation.
        out = cat(2, varargin{:});
        end
        
        function out = vertcat(varargin)
        %VERTCAT Vertical concatenation.
        out = cat(1, varargin{:});
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
                out.time = this.time(s(1).subs{:});
            case '{}'
                error('jl:BadOperation',...
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
                error('jl:InvalidInput', ...
                    'Cannot compare a %s to a jl.time.localtime',...
                    class(x));
            end
        end
        end
        
    end
    
end

function mustBeValidTimeOfDayValue(x)
tfValid = isnan(x) | (x >= 0 & x < 1.0);
if ~all(tfValid)
    error('jl:InvalidInput', 'Invalid time values: %s', ...
        strjoin(jl.util.num2cellstr(x(~tfValid)), ', '));
end
end

function mustBeValidNanosOfDayValue(x)
tfValid = isnan(x) | (x >= 0 & x < jl.time.localtime.NanosPerDay);
if ~all(tfValid)
    error('jl:InvalidInput', 'Invalid time values: %s', ...
        strjoin(jl.util.num2cellstr(x(~tfValid)), ', '));
end
end


