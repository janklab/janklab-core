classdef timestamp
    %TIMESTAMP A date/time value with precision of 1 nanosecond
    %
    % This class is provided mainly for compatibility with SQL TIMESTAMPs.
    % Unless you need that compatibility, or really need nanosecond precision
    % for some other reason, you should use Matlab's DATETIME instead.
    %
    % This is mostly a dumb data holder class. It doesn't implement much
    % arithmetic.
    
    properties
        % The date component of this timestamp
        date jl.time.localdate = jl.time.localdate
        % The time of day within that date
        time jl.time.localtime = jl.time.localtime
    end
    
    methods
        function this = timestamp(x)
        %TIMESTAMP Construct a new timestamp
        if nargin == 0
            return
        end
        % Conversions
        if isa(x, 'jl.time.timestamp')
            this = x;
            return;
        elseif isa(x, 'datetime') || isa(x, 'double')
            if isdouble(x)
                dnum = x;
            else
                dnum = datenum(x);
            end
            this.date = jl.time.localdate(floor(dnum));
            fractionalDay = rem(dnum, 1);
            this.time = jl.time.localtime(fractionalDay);
        elseif isa(x, 'java.sql.Timestamp')
            millisPerDay = 24 * 60 * 60 * 1000;
            unixToDatenumEpochOffsetDays = 719529;
            % Because of how java.util.Date and java.sql.Timestamp interact,
            % nanos are double-counted when you call getTime() and getNanos();
            % you have to back out the nanos that appear in the fractional
            % second part of getTime().
            unixTime = x.getTime();
            extraNanos = rem(x.getNanos(), 10^6);
            unixDay = floor(unixTime / millisPerDay);
            millisOfDay = unixTime - (unixDay * millisPerDay);
            datenumDay = unixDay + unixToDatenumEpochOffsetDays;
            nanosOfDay = (millisOfDay * 10^6) + extraNanos;
            this.date = jl.time.localdate(datenumDay);
            this.time = jl.time.localtime.ofNanosOfDay(nanosOfDay);
        else
            error('jl:InvalidInput', 'Invalid input type: %s', class(x));
        end
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
        dateStrs = dispstrs(this.date);
        timeStrs = dispstrs(this.time);
        for i = 1:numel(this)
            out{i} = [dateStrs{i} ' ' timeStrs{i}];
        end
        out(isnan(this)) = {'NaN'};
        end
        
        function out = isnan(this)
        %ISNAN True if NaN.
        out = isnan(this.date) | isnan(this.time);
        end
        
        function out = isinf(this)
        %ISINF True if value is infinite
        out = isinf(this.date) | isinf(this.time);
        end
        
        function out = isfinite(this)
        %ISFINITE True if value is finite
        out = isfinite(this.date) & isfinite(this.time);
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
        this.time = reshape(this.time, varargin{:});
        end
        
        function this = ctranspose(this)
        %CTRANSPOSE Complex conjugate transpose
        this.date = this.date';
        this.time = this.time';
        end
        
        function this = squeeze(this)
        %SQUEEZE Remove singleton dimensions
        this.date = squeeze(this.date);
        this.time = squeeze(this.time);
        end
        
        function [this, nshifts] = shiftdim(this, n)
        %SHIFTDIM Shift dimensions
        if nargin > 1
            [this.date, ~] = shiftdim(this.date, n);
            [this.time, nshifts] = shiftdim(this.time, n);
        else
            this.date = shiftdim(this.date);
            this.time = shiftdim(this.time);
        end
        end
        
        function this = circshift(this, varargin)
        %CIRCSHIFT Shift positions of elements circularly
        this.date = circshift(this.date, varargin{:});
        this.time = circshift(this.time, varargin{:});
        end
        
        function this = permute(this, order)
        %PERMUTE Permute array dimensions
        this.date = permute(this.date, order);
        this.time = permute(this.time, order);
        end
        
        function this = ipermute(this, order)
        %IPERMUTE Inverse permute array dimensions
        this.date = ipermute(this.date, order);
        this.time = ipermute(this.time, order);
        end
        
        function this = repmat(this, varargin)
        %REPMAT Replicate and tile array
        this.date = repmat(this.date, varargin{:});
        this.time = repmat(this.time, varargin{:});
        end
        
        function out = cat(dim, varargin)
        %CAT Concatenate array
        for i = 1:numel(varargin)
            if ~isa(varargin{i}, 'jl.time.timestamp')
                varargin{i} = jl.time.timestamp(varargin{i});
            end
        end
        out = jl.time.timestamp;
        inFields = cell(size(varargin));
        for i = 1:numel(varargin)
            inFields{i} = varargin{i}.date;
        end
        out.date = cat(dim, inFields{:});
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
                    error('jl:TypeMisMatch', ...
                        'Cannot assign a subclass in to a %s (got a %s)',...
                        class(this), class(rhs));
                end
                this.date(s(1).subs{:}) = rhs.date;
                this.time(s(1).subs{:}) = rhs.time;
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
        
    end
    
    methods (Static)
        function out = now()
        c = clock;
        date = jl.time.localdate(c(1), c(2), c(3));
        time = jl.time.localtime(c(4), c(5), floor(c(6)), rem(c(6), 1));
        out = jl.time.timestamp.ofDateAndTime(date, time);
        end
        
        function out = ofDateAndTime(date, time)
        out = jl.time.timestamp;
        date = jl.time.localdate(date);
        time = jl.time.localtime(time);
        [date, time] = scalarexpand(date, time);
        out.date = date;
        out.time = time;
        end
    end
end