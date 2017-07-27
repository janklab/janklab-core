classdef duration
    %DURATION A length of wall clock time
    
    properties
        % Duration length, as fractional days
        time double = 0
    end
    
    properties (Constant, Access = private)
        NanosPerDay = 24 * 60 * 60 * 1000000000;
    end
    
    methods
        function this = duration(varargin)
        %DURATION Create a new duration.
        if nargin == 0
            return
        elseif nargin == 1
            arg = varargin{1};
            if isa(arg, 'double')
                this.time = arg;
            else
                error('jl:InvalidInput', 'Invalid argument type');
            end
        end
        end
        
        function disp(this)
        %DISP Custom display.
        if ~isscalar(this)
            dispf('%s %s', size2str(size(this)), class(this));
            return
        end
        x = this.time;
        if isnan(x) || isinf(x)
            str = num2str(x);
            disp(str);
            return
        end
        mySign = sign(x);
        if x < 0
            x = x * -1;
        end
        days = fix(x);
        x = rem(x, 1);
        x = x * 24;
        hours = fix(x);
        x = rem(x, 1);
        x = x * 60;
        minutes = fix(x);
        x = rem(x, 1);
        x = x * 60;
        seconds = fix(x);
        x = rem(x, 1);
        x = x * 1000000000;
        nanos = round(x);
        
        str = num2str(seconds);
        if nanos ~= 0
            str = sprintf('%s.%09d', str, nanos);
        end
        str = [str ' s'];
        if minutes ~= 0
            str = sprintf('%d minutes %s', minutes, str);
        end
        if hours ~= 0
            str = sprintf('%d hours %s', hours, str);
        end
        if days ~= 0
            str = sprintf('%d days %s', days, str);
        end
        if mySign < 0
            str = ['- ' str];
        end
        disp(str);
        end
        
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
            this.time = shiftdim(this.time, n);
        else
            [this.time, nshifts] = shiftdim(this.time);
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
        
        function this = cat(dim, this, b)
        %CAT Concatenate arrays.
        if ~isa(b, class(this))
            error('jl:type_mismatch', 'Cannot concatenate %s with a %s',...
                class(b), class(this));
        end
        this.time = cat(dim, this.time, b.time);
        end
        
        function out = horzcat(this, b)
        %HORZCAT Horizontal concatenation.
        out = cat(2, this, b);
        end
        
        function out = vertcat(this, b)
        %VERTCAT Vertical concatenation.
        out = cat(1, this, b);
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
                    error('jl:type_mismatch', 'Cannot assign %s in to a %s',...
                        class(rhs), class(this));
                end
                if ~isequal(class(rhs), class(this))
                    error('jl:type_mismatch', 'Cannot assign a subclass in to a %s (got a %s)',...
                        class(this), class(rhs));
                end
                this.time(s(1).subs{:}) = rhs.time;
            case '{}'
                error('jl:bad_operation',...
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
                out = this;
                out.time = this.time(s(1).subs{:});
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
        
    end
    
    methods (Static)
        function out = epsFor(x)
        %EPSFOR Precision for date values.
        %
        % out = jl.time.duration.epsFor(x)
        %
        % X (datenum, datetime) is a date value to check the local relative precision of.
        %
        % This method would make more sense as an eps() method on datetime and
        % datenum, but since they're built-in Matlab types, we avoid extending them
        % directly. And datenum isn't even a real type.
        out = jl.time.duration(eps(datenum(x)));
        end
    end
end