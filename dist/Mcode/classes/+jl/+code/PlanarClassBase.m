classdef (Abstract) PlanarClassBase
    %PLANARCLASSBASE Abstract base class implementation for planar classes
    %
    % This class provides the logic for structural operations, set
    % operations, and relational operations.
    %
    % Subclasses must implement:
    %   getPlanarFields()
    %   asgnPlanarFields()
    %   promoteArgs()
    %   isnan(), if they support NaN-ability
    %     - This should typically be done with a logical isNaN planar field, or
    %       an in-band test of isnan() on the single field of one-field classes
    % Subclasses should implement:
    %   getFirstPlanarField()  - for speed
    % Subclasses may implement:
    %   getPlanarIdentityFields() - if the identity fields do not include all
    %                  the planar fields
    %   proxyKeys()  - if they have a special proxy key representation distinct
    %                  from their identity field values. (This will be an
    %                  unusual case.)
    
    methods (Access = protected)
        function [out,fieldNames] = getPlanarFields(this) %#ok<MANU>
        %GETPLANARFIELDS Get the values and names of this' planar fields
        %
        % Subclasses must implement this.
        %
        % Returns an n-long cell vector containing the planar field values.
        %
        % Also returns an n-long cell vector holding the names of those
        % planar fields.
        out = {};
        fieldNames = {};
        end
        
        function out = getFirstPlanarField(this)
        %GETFIRSTPLANARFIELD Gets the first planar field
        %
        % This is an optimization that can be called instead of
        % getPlanarFields() when only one field is needed.
        fieldVals = this.getPlanarFields();
        out = fieldVals{1};
        end
        
        function [out,fieldNames] = getPlanarIdentityFields(this)
        %GETPLANARIDENTITYFIELDS Get the values and names of this' identity fields
        %
        % By default, this is the same list of fields as getPlanarFields(),
        % which causes all fields to be considered identity-constituent.
        [out,fieldNames] = this.getPlanarFields();
        end
        
        function this = asgnPlanarFields(this, values) %#ok<INUSD>
        %ASGNPLANARFIELDS Assign values in to planar fields
        %
        % this = asgnPlanarFields(this, values)
        %
        % Values is an n-long cell vector containing the new values for
        % this' planar fields.
        %
        % Subclasses must override this to provide access to their planar
        % fields.
        end
        
        function [outA,outB] = proxyKeys(this, b)
        %PROXYKEYS Proxy keys for this' values
        %
        % Gets a table whose records contain values that are proxies
        % for this' array element values. That is, the table records have
        % the same equivalence and ordering relationships that this'
        % array elements have. 
        %
        % If a second input is present, it must be a member of the same class,
        % and this method produces proxy keys for both objects, which are valid
        % in the same context; that is, they can be used for comparison against
        % each other.
        %
        % The rows of the proxyKeys tables correspond to  the linear-indexed 
        % elements of the inputs.
        %
        % The default implementation is just a table with all of this'
        % planar identity field values as table variables. That should usually be
        % sufficient.
        [fieldVals,fieldNames] = this.getPlanarIdentityFields();
        for i = 1:numel(fieldVals)
            fieldVals{i} = fieldVals{i}(:);
        end
        outA = table(fieldVals{:}, 'VariableNames',fieldNames);
        if nargin > 1
            [fieldValsB,fieldNamesB] = b.getPlanarIdentityFields();
            for i = 1:numel(fieldValsB)
                fieldValsB{i} = fieldValsB{i}(:);
            end
            outB = table(fieldValsB{:}, 'VariableNames',fieldNamesB);
        end
        end
        
        %PROMOTEARGS Promote all inputs to the method dispatch class
        %
        % Subclasses must override this.
        varargout = promoteArgs(varargin);
    end
    
    methods
        
        function out = isnan(this)
        %ISNAN True for Not-a-Number.
        %
        % By default, planar classes are not considered to be NaN. If they
        % are NaN-able, subclasses must override isnan() to provide the
        % NaN-detection logic.
        out = false(size(this));
        end
        
        function out = size(this)
        %SIZE Size of array.
        out = size(this.getFirstPlanarField);
        end
        
        function out = numel(this)
        %NUMEL Number of elements in array.
        out = numel(this.getFirstPlanarField);
        end
        
        function out = ndims(this)
        %NDIMS Number of dimensions.
        out = ndims(this.getFirstPlanarField);
        end
        
        function out = isempty(this)
        %ISEMPTY True for empty array.
        out = isempty(this.getFirstPlanarField);
        end
        
        function out = isscalar(this)
        %ISSCALAR True if input is scalar.
        out = isscalar(this.getFirstPlanarField);
        end
        
        function out = isvector(this)
        %ISVECTOR True if input is a vector.
        out = isvector(this.getFirstPlanarField);
        end
        
        function out = iscolumn(this)
        %ISCOLUMN True if input is a column vector.
        out = iscolumn(this.getFirstPlanarField);
        end
        
        function out = isrow(this)
        %ISROW True if input is a row vector.
        out = isrow(this.getFirstPlanarField);
        end
        
        function out = ismatrix(this)
        %ISMATRIX True if input is a matrix.
        out = ismatrix(this.getFirstPlanarField);
        end
        
        function this = reshape(this, varargin)
        %RESHAPE Reshape array.
        v = this.getPlanarFields;
        for i = 1:numel(v)
            v{i} = reshape(v{i}, varargin{:});
        end
        this = asgnPlanarFields(this, v);
        end
        
        function this = squeeze(this, varargin)
        %SQUEEZE Remove singleton dimensions.
        v = this.getPlanarFields;
        for i = 1:numel(v)
            v{i} = squeeze(v{i}, varargin{:});
        end
        this = asgnPlanarFields(this, v);
        end
        
        function this = circshift(this, varargin)
        %CIRCSHIFT Shift positions of elements circularly.
        v = this.getPlanarFields;
        for i = 1:numel(v)
            v{i} = circshift(v{i}, varargin{:});
        end
        this = asgnPlanarFields(this, v);
        end
        
        function this = permute(this, varargin)
        %PERMUTE Permute array dimensions.
        v = this.getPlanarFields;
        for i = 1:numel(v)
            v{i} = permute(v{i}, varargin{:});
        end
        this = asgnPlanarFields(this, v);
        end
        
        function this = ipermute(this, varargin)
        %IPERMUTE Inverse permute array dimensions.
        v = this.getPlanarFields;
        for i = 1:numel(v)
            v{i} = ipermute(v{i}, varargin{:});
        end
        this = asgnPlanarFields(this, v);
        end
        
        function this = repmat(this, varargin)
        %REPMAT Replicate and tile array.
        v = this.getPlanarFields;
        for i = 1:numel(v)
            v{i} = repmat(v{i}, varargin{:});
        end
        this = asgnPlanarFields(this, v);
        end
        
        function this = ctranspose(this, varargin)
        %CTRANSPOSE Complex conjugate transpose.
        v = this.getPlanarFields;
        for i = 1:numel(v)
            v{i} = ctranspose(v{i}, varargin{:});
        end
        this = asgnPlanarFields(this, v);
        end
        
        function this = transpose(this, varargin)
        %TRANSPOSE Transpose vector or matrix.
        v = this.getPlanarFields;
        for i = 1:numel(v)
            v{i} = transpose(v{i}, varargin{:});
        end
        this = asgnPlanarFields(this, v);
        end
        
        function [this, nshifts] = shiftdim(this, n)
        %SHIFTDIM Shift dimensions.
        if nargin > 1
            v = this.getPlanarFields;
            for i = 1:numel(v)
                v{i} = shiftdim(v{i}, n);
            end
            this = asgnPlanarFields(this, v);
        else
            v = this.getPlanarFields;
            for i = 1:numel(v)-1
                v{i} = reshape(v{i});
            end
            [v{end}, nshifts] = shiftdim(v{end});
            this = asgnPlanarFields(this, v);
        end
        end
        
        function out = cat(dim, varargin)
        %CAT Concatenate arrays.
        args = varargin;
        [args{:}] = promoteArgs(varargin{:});
        out = args{1};
        vs = cellfun(@(obj) obj.getPlanarFields, args, 'UniformOutput', false);
        v_out = cell(size(vs{1}));
        for iField = 1:numel(vs{1})
            fieldArgs = cellfun(@(v) v{iField}, vs, 'UniformOutput', false);
            v_out{iField} = cat(dim, fieldArgs{:});
        end
        out = asgnPlanarFields(out, v_out);
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
        
        function out = eq(a, b)
        %EQ == Equal.
        [a, b] = promoteArgs(a, b);
        fieldsA = a.getPlanarIdentityFields();
        fieldsB = b.getPlanarIdentityFields();
        tf = fieldsA{1} == fieldsB{1};
        for i = 2:numel(fieldsA)
            tf(tf) = fieldsA{i} == fieldsB{i};
        end
        out = tf;
        end
        
        function out = lt(a, b)
        %LT < Less than.
        [a, b] = promoteArgs(a, b);
        fieldsA = a.getPlanarIdentityFields();
        fieldsB = b.getPlanarIdentityFields();
        out = false(size(a));
        tfUndecided = true(size(out));
        % Check each field
        for iField = 1:numel(fieldsA)
            lhs = fieldsA{iField}(tfUndecided);
            rhs = fieldsB{iField}(tfUndecided);
            tfThisStep = lhs < rhs;
            out(tfUndecided) = tfThisStep;
            tfUndecided(tfUndecided) = ~tfThisStep & ~isnan(lhs) & ~isnan(rhs);
        end
        end
        
        function out = gt(a, b)
        %GT > Greater than.
        [a, b] = promoteArgs(a, b);
        fieldsA = a.getPlanarIdentityFields();
        fieldsB = b.getPlanarIdentityFields();
        out = false(size(a));
        tfUndecided = true(size(out));
        % Check each field
        for iField = 1:numel(fieldsA)
            lhs = fieldsA{iField}(tfUndecided);
            rhs = fieldsB{iField}(tfUndecided);
            tfThisStep = lhs > rhs;
            out(tfUndecided) = tfThisStep;
            tfUndecided(tfUndecided) = ~tfThisStep & ~isnan(lhs) & ~isnan(rhs);
        end
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
        
        [a, b] = promoteArgs(a, b);
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
        if ismembersafe('rows', varargin)
            % Neat trick: use unique() on the proxy keys to get a single
            % numeric value that can stand in as a proxy, so we can then use
            % Matlab's unique(..., 'rows') on it.
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
            ixNonnan = find(~tfNaN);
            keys = proxyKeys(nonnans);
            [~,ix] = unique(keys, flags{:});
            out = [subset(nonnans, ix); nans];
            Indx = [ixNonnan(ix); find(tfNaN)];
            if isRow
                out = out';
            end
        end
        end
        
        function [out,Indx] = ismember(a, b, varargin)
        %ISMEMBER True for set member.
        [a, b] = promoteArgs(a, b);
        [proxyA, proxyB] = proxyKeys(a, b);
        if ismembersafe('rows', varargin)
            % Use the same trick as unique()
            [~,proxyIx] = unique([proxyA; proxyB]);
            proxyIxA = reshape(proxyIx(1:numel(a)), size(a));
            proxyIxB = reshape(proxyIx(numel(a)+1:end), size(b));
            [out,Indx] = ismember(proxyIxA, proxyIxB, 'rows');
            tfNanInRow = any(isnan(a), 2);
            out(tfNanInRow) = false;
            Indx(tfNanInRow) = 0;
        else
            [out,Indx] = ismember(proxyA, proxyB);
            tfNanA = isnan(a);
            tfNanB = isnan(b);
            ixNanB = find(tfNanB);
            out(tfNanA) = false;
            Indx(tfNanA) = 0;
            tfMatchedNanB = ismember(Indx, ixNanB);
            out(tfMatchedNanB) = false;
            Indx(tfMatchedNanB) = 0;
            out = reshape(out, size(a));
            Indx = reshape(Indx, size(a));
        end
        end
        
        function [out,Indx] = setdiff(a, b, varargin)
        %SETDIFF Set difference.
        if ismembersafe('rows', varargin)
            error('setdiff(..., ''rows'') is unsupported');
        else
            [tf,~] = ismember(a, b);
            out = subset(a, ~tf);
            Indx = find(~tf);
            [out,ix] = unique(out);
            Indx = Indx(ix);
        end
        end
        
        function [out,ia,ib] = intersect(a, b, varargin)
        %INTERSECT Set intersection.
        if ismembersafe('rows', varargin)
            error('intersect(..., ''rows'') is unsupported');
        else
            [tf,loc] = ismember(a, b);
            out = subset(a, tf);
            ia = find(tf);
            ib = loc(tf);
        end
        end
        
        function [out,ia,ib] = union(a, b, varargin)
        %UNION Set union.
        if ismembersafe('rows', varargin)
            error('union(..., ''rows'') is unsupported');
        else
            [proxyA, proxyB] = proxyKeys(a, b);
            [~,ia,ib] = union(proxyA, proxyB);
            aOut = subset(a, ia);
            bOut = subset(b, ib);
            out = [subset(aOut, ':'); subset(bOut, ':')];
        end
        end
        
    end
    
    methods (Access=private)
        
        function this = subsasgnParensPlanar(this, s, rhs)
        %SUBSASGNPARENSPLANAR ()-assignment for planar object
        [this, rhs] = promoteArgs(this, rhs);
        thisVals = this.getPlanarFields;
        rhsVals = rhs.getPlanarFields;
        for iField = 1:numel(thisVals)
            thisVals{iField}(s.subs{:}) = rhsVals{iField};
        end
        this = this.asgnPlanarFields(thisVals);
        end
        
        function out = subsrefParensPlanar(this, s)
        %SUBSREFPARENSPLANAR ()-indexing for planar object
        out = this;
        planarVals = this.getPlanarFields;
        for iField = 1:numel(planarVals)
            planarVals{iField} = planarVals{iField}(s.subs{:});
        end
        out = out.asgnPlanarFields(planarVals);
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
    
end

function out = ismembersafe(x, c)
%ISMEMBERSAFE A version of ismember that works with mixed-type cells
if ~iscell(x)
    x = { x };
end
for i = 1:numel(c)
    if isequal(x, c(i))
        out = true;
        return;
    end
end
out = false;
end
