classdef localdate
    %LOCALDATE A calendar date
    %
    % A localdate represents an entire calendar day, as opposed to a specific instant
    % in time. A localdate has no time zone or time of day component.
    %
    % TODO: Add support for datenums and strings in relational operations. I think
    % this can be done by just promoting/converting all relop inputs to localdate,
    % and making sure the conversion is well-defined for datetimes.
    %
    % See also:
    % datetime, jl.time.localtime, jl.time.duration
    
    % Open questions:
    % How should < > <= >= comparisons between localdate and datetime work?
    % Does localdate('3/1/2015') come before datetime('3/1/2015 01:00')?
    
    
    properties (Constant, GetAccess='public')
        iso8601Format = 'yyyy-MM-dd';
    end
    
    properties (Constant, Access='protected')
        defaultDateFormat = 'dd-mmm-yyyy'
    end
    
    properties (Access='protected')
        % Count of days from the Matlab epoch date, as double (i.e. datenum).
        % Constrained to never have fractional value.
        date {mustBeValidDateValue};
    end
    
    methods (Access = 'public')
        function this = localdate(in, varargin)
        %LOCALDATE Create a localdate array
        %
        % d = localdate
        % d = localdate(relativeDay)
        % d = localdate(datenum)
        % d = localdate(DateStrings)
        % d = localdate(DateStrings, 'InputFormat',infmt)
        % d = localdate(Y, M, D)
        
        if nargin == 0
            this.date = floor(now);
            return;
        elseif nargin == 1
            if isa(in, 'localdate')
                this = in;
                return;
            elseif ischar(in)
                if ismember(in, {'now', 'yesterday', 'today', 'tomorrow'})
                    switch in
                        case {'now','today'}
                            this.date = floor(now);
                        case 'yesterday'
                            this.date = floor(now) - 1;
                        case 'tomorrow'
                            this.date = floor(now) + 1;
                    end
                    return
                else
                    date = datenum(in);
                end
            elseif iscellstr(in) || isstring(in)
                date = datenum(datetime(in,varargin{:}));
            elseif isnumeric(in)
                date = in;
            else
                error('jl:InvalidLocalDateInput', 'localdate(in) is not defined for %s',...
                    class(in));
            end
        elseif nargin == 3
            date = datenum(datetime(in, varargin{1}, varargin{2}));
        else
            error('jl:InvalidLocalDateInput', 'invalid number of arguments');
        end
        tfHasTime = ~isnan(date) & ~isinf(date) & mod(date, 1) ~= 0;
        if any(tfHasTime(:))
            error('jl:InvalidLocalDateInput', 'localdate(in) input may not have time of day');
        end
        this.date = date;
        end
        
        function disp(this)
        %DISP Custom display
        if isscalar(this)
            if isnat(this)
                out = 'NaT';
            elseif isinf(this.date)
                out = num2str(this.date);
            else
                out = datestr(this, localdate.defaultDateFormat);
            end
        else
            out = sprintf('%s %s', size2str(size(this)), class(this));
        end
        disp(out);
        end
        
        function out = eps(this)
        %EPS Precision of time representation at this value.
        out = jl.time.duration(eps(this.date));
        end
        
        function out = datestr(this, varargin)
        %DATESTR Convert to datestr
        out = datestr(this.date, varargin{:});
        end
        
        function out = datetime(this)
        %DATETIME Convert to datetime, at midnight at the start of the day
        %
        % Converts this to a datetime whose value is that of midnight at the start
        % of this calendar day, and has no TimeZone.
        out = datetime(this.date, 'ConvertFrom', 'datenum');
        end
        
        function out = datenum(this)
        %DATENUM Convert to datenum, at midnight at the start of the day
        out = this.date;
        end
        
        function out = datevec(this)
        %DATEVEC Convert to datevec, at midnight at the start of the day
        out = datevec(this.date);
        end
        
        function out = cellstr(this)
        %CELLSTR Convert to cellstr
        strs = datestr(this, localdate.defaultDateFormat);
        out = reshape(cellstr(strs), size(this));
        end
        
        function out = char(this)
        %CHAR Convert to char array
        out = datestr(this);
        end
        
        function out = minus(A, B)
        %MINUS Difference between two localdates
        A = localdate(A);
        B = localdate(B);
        out = jl.time.duration(A.date - B.date);
        end
        
        function out = plus(A, B)
        %PLUS Add a duration to a localdate.
        %
        % A + B
        %
        % A is converted to a localdate, and B is converted to a duration. If the
        % result contains fractional days, it is an error.
        A = localdate(A);
        B = jl.time.duration(B);
        out = localdate(A.date + B.time);
        end
        
        % Component and conversion methods
        
        function [y,m,d] = ymd(this)
        %YMD year, month, and day numbers
        [y,m,d] = ymd(datetime(this));
        end
        
        function y = year(this, kind)
        %YEAR Year numbers of localdates
        if nargin == 1
            y = year(datetime(this));
        else
            y = year(datetime(this), kind);
        end
        end
        
        function out = quarter(this)
        %QUARTER Quarter numbers of localdates
        out = quarter(datetime(this));
        end
        
        function out = month(this, kind)
        %MONTH Month numbers or names of localdates
        if nargin == 1
            out = month(datetime(this));
        else
            out = month(datetime(this), kind);
        end
        end
        
        function out = week(this, kind)
        %WEEK Week numbers of localdates
        if nargin == 1
            out = week(datetime(this));
        else
            out = week(datetime(this), kind);
        end
        end
        
        function out = day(this, kind)
        %DAY Day numbers or names of localdates
        if nargin == 1
            out = day(datetime(this));
        else
            out = day(datetime(this), kind);
        end
        end
        
        function tf = isweekend(this)
        %ISWEEKEND True for localdates occurring on a weekend
        tf = isweekend(datetime(this));
        end
        
        function tf = isnat(this)
        %ISNAT True for localdates that are Not-a-Time
        tf = isnan(this.date);
        end
        
        function tf = isnan(this)
        %ISNAN True for localdates that are Not-a-Time
        tf = isnan(this.date);
        end
        
        function out = toJavaLocalDates(this)
        %TOJAVALOCALDATES Convert this to java.time.LocalDate[]
        out = javaArray('java.time.LocalDate', numel(this));
        for i = 1:numel(this)
            out(i) = this(i).toJavaLocalDate();
        end
        end
        
        function out = toJavaLocalDate(this)
        %TOJAVALOCALDATE Convert this to java.time.LocalDate
        mustBeScalar(this);
        dv = datevec(this.date);
        out = java.time.LocalDate.of(dv(1), dv(2), dv(3));
        end
        
    end
    
    methods (Static = true)
        
        function out = NaT(sz)
        %NAT Create Not-a-Time localdates
        if nargin < 1; sz = [1 1]; end
        out = localdate(NaN(sz));
        end
        
        function out = fromJavaLocalDate(jdate)
        %FROMJAVALOCALDATE Convert from Java Time LocalDate
        if isempty(jdate)
            out = localdate.NaT;
        elseif isa(jdate, 'java.time.LocalDate')
            out = localdate(jdate.getYear(), jdate.getMonthValue(), jdate.getDayOfMonth());
        elseif isa(jdate, 'java.time.LocalDate[]')
            out = repmat(localdate, size(jdate));
            for i = 1:numel(jdate)
                out_i = localdate.fromJavaLocalDate(jdate(i));
                out.date(i) = out_i.date;
            end
        else
            error('Invalid input type: %s', class(jdate));
        end
        end
    end
    
    methods
        % Structural planar-organization methods
        
        function varargout = size(this, varargin)
        %SIZE Size of array
        varargout = cell(1, max(1, nargout));
        [varargout{:}] = size(this.date, varargin{:});
        end
        
        function out = numel(this)
        %NUMEL Number of elements in array
        out = numel(this.date);
        end
        
        function out = ndims(this)
        %NDIMS Number of dimensions
        out = ndims(this.date);
        end
        
        function out = isempty(this)
        %ISEMPTY True for empty array
        out = isempty(this.date);
        end
        
        function out = isscalar(this)
        %ISSCALAR True if input is scalar
        out = isscalar(this.date);
        end
        
        function out = isvector(this)
        %ISVECTOR True if input is a vector
        out = isvector(this.date);
        end
        
        function out = iscolumn(this)
        %ISCOLUMN True if input is a column vector
        out = iscolumn(this.date);
        end
        
        function out = isrow(this)
        %ISROW True if input is a row vector
        out = isrow(this.date);
        end
        
        function out = ismatrix(this)
        %ISMATRIX True if input is a matrix
        out = ismatrix(this.date);
        end
        
        function this = reshape(this, varargin)
        %RESHAPE Reshape array
        this.date = reshape(this.date, varargin{:});
        end
        
        function this = squeeze(this)
        %SQUEEZE Remove singleton dimensions
        this.date = squeeze(this.date);
        end
        
        function [this, nshifts] = shiftdim(this, n)
        %SHIFTDIM Shift dimensions
        if nargin > 1
            [this.date, nshifts] = shiftdim(this.date, n);
        else
            this.date = shiftdim(this.date);
        end
        end
        
        function this = circshift(this, varargin)
        %CIRCSHIFT Shift positions of elements circularly
        this.date = circshift(this.date, varargin{:});
        end
        
        function this = permute(this, order)
        %PERMUTE Permute array dimensions
        this.date = permute(this.date, order);
        end
        
        function this = ipermute(this, order)
        %IPERMUTE Inverse permute array dimensions
        this.date = ipermute(this.date, order);
        end
        
        function this = repmat(this, varargin)
        %REPMAT Replicate and tile array
        this.date = repmat(this.date, varargin{:});
        end
        
        function out = cat(dim, varargin)
        %CAT Concatenate array
        for i = 1:numel(varargin)
            if ~isa(varargin{i}, 'localdate')
                varargin{i} = localdate(varargin{i});
            end
        end
        out = localdate;
        inFields = cell(size(varargin));
        for i = 1:numel(varargin)
            inFields{i} = varargin{i}.date;
        end
        out.date = cat(dim, inFields);
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
                    error('jl:TypeMisMatch', 'Cannot assign a subclass in to a %s (got a %s)',...
                        class(this), class(rhs));
                end
                this.date(s(1).subs{:}) = rhs.date;
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
                out.date = this.date(s(1).subs{:});
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
        [ap, bp] = localdate.getCmpProxies(a, b);
        out = eq(ap, bp);
        end
        
        function out = ne(a, b)
        %NE Not equal
        [ap, bp] = localdate.getCmpProxies(a, b);
        out = ne(ap, bp);
        end
        
        function out = lt(a, b)
        %LT Less than
        [ap, bp] = localdate.getCmpProxies(a, b);
        out = lt(ap, bp);
        end
        
        function out = le(a, b)
        %LE Less than or equal
        [ap, bp] = localdate.getCmpProxies(a, b);
        out = le(ap, bp);
        end
        
        function out = gt(a, b)
        %GT Greater than
        [ap, bp] = localdate.getCmpProxies(a, b);
        out = gt(ap, bp);
        end
        
        function out = ge(a, b)
        %GE Greater than or equal
        [ap, bp] = localdate.getCmpProxies(a, b);
        out = ge(ap, bp);
        end
        
        function out = cmp(a, b)
        %CMP Compare for ordering
        [ap, bp] = localdate.getCmpProxies(a, b);
        out = sign(ap - bp);
        end
        
        function out = isequal(varargin)
        %ISEQUAL True if localdate arrays are equal
        proxies = localdate.getEqProxies(varargin{:});
        out = isequal(proxies{:});
        end
        
        function out = isequaln(varargin)
        %ISEQUAL True if localdate arrays are equal, treating NaT elements as equal
        proxies = localdate.getEqProxies(varargin{:});
        out = isequaln(proxies{:});
        end
    end
    
    methods (Static = true, Access = 'private')
        function varargout = getCmpProxies(varargin)
        %GETCMPPROXIES Get proxy values for use in relational comparisons
        varargout = cell(size(varargin));
        for i = 1:numel(varargin)
            x = varargin{i};
            if isa(x, 'localdate')
                y = x.date;
            elseif isa(x, 'datetime')
                y = datenum(x);
            elseif isnumeric(x)
                y = x;
            else
                error('jl:InvalidInput', 'Cannot compare a %s to a localdate',...
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
            if isa(x, 'localdate')
                varargout{i} = x.date;
            else
                error('jl:InvalidLocalDateEqType', 'Cannot compare a %s to a localdate',...
                    class(x));
            end
        end
        end
        
    end
    
end

function mustBeValidDateValue(x)
tfValid = isnan(x) | isinf(x) | jl.types.tests.isWhole(x);
if ~all(tfValid)
    error('Invalid date values: %s', ...
        strjoin(jl.util.num2cellstr(x(~tfValid)), ', '));
end
end
