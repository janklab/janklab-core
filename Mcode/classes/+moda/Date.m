classdef Date
    %DATE A calendar date in the ISO calendar
    %
    % A calendar date without a time zone in the ISO-8601 calendar system.
    %
    % A DATE represents an entire calendar day, as opposed to a specific instant
    % in time. A DATE has no time zone or time of day components. It is
    % useful for storing things such as birthdays, holidays, or business days.
    %
    % DATE values may be NaN/NaT or -Inf/Inf.
    
    % TODO: Replace the datenum() cheating in here with direct, native
    % calendrical calculations.
    
    % @planaridentity(fixedDate)
    
    properties (Hidden, Constant)
        matlabToModaEpochOffset = int32(datenum(1, 1, 1));
        
        negInfVal = intmin('int32');
        posInfVal = intmax('int32') - 1;
        nanVal = intmax('int32');        
    end
    
    properties (Constant)
        NaN = moda.Date(moda.Date.nanVal);
        Inf = moda.Date(moda.Date.posInfVal);
        NegInf = moda.Date(moda.Date.negInfVal);
        MinVal = moda.Date(intmin('int32') + 1);
        MaxVal = moda.Date(intmax('int32') - 2);
    end
    
    properties (Access='private')
        fixedDate int32 = moda.Date.nanVal; % @planarnonan
    end
    
    properties (Dependent)
        Year
        Month
        Day
    end
    
    methods (Static)
    end
    
    methods
        function this = Date(in, varargin)
        %DATE Create a Date array.
        %
        % d = moda.Date
        % d = moda.Date(relativeDay)
        % d = moda.Date(datenum)
        % d = moda.Date(dateStrings)
        % d = moda.Date(Y, M, D)
        %
        % The zero-arg constructor returns a NaT value, unlike the zero-arg
        % datetime() constructor, which returns the current time.
        %
        % RelativeDay (char) may be 'now', 'yesterday', 'today', or 'tomorrow'.
        
        if nargin == 0
            return;
        elseif nargin == 1
            if isa(in, 'moda.Date')
                this = in;
                return;
            elseif ischar(in)
                if ismember(in, {'now', 'yesterday', 'today', 'tomorrow'})
                    switch in
                        case {'now','today'}
                            this.fixedDate = nowFixedDate;
                        case 'yesterday'
                            this.fixedDate = nowFixedDate - 1;
                        case 'tomorrow'
                            this.fixedDate = nowFixedDate + 1;
                    end
                    return
                else
                    % Convert from date strings
                    this = moda.Date(datenum(in));
                end
            elseif isa(in, 'double')
                % Convert from datenums
                this.fixedDate = datenumToModaFixedDate(in);
            elseif isa(in, 'int32')
                this.fixedDate = in;
            else
                error('jl:InvalidInput', ...
                    'moda.Date(in) is not defined for type %s', class(in));
            end
        elseif nargin == 3
            % Convert from (Year, Month, Day)
            this = moda.Date(datenum(in, varargin{1}, varargin{2}));
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
        tfPosInf = this.fixedDate == moda.Date.posInfVal;
        tfNegInf = this.fixedDate == moda.Date.negInfVal;
        tfSpecial = tfNaN | tfPosInf | tfNegInf;
        tfRegular = ~tfSpecial;
        out = cell(size(this));
        tmp = datestrs(subset(this, tfRegular));
        out(tfRegular) = tmp;
        out(tfNaN) = {'NaN'};
        out(tfPosInf) = {'Inf'};
        out(tfNegInf) = {'-Inf'};
        end

        function out = datestrs(this, varargin)
        %DATESTRS Date strings as cellstr.
        out = reshape(cellstr(datestr(this, varargin{:})), size(this));
        end
        
        function out = datenum(this)
        %DATENUM Convert to datenum.
        out = double(this.fixedDate + moda.Date.matlabToModaEpochOffset);
        end
        
        function out = datestr(this, varargin)
        %DATESTR Convert to datestr.
        out = datestr(datenum(this), varargin{:});
        end
        
        function out = datestruct(this)
        %DATESTRUCT Convert to datestruct.
        [y,m,d] = datevec(this);
        out.Year = y;
        out.Month = m;
        out.Day = d;
        end
        
        function varargout = datevec(this)
        %DATEVEC Convert to datevec.
        [y,m,d] = datevec(datenum(this));
        tfNaN = isnan(this);
        tfPosInf = this.fixedDate == moda.Date.posInfVal;
        tfNegInf = this.fixedDate == moda.Date.negInfVal;
        y(tfNaN) = NaN;
        y(tfPosInf) = Inf;
        y(tfNegInf) = -Inf;
        m(tfNaN) = NaN;
        m(tfPosInf) = Inf;
        m(tfNegInf) = -Inf;
        d(tfNaN) = NaN;
        d(tfPosInf) = Inf;
        d(tfNegInf) = -Inf;
        if nargout < 2
            varargout = { [y(:) m(:) d(:)] };
        else
            varargout = { y m d };
        end
        end
        
        function out = get.Year(this)
        [y,~,~] = datevec(this);
        out = y;
        end
        
        function out = get.Month(this)
        [~,m,~] = datevec(this);
        out = m;
        end
        
        function out = get.Day(this)
        [~,~,d] = datevec(this);
        out = d;
        end
        
        function out = plus(this, addend)
        %PLUS Add a duration to this date.
        
        %TODO: add @calendarDuration support
        if ~isa(this, 'moda.Date')
            error('jl:InvalidInput', 'A moda.Date must be the left-hand argument to PLUS.');
        end
        if isnumeric(addend)
            if mod(addend, 1) ~= 0
                error('jl:InvalidInput', 'addend must be a whole number; got %f', addend);
            end
            %TODO: Handle NaN and Inf addends
            if any(isnan(addend) | isinf(addend))
                error('jl:InvalidInput', 'Inf and NaN addends are not supported');
            end
            out = this;
            out.fixedDate = out.fixedDate + int32(addend);
        else
            error('jl:InvalidInput', 'moda.Date + %s is not supported', class(addend));
        end
        end
        
        function out = minus(this, subtrahend)
        %MINUS Subtract a duration from this date.

        %TODO: add @calendarDuration support
        %TODO: consider making this just do `add(this, -1 * subtrahend)`
        if ~isa(this, 'moda.Date')
            error('jl:InvalidInput', 'A moda.Date must be the left-hand argument to MINUS.');
        end
        if isnumeric(subtrahend)
            if mod(subtrahend, 1) ~= 0
                error('jl:InvalidInput', 'subtrahend must be a whole number; got %f', subtrahend);
            end
            %TODO: Handle NaN and Inf addends
            if any(isnan(subtrahend) | isinf(subtrahend))
                error('jl:InvalidInput', 'Inf and NaN subtrahends are not supported');
            end
            out = this;
            out.fixedDate = out.fixedDate - int32(subtrahend);
        elseif isa(subtrahend, 'moda.Date')
            out = double(this.fixedDate - subtrahend.fixedDate);
            if any(isinf(subset(this, ':')) | isinf(subset(subtrahend, ':')))
                error('Subtraction of Inf values is not supported');
            end
            out(isnan(this) | isnan(subtrahend)) = NaN;
        else
            error('jl:InvalidInput', 'moda.Date - %s is not supported', class(subtrahend));
        end
        end
        
        function out = isnan(this)
        %ISNAN True for Not-a-Number.
        out = this.fixedDate == moda.Date.nanVal;
        end
        
        function out = isnat(this)
        %ISNAT Alias for ISNAN.
        %
        % This method exists for compatibility with @datetime and isnat().
        out = isnan(this);
        end
        
        function out = isinf(this)
        %ISINF True for Infinity.
        out = this.fixedDate == moda.Date.negInfVal  ...
            | this.fixedDate == moda.Date.posInfVal;
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
        out = numel(this.fixedDate);
        end
        
        function out = ndims(this)
        %NDIMS Number of dimensions.
        out = ndims(this.fixedDate);
        end
        
        function out = isempty(this)
        %ISEMPTY True for empty array.
        out = isempty(this.fixedDate);
        end
        
        function out = isscalar(this)
        %ISSCALAR True if input is scalar.
        out = isscalar(this.fixedDate);
        end
        
        function out = isvector(this)
        %ISVECTOR True if input is a vector.
        out = isvector(this.fixedDate);
        end
        
        function out = iscolumn(this)
        %ISCOLUMN True if input is a column vector.
        out = iscolumn(this.fixedDate);
        end
        
        function out = isrow(this)
        %ISROW True if input is a row vector.
        out = isrow(this.fixedDate);
        end
        
        function out = ismatrix(this)
        %ISMATRIX True if input is a matrix.
        out = ismatrix(this.fixedDate);
        end
        
        function this = reshape(this, varargin)
        %RESHAPE Reshape array.
        this.fixedDate = reshape(this.fixedDate, varargin{:});
        end
        
        function this = squeeze(this, varargin)
        %SQUEEZE Remove singleton dimensions.
        this.fixedDate = squeeze(this.fixedDate, varargin{:});
        end
        
        function this = circshift(this, varargin)
        %CIRCSHIFT Shift positions of elements circularly.
        this.fixedDate = circshift(this.fixedDate, varargin{:});
        end
        
        function this = permute(this, varargin)
        %PERMUTE Permute array dimensions.
        this.fixedDate = permute(this.fixedDate, varargin{:});
        end
        
        function this = ipermute(this, varargin)
        %IPERMUTE Inverse permute array dimensions.
        this.fixedDate = ipermute(this.fixedDate, varargin{:});
        end
        
        function this = repmat(this, varargin)
        %REPMAT Replicate and tile array.
        this.fixedDate = repmat(this.fixedDate, varargin{:});
        end
        
        function this = ctranspose(this, varargin)
        %CTRANSPOSE Complex conjugate transpose.
        this.fixedDate = ctranspose(this.fixedDate, varargin{:});
        end
        
        function this = transpose(this, varargin)
        %TRANSPOSE Transpose vector or matrix.
        this.fixedDate = transpose(this.fixedDate, varargin{:});
        end
        
        function [this, nshifts] = shiftdim(this, n)
        %SHIFTDIM Shift dimensions.
        if nargin > 1
            this.fixedDate = shiftdim(this.fixedDate, n);
        else
            [this.fixedDate,nshifts] = shiftdim(this.fixedDate);
        end
        end
        
        function out = cat(dim, varargin)
        %CAT Concatenate arrays.
        args = varargin;
        for i = 1:numel(args)
            if ~isa(args{i}, 'moda.Date')
                args{i} = moda.Date(args{i});
            end
        end
        out = args{1};
        fieldArgs = cellfun(@(obj) obj.fixedDate, args, 'UniformOutput', false);
        out.fixedDate = cat(dim, fieldArgs{:});
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
            out = size(this.fixedDate);
        else
            out = size(this.fixedDate, dim);
        end
        end
        
        function out = eq(a, b)
        %EQ == Equal.
        if ~isa(a, 'moda.Date')
            a = moda.Date(a);
        end
        if ~isa(b, 'moda.Date')
            b = moda.Date(b);
        end
        tf = a.fixedDate == b.fixedDate;
        out = tf;
        tfNan = isnan(a) | isnan(b);
        out(tfNan) = false;
        end
        
        function out = lt(a, b)
        %LT < Less than.
        if ~isa(a, 'moda.Date')
            a = moda.Date(a);
        end
        if ~isa(b, 'moda.Date')
            b = moda.Date(b);
        end
        out = false(size(a));
        tfUndecided = true(size(out));
        % Check field fixedDate
        lhs = a.fixedDate(tfUndecided);
        rhs = b.fixedDate(tfUndecided);
        tfThisStep = lhs < rhs;
        out(tfUndecided) = tfThisStep;
        % Check NaN flags
        tfNan = isnan(a) | isnan(b);
        out(tfNan) = false;
        end
        
        function out = gt(a, b)
        %GT > Greater than.
        if ~isa(a, 'moda.Date')
            a = moda.Date(a);
        end
        if ~isa(b, 'moda.Date')
            b = moda.Date(b);
        end
        out = false(size(a));
        tfUndecided = true(size(out));
        % Check field fixedDate
        lhs = a.fixedDate(tfUndecided);
        rhs = b.fixedDate(tfUndecided);
        tfThisStep = lhs > rhs;
        out(tfUndecided) = tfThisStep;
        % Check NaN flags
        tfNan = isnan(a) | isnan(b);
        out(tfNan) = false;
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
        
        if ~isa(a, 'moda.Date')
            a = moda.Date(a);
        end
        if ~isa(b, 'moda.Date')
            b = moda.Date(b);
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
        if ~isa(a, 'moda.Date')
            a = moda.Date(a);
        end
        if ~isa(b, 'moda.Date')
            b = moda.Date(b);
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
        propertyValsA = {a.fixedDate};
        propertyTypesA = cellfun(@class, propertyValsA, 'UniformOutput',false);
        isAllNumericA = all(cellfun(@isnumeric, propertyValsA));
        propertyValsA = cellfun(@(x) x(:), propertyValsA, 'UniformOutput',false);
        if nargin == 1
            if isAllNumericA && isscalar(unique(propertyTypesA))
                % Properties are homogeneous numeric types; we can use them directly 
                keysA = cat(2, propertyValsA{:});
            else
                % Properties are heterogeneous or non-numeric; resort to using a table
                propertyNames = {'fixedDate'};
                keysA = table(propertyValsA{:}, 'VariableNames', propertyNames);
            end
        else
            propertyValsB = {b.fixedDate};
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
                propertyNames = {'fixedDate'};
                keysA = table(propertyValsA{:}, 'VariableNames', propertyNames);
                keysB = table(propertyValsB{:}, 'VariableNames', propertyNames);
            end
        end
        end
    
    end
    
    methods (Access=private)
    
        function this = subsasgnParensPlanar(this, s, rhs)
        %SUBSASGNPARENSPLANAR ()-assignment for planar object
        if ~isa(rhs, 'moda.Date')
            rhs = moda.Date(rhs);
        end
        this.fixedDate(s.subs{:}) = rhs.fixedDate;
        end
        
        function out = subsrefParensPlanar(this, s)
        %SUBSREFPARENSPLANAR ()-indexing for planar object
        out = this;
        out.fixedDate = this.fixedDate(s.subs{:});
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

