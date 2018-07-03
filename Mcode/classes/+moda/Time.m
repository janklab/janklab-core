classdef Time
    %TIME A time of day
    %
    % A TIME represents a local wall clock time, precise to the millisecond.
    % There is no time zone associated with a TIME.
    %
    % A TIME value ranges between 00:00:00 (midnight) and 24:00:00 (next
    % midnight). The 24:00:00 is not a real time in a single 24-hour period, but
    % is a denormalized value included for compatibility with other systems
    % (like some SQL databases) that include a denormalized 24:00:00 value.
    %
    % TIME values may also be NaN/NaT.
    
    % @planaridentity(time)

    properties (Hidden, Constant)
        nanVal = intmax('uint32');
        MsecPerDay = 24 * 60 * 60 * (10^3);
        MaxTimeVal = uint32(moda.Time.MsecPerDay);
    end
    
    properties (Constant)
        NaN = moda.Time(moda.Time.nanVal);
        Midnight = moda.Time(uint32(0));
        MinVal = moda.Time.Midnight;
        MaxVal = moda.Time(moda.Time.MaxTimeVal);
    end
    
    properties (Access='private')
        time uint32 = moda.Time.nanVal; % @planarnonan
    end
    
    properties (Dependent)
        Hour
        Minute
        Second
        Millisecond
    end
    
    methods (Static)
        function out = now()
        %NOW Get the current local time.
        out = moda.Time(mod(now, 1));        
        end
    end
    
    methods
        function this = Time(varargin)
        %TIME Create a Time array.
        %
        % t = moda.Time
        % t = moda.Time(timeStrings)
        % t = moda.Time(datenum)
        % t = moda.Time(msecOfDay uint32)
        % t = moda.Time(H, M, S, U)
        %
        % The zero-arg constructor returns a NaT value, unlike the zero-arg
        % datetime() constructor, which returns the current time.
        %
        % When datenum arguments are given, their values must be between 0.0 and
        % 1.0 (representing just a time of day).
        if nargin == 0
            return;
        elseif nargin == 1
            in = varargin{1};
            if ischar(in)
                in = cellstr(in);
            end
            if isa(in, 'moda.Time')
                this = in;
            elseif isa(in, 'double')
                % Convert from datenum
                dvec = datevec(in);
                [H,M,S] = deal(dvec(:,4), dvec(:,5), dvec(:,6));
                MM = round(mod(S, 1) * 10^3);
                S = floor(S);
                this.time = moda.Time.hmsmm2timeval(H, M, S, MM);
            elseif isa(in, 'uint32')
                % Convert fixed time
                if any(in > moda.Time.MaxTimeVal & in ~= moda.Time.nanVal)
                    error('jl:InvalidInput', 'Invalid argument: moda.Time(uint32) value exceeds max value');
                end
                this.time = in;
            elseif iscellstr(in)
                % Convert date strings
                % HACK: defer to datenum's parsing
                this = moda.Time(mod(datenum(in), 1));
            else
                error('jl:InvalidInput', 'Invalid argument type: moda.Time(%s)', ...
                    class(in));
            end
        elseif nargin == 3 || nargin == 4
            if nargin == 3
                [H, M, S] = varargin{:};
                MM = 0;
            else
                [H, M, S, MM] = varargin{:};
            end
            this.time = moda.Time.hmsmm2timeval(H, M, S, MM);
        else
            error('jl:InvalidInput', 'Invalid number of arguments');        
        end
        end
        
        function disp(this)
        %DISP Custom display.
        dispstr.DispstrHelper.disparray(this);
        end
        
        function out = dispstr(this)
        %DISPSTR Display string for array.
        if isscalar(this)
            strs = dispstrs(this);
            out = strs{1};
        else
            out = sprintf('%s %s\n', dispstr.internal.size2str(size(this)), ...
                class(this));
        end
        end
        
        function out = dispstrs(this)
        %DISPSTRS Display strings for array elements.
        tfNaN = isnan(this);
        out = cell(size(this));
        out(~tfNaN) = datestrs(subset(this, ~tfNaN));
        out(tfNaN) = {'NaN'};
        end
        
        function out = datestrs(this)
        %DATESTRS Date strings as cellstr.
        out = reshape(cellstr(datestr(this)), size(this));
        end
        
        function out = datenum(this)
        %DATENUM Convert to datenum.
        out = double(this.time) / moda.Time.MsecPerDay;
        out(isnan(this)) = NaN;
        end
        
        function out = datestr(this, format)
        %DATESTR Convert to datestr.
        if nargin < 2 || isempty(format);  format = 'HH:MM:SS'; end
        out = datestr(datenum(this), format);
        end
        
        function out = datestruct(this)
        %DATESTRUCT Convert to datestruct.
        [h,m,s,mm] = timevec(this);
        out.Hour = h;
        out.Minute = m;
        out.Second = s;
        out.Millisecond = mm;
        end
        
        function varargout = timevec(this)
        %TIMEVEC Convert to timevec
        tfNaN = isnan(this);
        t = double(this.time);
        millis_per_hour = 60 * 60 * 10^3;
        H = floor(t / millis_per_hour);
        t = mod(t, millis_per_hour);
        millis_per_minute = 60 * 10^3;
        M = floor(t / millis_per_minute);
        t = mod(t, millis_per_minute);
        millis_per_second = 10^3;
        S = floor(t / millis_per_second);
        t = mod(t, millis_per_second);
        MM = t;
        H(tfNaN) = NaN;
        M(tfNaN) = NaN;
        S(tfNaN) = NaN;
        MM(tfNaN) = NaN;
        if nargout == 1
            varargout = { [H(:) M(:) S(:) MM(:)] };
        else
            varargout = { H M S MM };
        end
        end
        
        function out = get.Hour(this)
        [h,~,~,~] = timevec(this);
        out = h;
        end
        
        function out = get.Minute(this)
        [~,m,~,~] = timevec(this);
        out = m;
        end
        
        function out = get.Second(this)
        [~,~,s,~] = timevec(this);
        out = s;
        end
        
        function out = get.Millisecond(this)
        [~,~,~,mm] = timevec(this);
        out = mm;
        end
        
    end
    
    methods (Static)
        function out = hmsmm2timeval(H, M, S, MM)
        %HMSMM2TIMEVAL Convert hour/minute/second/millisecond to millis-of-day
        %
        % out = hmsmm2timeval(H, M, S, MM)
        %
        % Handles scalar expansion, bounds checking, NaN propagation, and type 
        % conversion.
        if nargin < 4; MM = 0; end
        tfNaN = isnan(H) | isnan(M) | isnan(S) | isnan(MM) ...
            | isinf(H) | isinf(M) | isinf(S) | isinf(MM);
        [Hin, Min, Sin, MMin] = deal(H, M, S, MM); %#ok<ASGLU> % for debugging
        [H, M, S, MM] = deal(uint32(H), uint32(M), uint32(S), uint32(MM));
        tfBad = H  >= 24 | M >= 60 | S >= 60 | MM >= 10^3;
        tfBad(H == 24 & M == 0 & S == 0 & MM == 0) = false; % allow 24:00:00
        if any(tfBad)
            ixBad = find(tfBad);
            [h, m, s, mm] = scalarexpand(H, M, S, MM);
            error('jl:InvalidInput', 'H/M/S/MM value out of range: (%d, %d, %d, %d)', ...
                h(ixBad(1)), m(ixBad(1)), s(ixBad(1)), mm(ixBad(1)));
        end
        out = (H * 60 * 60 * 10^3) + (M * 60 * 10^3) + (S * 10^3) + MM;
        out(tfNaN) = moda.Time.nanVal;
        end
    end
    %%%%% START PLANAR-CLASS BOILERPLATE CODE %%%%%
    
    % This section contains code auto-generated by Janklab's genPlanarClass.
    % Do not edit code in this section manually.
    % Do not remove the "%%%%% START/END .... %%%%%" header or footer either;
    % that will cause the code regeneration to break.
    % To update this code, re-run jl.code.genPlanarClass() on this file.
    
    methods
    
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
        
        function out = isnan(this)
        %ISNAN True for Not-a-Number.
        out = false(size(this));
        end
        
        function this = reshape(this, varargin)
        %RESHAPE Reshape array.
        this.time = reshape(this.time, varargin{:});
        end
        
        function this = squeeze(this, varargin)
        %SQUEEZE Remove singleton dimensions.
        this.time = squeeze(this.time, varargin{:});
        end
        
        function this = circshift(this, varargin)
        %CIRCSHIFT Shift positions of elements circularly.
        this.time = circshift(this.time, varargin{:});
        end
        
        function this = permute(this, varargin)
        %PERMUTE Permute array dimensions.
        this.time = permute(this.time, varargin{:});
        end
        
        function this = ipermute(this, varargin)
        %IPERMUTE Inverse permute array dimensions.
        this.time = ipermute(this.time, varargin{:});
        end
        
        function this = repmat(this, varargin)
        %REPMAT Replicate and tile array.
        this.time = repmat(this.time, varargin{:});
        end
        
        function this = ctranspose(this, varargin)
        %CTRANSPOSE Complex conjugate transpose.
        this.time = ctranspose(this.time, varargin{:});
        end
        
        function this = transpose(this, varargin)
        %TRANSPOSE Transpose vector or matrix.
        this.time = transpose(this.time, varargin{:});
        end
        
        function [this, nshifts] = shiftdim(this, n)
        %SHIFTDIM Shift dimensions.
        if nargin > 1
            this.time = shiftdim(this.time, n);
        else
            [this.time,nshifts] = shiftdim(this.time);
        end
        end
        
        function out = cat(dim, varargin)
        %CAT Concatenate arrays.
        args = varargin;
        for i = 1:numel(args)
            if ~isa(args{i}, 'moda.Time')
                args{i} = moda.Time(args{i});
            end
        end
        out = args{1};
        fieldArgs = cellfun(@(obj) obj.time, args, 'UniformOutput', false);
        out.time = cat(dim, fieldArgs{:});
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
                this = subsasgnParensPlanar(this, s(1), rhs);
            case '{}'
                error('jl:BadOperation',...
                    '{}-subscripting is not supported for class %s', class(this));
            case '.'
                this.(s(1).subs) = rhs;
        end
        end
        
        function out = subsref(this, s)
        %SUBSREF Subscripted reference.
        
        % Base case
        switch s(1).type
            case '()'
                out = subsrefParensPlanar(this, s(1));
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
        
        function n = numArgumentsFromSubscript(this,~,indexingContext) %#ok<INUSL>
        switch indexingContext
            case matlab.mixin.util.IndexingContext.Statement
                n = 1; % nargout for indexed reference used as statement
            case matlab.mixin.util.IndexingContext.Expression
                n = 1; % nargout for indexed reference used as function argument
            case matlab.mixin.util.IndexingContext.Assignment
                n = 1; % nargin for indexed assignment
        end
        end
        
        function out = size(this, dim)
        %SIZE Size of array.
        if nargin == 1
            out = size(this.time);
        else
            out = size(this.time, dim);
        end
        end
        
        function out = eq(a, b)
        %EQ == Equal.
        if ~isa(a, 'moda.Time')
            a = moda.Time(a);
        end
        if ~isa(b, 'moda.Time')
            b = moda.Time(b);
        end
        tf = a.time == b.time;
        out = tf;
        end
        
        function out = lt(a, b)
        %LT < Less than.
        if ~isa(a, 'moda.Time')
            a = moda.Time(a);
        end
        if ~isa(b, 'moda.Time')
            b = moda.Time(b);
        end
        out = false(size(a));
        tfUndecided = true(size(out));
        % Check field time
        lhs = a.time(tfUndecided);
        rhs = b.time(tfUndecided);
        tfThisStep = lhs < rhs;
        out(tfUndecided) = tfThisStep;
        end
        
        function out = gt(a, b)
        %GT > Greater than.
        if ~isa(a, 'moda.Time')
            a = moda.Time(a);
        end
        if ~isa(b, 'moda.Time')
            b = moda.Time(b);
        end
        out = false(size(a));
        tfUndecided = true(size(out));
        % Check field time
        lhs = a.time(tfUndecided);
        rhs = b.time(tfUndecided);
        tfThisStep = lhs > rhs;
        out(tfUndecided) = tfThisStep;
        end
        
        function out = ne(a, b)
        %NE ~= Not equal.
        out = ~(a == b);
        end
        
        function out = le(a, b)
        %LE <= Less than or equal.
        out = a < b | a == b;
        end
        
        function out = ge(a, b)
        %GE <= Greater than or equal.
        out = a > b | a == b;
        end
        
        function out = cmp(a, b)
        %CMP Compare values for ordering.
        %
        % CMP compares values elementwise, returning for each element:
        %   -1 if a(i) < b(i)
        %   0  if a(i) == b(i)
        %   1  if a(i) > b(i)
        %   NaN if either a(i) or b(i) were NaN, or no relop methods returned
        %       true
        %
        % Returns an array the same size as a and b (after scalar expansion).
        
        if ~isa(a, 'moda.Time')
            a = moda.Time(a);
        end
        if ~isa(b, 'moda.Time')
            b = moda.Time(b);
        end
        out = NaN(size(a));
        tfUndecided = true(size(out));
        % Test <
        tf = a < b;
        out(tf) = -1;
        tfUndecided(tf) = false;
        % Test ==
        tf = a(tfUndecided) == b(tfUndecided);
        nextTest = NaN(size(tf));
        nextTest(tf) = 0;
        out(tfUndecided) = nextTest;
        tfUndecided(tfUndecided) = ~tf;
        % Test >
        tf = a(tfUndecided) > b(tfUndecided);
        nextTest = NaN(size(tf));
        nextTest(tf) = 1;
        out(tfUndecided) = nextTest;
        tfUndecided(tfUndecided) = ~tf; %#ok<NASGU>
        % Anything left over is either NaN inputs or an unsupported relop
        % Leave it as NaN.
        end
        
        function [out,Indx] = sort(this)
        %SORT Sort array elements.
        if isvector(this)
            isRow = isrow(this);
            this = subset(this, ':');
            % NaNs sort stably to end, so handle them separately
            tfNan = isnan(this);
            nans = subset(this, tfNan);
            nonnans = subset(this, ~tfNan);
            ixNonNan = find(~tfNan);
            proxy = proxyKeys(nonnans);
            [~,ix] = sortrows(proxy);
            out = [subset(nonnans, ix); nans];
            Indx = [ixNonNan(ix); find(tfNan)];
            if isRow
                out = out';
            end
        elseif ismatrix(this)
            out = this;
            Indx = NaN(size(out));
            for iCol = 1:size(this, 2)
                [sortedCol,Indx(:,iCol)] = sort(subset(this, ':', iCol));
                out = asgn(out, {':', iCol}, sortedCol);
            end
        else
            % I believe this multi-dimensional implementation is correct,
            % but have not tested it yet. Use with caution.
            out = this;
            Indx = NaN(size(out));
            sz = size(this);
            nDims = ndims(this);
            ixs = [{':'} repmat({1}, [1 nDims-1])];
            while true
                col = subset(this, ixs{:});
                [sortedCol,sortIx] = sort(col);
                Indx(ixs{:}) = sortIx;
                out = asgn(out, ixs, sortedCol);
                ixs{end} = ixs{end}+1;
                for iDim=nDims:-1:3
                    if ixs{iDim} > sz(iDim)
                        ixs{iDim-1} = ixs{iDim-1} + 1;
                        ixs{iDim} = 1;
                    end
                end
                if ixs{2} > sz(2)
                    break;
                end
            end
        end
        end
        
        function [out,Indx] = unique(this, varargin)
        %UNIQUE Set unique.
        flags = setdiff(varargin, {'rows'});
        if ismember('rows', varargin)
            [~,proxyIx] = unique(this);
            proxyIx = reshape(proxyIx, size(this));
            [~,Indx] = unique(proxyIx, 'rows', flags{:});
            out = subset(this, Indx, ':');
        else
            isRow = isrow(this);
            this = subset(this, ':');
            tfNaN = isnan(this);
            nans = subset(this, tfNaN);
            nonnans = subset(this, ~tfNaN);
            ixNonnan = find(~ftNaN);
            keys = proxyKeys(nonnans);
            if isa(keys, 'table')
                [~,ix] = unique(keys, flags{:});
            else
                [~,ix] = unique(keys, 'rows', flags{:});
            end
            out = [subset(nonnans, ix); nans];
            Indx = [ixNonnan(ix); find(tfNaN)];
            if isRow
                out = out';
            end
        end
        end
        
        function [out,Indx] = ismember(a, b, varargin)
        %ISMEMBER True for set member.
        if ismember('rows', varargin)
            error('ismember(..., ''rows'') is unsupported');
        end
        if ~isa(a, 'moda.Time')
            a = moda.Time(a);
        end
        if ~isa(b, 'moda.Time')
            b = moda.Time(b);
        end
        [proxyA, proxyB] = proxyKeys(a, b);
        [out,Indx] = ismember(proxyA, proxyB, 'rows');
        out = reshape(out, size(a));
        Indx = reshape(Indx, size(a));
        end
        
        function [out,Indx] = setdiff(a, b)
        %SETDIFF Set difference.
        if ismember('rows', varargin)
            error('setdiff(..., ''rows'') is unsupported');
        end
        [tf,~] = ismember(a, b);
        out = parensRef(a, ~tf);
        Indx = find(~tf);
        [out,ix] = unique(out);
        Indx = Indx(ix);
        end
        
        function [out,ia,ib] = intersect(a, b, varargin)
        %INTERSECT Set intersection.
        if ismember('rows', varargin)
            error('intersect(..., ''rows'') is unsupported');
        end
        [proxyA, proxyB] = proxyKeys(a, b);
        [~,ia,ib] = intersect(proxyA, proxyB, 'rows');
        out = parensRef(a, ia);
        end
        
        function [out,ia,ib] = union(a, b, varargin)
        %UNION Set union.
        if ismember('rows', varargin)
            error('union(..., ''rows'') is unsupported');
        end
        [proxyA, proxyB] = proxyKeys(a, b);
        [~,ia,ib] = union(proxyA, proxyB, 'rows');
        aOut = parensRef(a, ia);
        bOut = parensRef(b, ib);
        out = [parensRef(aOut, ':'); parensRef(bOut, ':')];
        end
        
        function [keysA,keysB] = proxyKeys(a, b)
        %PROXYKEYS Proxy key values for sorting and set operations
        propertyValsA = {a.time};
        propertyTypesA = cellfun(@class, propertyValsA, 'UniformOutput',false);
        isAllNumericA = all(cellfun(@isnumeric, propertyValsA));
        propertyValsA = cellfun(@(x) x(:), propertyValsA, 'UniformOutput',false);
        if nargin == 1
            if isAllNumericA && isscalar(unique(propertyTypesA))
                % Properties are homogeneous numeric types; we can use them directly 
                keysA = cat(2, propertyValsA{:});
            else
                % Properties are heterogeneous or non-numeric; resort to using a table
                propertyNames = {'time'};
                keysA = table(propertyValsA{:}, 'VariableNames', propertyNames);
            end
        else
            propertyValsB = {b.time};
            propertyTypesB = cellfun(@class, propertyValsB, 'UniformOutput',false);
            isAllNumericB = all(cellfun(@isnumeric, propertyValsB));
            propertyValsB = cellfun(@(x) x(:), propertyValsB, 'UniformOutput',false);
            if isAllNumericA && isAllNumericB && isscalar(unique(propertyTypesA)) ...
                && isscalar(unique(propertyTypesB))
                % Properties are homogeneous numeric types; we can use them directly
                keysA = cat(2, propertyValsA{:});
                keysB = cat(2, propertyValsB{:});
            else
                % Properties are heterogeneous or non-numeric; resort to using a table
                propertyNames = {'time'};
                keysA = table(propertyValsA{:}, 'VariableNames', propertyNames);
                keysB = table(propertyValsB{:}, 'VariableNames', propertyNames);
            end
        end
        end
    
    end
    
    methods (Access=private)
    
        function this = subsasgnParensPlanar(this, s, rhs)
        %SUBSASGNPARENSPLANAR ()-assignment for planar object
        if ~isa(rhs, 'moda.Time')
            rhs = moda.Time(rhs);
        end
        this.time(s.subs{:}) = rhs.time;
        end
        
        function out = subsrefParensPlanar(this, s)
        %SUBSREFPARENSPLANAR ()-indexing for planar object
        out = this;
        out.time = this.time(s.subs{:});
        end
        
        function out = parensRef(this, varargin)
        %PARENSREF ()-indexing, for this class's internal use
        out = subsrefParensPlanar(this, struct('subs', {varargin}));
        end
        
        function out = subset(this, varargin)
        %SUBSET Subset array by indexes.
        % This is what you call internally inside the class instead of doing 
        % ()-indexing references on the RHS, which don't work properly inside the class
        % because they don't respect the subsref() override.
        out = parensRef(this, varargin{:});
        end
        
        function out = asgn(this, ix, value)
        %ASGN Assign array elements by indexes.
        % This is what you call internally inside the class instead of doing 
        % ()-indexing references on the LHS, which don't work properly inside
        % the class because they don't respect the subsasgn() override.
        if ~iscell(ix)
            ix = { ix };
        end
        s.type = '()';
        s.subs = ix;
        out = subsasgnParensPlanar(this, s, value);
        end
    
    end
    
    %%%%% END PLANAR-CLASS BOILERPLATE CODE %%%%%

end

%%%%% START PLANAR-CLASS BOILERPLATE LOCAL FUNCTIONS %%%%%

% This section contains code auto-generated by Janklab's genPlanarClass.
% Do not edit code in this section manually.
% Do not remove the "%%%%% START/END .... %%%%%" header or footer either;
% that will cause the code regeneration to break.
% To update this code, re-run jl.code.genPlanarClass() on this file.

function out = isnan2(x)
%ISNAN2 True if input is NaN or NaT
% This is a hack to work around the edge case of @datetime, which 
% defines an isnat() function instead of supporting isnan() like 
% everything else.
if isa(x, 'datetime')
    out = isnat(x);
else
    out = isnan(x);
end
end

%%%%% END PLANAR-CLASS BOILERPLATE LOCAL FUNCTIONS %%%%%

