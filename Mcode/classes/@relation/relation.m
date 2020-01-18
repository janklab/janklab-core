classdef relation < jl.util.Displayable
    %RELATION A tabular structure of relational data
    %
    % A relation is an object that holds multiple named columns of data in a form
    % informed by relational theory. A relation object is like a SQL table or
    % result set.
    %
    % The relation class's behavior is inspired by the work of E. F. Codd and C.
    % J. Date, in particular, Date's "An Introduction to Database Systems" and
    % "Database in Depth".
    %
    % Relation overrides .-indexing (subsref()) to provide column indexing, so you
    % must use the "foo(r)" method invocation syntax instead of "r.foo()" when
    % working with a relation "r".
    %
    % Relation is very similar to the Matlab table. Notable differences are:
    %  * Relation supports arbitrary column names, not just valid Matlab
    %    variable names.
    %  * Relation supports custom display of user-defined types in column data,
    %    using the dispstrs() method.
    %  * Relation uses relation-y/SQL-y names for its operations.
    %  * JOIN variations are distinguished by a wider variety of method names
    %    instead of options on fewer methods.
    %  * Relation does not have RowNames.
    %  * Relation does scalar expansion when assigning to new columns.
    
    
    % Developer's notes:
    %
    % The term "col" is used as shorthand for "column" throughout the source code
    % for this class.
    
    properties
        % Column names
        colNames {mustBeCellstr} = {}
        % Column data, stored as a cell vector of row vectors
        colData cell = {}
    end
    
    methods
        out = subsref(this, s)
        this = subsasgn(this, s, b)
    end
    
    methods
        
        function this = relation(varargin)
        %RELATION Create a new relation
        %
        % obj = relation()
        % obj = relation(x)
        % obj = relation(colNames, colData)
        %
        % obj = relation(x)
        %
        % Converts other data types to a relation. x may be a:
        %  * table
        if nargin == 0
            return;
        elseif nargin == 1
            x = varargin{1};
            if isa(x, 'relation')
                this = x;
                return;
            elseif isa(x, 'table')
                s = table2struct(x, 'ToScalar',true);
                colNames = fieldnames(s);
                colData = struct2cell(s);
                this = relation(colNames, colData);
            end
        elseif nargin == 2
            [colNames, colData] = varargin{:};
            mustBeA(colNames, 'cellstr');
            if isempty(colNames)
                colNames = reshape(colNames, [1 0]);
            end
            mustBeVector(colNames);
            colNames = colNames(:)';
            mustBeA(colData, 'cell');
            mustBeVector(colData);
            for i = 1:numel(colData)
                if isempty(colData{i})
                    colData{i} = reshape(colData{i}, [0 1]);
                end
            end
            colData = colData(:)';
            if isempty(colData)
                colData = reshape(colData, [1 0]);
            end
            this.colNames = colNames;
            this.colData = colData;
            this.validate();
        end
        end
        
        function out = table(this)
        %TABLE Convert to Matlab table
        %
        % Column names that are invalid variable names are converted to valid
        % variable names. A warning is raised when this happens.
        varNames = cellfun(@matlab.lang.makeValidName, this.colNames, ...
            'UniformOutput',false);
        varNames = matlab.lang.makeUniqueStrings(varNames);
        if ~isequal(varNames, this.colNames)
            warning('jl:relation:NameCoercion', ['Some column names were not '...
                'valid variable names. They were munged when converting to table.']);
        end
        out = table(this.colData{:}, 'VariableNames', varNames);
        end
        
        function validate(this)
        %VALIDATE Validate this against class invariants
        if ~isequal(size(this.colNames), size(this.colData))
            error('colNames and colData must be the same size');
        end
        if ~iscellstr(this.colNames)
            error('colNames must be cellstr');
        end
        [uCols,Indx] = unique(this.colNames);
        if numel(uCols) < numel(this.colNames)
            badCols = this.colNames;
            badCols(Indx) = [];
            badCols = unique(badCols);
            error('duplicate column names: %s', strjoin(badCols, ', '));
        end
        for i = 1:numel(this.colData)
            mustBeVector(this.colData{i}, sprintf('colData{%d}', i));
            if size(this.colData{i}, 2) > 1
                error('Column data must be column vectors; got %s for column %s', ...
                    sizestr(this.colData{i}), i);
            end
        end
        end
        
        function out = dispstrs(this)
        %DISPSTRS Custom display strings.
        out = cell(size(this));
        for i = 1:numel(out)
            if this(i).ncols == 0
                out{i} = sprintf('relation: %d cols x %d rows', this(i).ncols,...
                    this(i).nrows);
            else
                out{i} = sprintf('relation: %d cols x %d rows. Cols: %s', this(i).ncols,...
                    this(i).nrows, strjoin(this(i).colNames, ', '));
            end
        end
        end
        
        function out = colnames(this)
        %COLNAMES Get this' column names.
        out = this.colNames;
        end
        
        function out = coldata(this)
        %COLDATA Get this' column data.
        out = this.colData;
        end
        
        function out = ncols(this)
        %NCOLS Number of columns.
        out = numel(this.colNames);
        end
        
        function out = nrows(this)
        %NROWS Number of rows.
        if isempty(this.colData)
            out = 0;
        else
            out = numel(this.colData{1});
        end
        end
        
        function out = prettyprint(this)
        %PRETTYPRINT Display this in a tabular format
        if this.ncols == 0
            out = 'Empty relation (0 cols)';
            return;
        end
        colStrs = cell(size(this.colData));
        colWidths = NaN(size(this.colData));
        for i = 1:this.ncols
            colStrs{i} = dispstrs(this.colData{i});
            colWidths(i) = max(strlen([this.colNames(i); colStrs{i}]));
        end
        colWidths = max(colWidths, 3);
        dataStrs = cat(2, colStrs{:});
        fmt = sprintf('  %%-%ds  ', colWidths);
        outLines = cell(1, this.nrows + 2);
        outLines{1} = sprintf(fmt, this.colNames{:});
        dashes = cell(size(this.colNames));
        for i = 1:this.ncols
            % Box drawing character that works in command window
            horiz = char(9472);
            dashes{i} = repmat(horiz, [1 colWidths(i)]);
        end
        outLines{2} = sprintf(fmt, dashes{:});
        for iRow = 1:this.nrows
            rowStrs = dataStrs(iRow,:);
            outLines{2 + iRow} = sprintf(fmt, rowStrs{:});
        end
        out = strjoin(outLines, LF);
        if nargout == 0
            disp(out);
            clear out
        end
        end
        
        function out = getcol(this, col)
        %GETCOL Get data for a column
        if isnumeric(col)
            out = this.colData{col};
        elseif ischar(col)
            [tf,loc] = ismember(col, this.colNames);
            if ~tf
                error('No such column: %s', col);
            end
            out = this.colData{loc};
        else
            error('jl:InvalidInput', 'Invalid type for col: %s', class(col));
        end
        end
        
        function this = setcol(this, col, data)
        %SETCOL Set values for a column, adding the column if necessary
        data = reshapeEmptyColVector(data);
        if isscalar(data)
            data = repmat(data, [this.nrows 1]);
        end
        if ~isequal(size(data), [this.nrows 1])
            error('Inconsistent dimensions');
        end
        if isnumeric(col)
            if col > this.ncols
                error('Column index out of range');
            end
            ixCol = col;
        elseif ischar(col)
            [tf,loc] = ismember(col, this.colNames);
            if tf
                ixCol = loc;
            else
                this.colNames{end+1} = col;
                ixCol = numel(this.colNames);
            end
        end
        this.colData{ixCol} = data;
        end
        
        % Relational operations
        
        function out = orderby(this, columns)
        %ORDERBY Sort the rows in this based on column values.
        %
        % out = orderby(obj)
        % out = orderby(obj, columns)
        %
        % Sorts the rows in obj based on column value ordering.
        %
        % If called with only one argument, sorts based on all columns.
        %
        % Columns (double or cellstr) is a list of column names or indexes to
        % sort on, in order of precedence. If it is empty, then no sorting will
        % be performed.
        %
        % The columns used for ordering must support the sort() function.
        if nargin < 2
            columns = 1:ncols(this);
        end
        colIxs = resolveColumns(this, columns);
        % We'll use a radix sort. It's an easy implementation, and it's defined
        % in terms of sort() on the underlying column data
        out = this;
        for iCol = numel(colIxs):-1:1
            ixCol = colIxs(iCol);
            [~,ix] = sort(out.colData{ixCol});
            out = reorderRows(out, ix);
        end
        end
        
        function out = restrict(this, condition)
        %RESTRICT Subset by rows.
        %
        % out = restrict(this, condition)
        %
        % Subsets (and possibly reorders) this relation by row.
        %
        % Condition is the condition to restrict on. It may be one of:
        %  * A logical or numeric index vector, corresponding to rows
        %  * (Nothing else is implemented yet. In the future, this will support
        %     expressions using column names as variables.)
        if islogical(condition) || isnumeric(condition)
            out = reorderRows(this, condition);
        else
            error('jl:InvalidInput', 'Invalid condition type: %s', class(condition));
        end
        end
        
        function out = project(this, columns)
        %PROJECT Subset by columns.
        %
        % out = project(obj, columns)
        %
        % Columns (double, cellstr) is a list of column names or indexes to
        % subset to.
        colIxs = resolveColumns(this, columns);
        out = this;
        out.colNames = out.colNames(colIxs);
        out.colData = out.colData(colIxs);
        end
        
        function out = projectAway(this, columns)
        %PROJECTAWAY Subset by columns, removing named columns
        %
        % out = projectAway(obj, columns)
        %
        % This is the inverse of project(): the identified columns are removed,
        % and all other columns are kept.
        %
        % Columns (double, cellstr) is a list of column names or indexes to
        % subset to.
        colIxs = resolveColumns(this, columns);
        keepIx = 1:ncols(this);
        keepIx(colIxs) = [];
        out = this;
        out.colNames = this.colNames(keepIx);
        out.colData = this.colData(keepIx);
        end
        
        function out = rename(this, columns, newNames)
        %RENAME Rename columns
        %
        % out = rename(this, renameMap)
        % out = rename(this, columns, newNames)
        %
        % Renames the given columns.
        %
        % ColMap (cell) is an n-by-2 cellstr with the original column names in
        % column 1, and the new column names in column 2.
        if nargin == 2
            renameMap = columns;
            columns = renameMap(:,1);
            newNames = columns(:,2);
        end
        newNames = cellstr(newNames);
        out = this;
        colIxs = resolveColumns(this, columns);
        out.colNames(colIxs) = newNames;
        out.validate();
        end
        
        function out = projectRename(this, colMap)
        %PROJECTRENAME Project and rename at the same time
        %
        % out = projectRename(this, colMap)
        %
        % Projects down to a set of specified columns, and then renames them.
        % This is a convenience method that is a combination of the project()
        % and rename() operations.
        %
        % ColMap (cell) is an n-by-2 cellstr with the original column names in
        % column 1, and the new column names in column 2.
        %
        % This is projected down to the columns identified in colMap(:,1), and
        % then those columns are renamed to the corresponding names on
        % colMap(:,2).
        
        oldColNames = colMap(:,1);
        newColNames = colMap(:,2);
        out = project(this, oldColNames);
        out = rename(out, oldColNames, newColNames);
        end
        
        function out = groupby(this, groupCols, groupSpec)
        %GROUPBY SQL-style grouping/summarize operation
        % out = groupby(tbl, groupCols, groupSpec)
        %
        % Tbl is the table object to group.
        %
        % GroupCols (cellstr) is the list of group columns. These correspond to the
        % columns listed after "GROUP BY" in SQL SELECT statement.
        %
        % GroupSpec (cell) is an n-by-3 cell array specifying the aggregations to do
        % within the groups. It is in the form:
        %  { OutCols, AggregateFcn, InCols }
        % Where:
        %  OutCols - char or cellstr list of new columns to create from the argouts of
        %     AggregateFcn
        %  AggregateFcn - a function handle to the function to do the aggregation
        %  InCols - list of column names whose data will be passed to the inputs of
        %     AggregateFcn
        %
        % Examples:
        %
        % [s,p,sp] = jl.util.relations.supplierPartsExample;
        % prettyprint(groupby(s, {'City'}, {'Count',@numel,'Status'}))
        % prettyprint(groupby(sp, {'SNum'}, {
        %     'NParts', @numel, 'PNum'
        %     'TotalQty', @sum, 'Qty'
        %     }));
        
        %TODO: Write a fast jndx2jndxs function
        
        ixGroupCols = resolveColumns(this, groupCols);
        
        % Let's be cheap and just use Matlab table's findgroups; hopefully it's
        % well-optimized
        g = project(this, ixGroupCols);
        proxyTable = table(g.colData{:}, 'VariableNames', sprintfv('c%d', 1:ncols(g)));
        [groupid,groupvalsTable] = findgroups(proxyTable);
        nGroups = max(groupid);
        groupvals = relation(groupvalsTable);
        groupvals.colNames = g.colNames;
        
        for iFcn = 1:size(groupSpec, 1)
            groupSpec{iFcn, 1} = cellstr(groupSpec{iFcn, 1});
            groupSpec{iFcn, 3} = cellstr(groupSpec{iFcn, 3});
        end
        outColNames = cat(2, groupSpec{:,1});
        nOutCols = numel(outColNames);
        outVals = cell(1, nOutCols);
        for iGroup = 1:nGroups
            tfInGroup = groupid == iGroup;
            rGroup = restrict(this,tfInGroup);
            outOffset = 0;
            for iFcn = 1:size(groupSpec, 1)
                [outCols,aggregateFcn,inCols] = groupSpec{iFcn,:};
                argins = cell(numel(inCols), 1);
                for iIn = 1:numel(argins)
                    argins{iIn} = getcol(rGroup, inCols{iIn});
                end
                argouts = cell(size(outCols));
                [argouts{:}] = aggregateFcn(argins{:});
                for iOut = 1:numel(argouts)
                    outVals{outOffset+iOut}(end+1) = argouts{iOut};
                end
                outOffset = outOffset + numel(argouts);
            end
        end
        
        out = groupvals;
        for iOut = 1:nOutCols
            out = setcol(out, outColNames{iOut}, outVals{iOut}(:));
        end
        
        end
        
        function out = distinct(this)
        %DISTINCT Subset to distinct row values
        %
        % out = distinct(this)
        %
        % Subsets this to a set of rows with distinct values, removing
        % duplicates from the input. May or may not reorder rows.
        
        % Okay, now we're at the hard parts. We need a method that computes
        % proxy keys for arbitrary-typed column values.
        
        proxyKeys = relation.proxyKeys(this);
        
        [~,ix] = unique(proxyKeys, 'rows');
        
        out = restrict(this, ix);
        end
        
        function out = unionall(this)
        %UNIONALL Merge/union relations, keeping all values
        %
        % out = unionall(this)
        %
        % Merges the data of all the relation objects in this to a single
        % relation object.
        %
        % This may be a nonscalar array of relations. All elements of it must
        % have the same column names, and cat-compatible column types.
        cols = this(1).colNames;
        for i = 2:numel(this)
            if ~isequal(this(i).colNames, cols)
                error('jl:relation:Mismatch', 'Inconsistent column names');
            end
        end
        out = this(1);
        for iObj = 2:numel(this)
            for iCol = 1:ncols(this(1))
                out.colData{iCol} = [out.colData{iCol}; this(iObj).colData{iCol}];
            end
        end
        end
        
        function out = naturaljoin(A, B)
        %NATURALJOIN Natural inner join.
        %
        % out = naturaljoin(A, B)
        A = relation(A);
        B = relation(B);
        mustBeScalar(A);
        mustBeScalar(B);
        
        commonCols = intersect(A.colNames, B.colNames);
        aKeys = project(A, commonCols);
        bKeys = project(B, commonCols);
        [proxyKeysA, proxyKeysB] = relation.proxyKeys(aKeys, bKeys);
        [keysA, keysB] = jl.algo.rowKeysToScalarProxyKeys(proxyKeysA, proxyKeysB);
        
        % Need to do an ismember test, but keep all indexes of all matches, for
        % N-to-N matching. This should be a fast generic function.
        % In the mean time, just use a loop. This is gross for performance, but
        % easy to code and understand.
        
        tmp = {};
        for iRowA = 1:nrows(A)
            tfMatch = keysA(iRowA) == keysB;
            matchingB = restrict(B, tfMatch);
            left = reprows(restrict(A, iRowA), nrows(matchingB));
            right = projectAway(matchingB, commonCols);
            combined = splice(left, right);
            tmp{iRowA} = combined; %#ok<AGROW>
        end
        
        tmp = cat(1, tmp{:});
        out = unionall(tmp);
        end
        
        function out = outerjoin(A, B)
        %OUTERJOIN Full outer join.
        out = outerjoinImpl(A, B, true, true);
        end

        function out = leftouterjoin(A, B)
        %LEFTOUTERJOIN Left outer join.
        out = outerjoinImpl(A, B, true, false);
        end
        
        function out = rightouterjoin(A, B)
        %RIGHTOUTERJOIN Right outer join.
        out = outerjoinImpl(A, B, false, true);
        end
        
        % Matlab type support
        function out = outerjoinFillRecord(this)
        outColNames = this.colNames;
        outColData = cell(size(outColNames));
        for i = 1:numel(outColNames)
            fill = relation.outerjoinFillValue(this.colData{i});
            outColData{i} = fill;
        end
        out = relation(outColNames, outColData);
        end
        
    end
    
    methods (Access = private)
        
        function out = outerjoinImpl(A, B, keepLeft, keepRight)
        %OUTERJOINIMPL Implementation for outer joins
        A = relation(A);
        B = relation(B);
        mustBeScalar(A);
        mustBeScalar(B);
        
        commonCols = intersect(A.colNames, B.colNames);
        aKeys = project(A, commonCols);
        bKeys = project(B, commonCols);
        [proxyKeysA, proxyKeysB] = relation.proxyKeys(aKeys, bKeys);
        [keysA, keysB] = jl.algo.rowKeysToScalarProxyKeys(proxyKeysA, proxyKeysB);
        
        fillA = outerjoinFillRecord(projectAway(A, commonCols));
        fillB = outerjoinFillRecord(projectAway(B, commonCols));
        
        tmp = {};
        for iRowA = 1:nrows(A)
            tfMatch = keysA(iRowA) == keysB;
            if any(tfMatch)
                % inner case: matching rows
                matchingB = restrict(B, tfMatch);
                left = reprows(restrict(A, iRowA), nrows(matchingB));
                right = projectAway(matchingB, commonCols);
                combined = splice(left, right);
                tmp{end+1} = combined; %#ok<AGROW>
            else
                % left outer case
                if keepLeft
                    left = restrict(A, iRowA);
                    right = fillB;
                    combined = splice(left, right);
                    tmp{end+1} = combined; %#ok<AGROW>
                end
            end
        end
        if keepRight
            for iRowB = 1:nrows(B)
                tfMatch  = keysB(iRowB) == keysA;
                if any(tfMatch)
                    % NOP; this was already picked up in the last loop
                    continue;
                end
                left = fillA;
                right = restrict(B, iRowB);
                combined = splice(left, right);
                tmp{end+1} = combined; %#ok<AGROW>
            end
        end
        
        tmp = cat(1, tmp{:});
        out = unionall(tmp);
        
        end
        
        function out = splice(this, other)
        %SPLICE Merge horizontally
        out = this;
        out.colNames = [this.colNames other.colNames];
        out.colData = [this.colData other.colData];
        out.validate();
        end
        
        function out = reorderRows(this, ix)
        %REORDERROWS Reorder row data based on an index vector
        out = this;
        for i = 1:out.ncols
            out.colData{i} = out.colData{i}(ix);
        end
        end
        
        function out = resolveColumns(this, columns)
        %RESOLVECOLUMNS Resolve column names/indexes to indexes
        if isnumeric(columns)
            out = columns;
        elseif ischar(columns) || iscellstr(columns) || isstring(columns)
            columns = cellstr(columns);
            [tf,loc] = ismember(columns, this.colNames);
            if ~all(tf)
                error('jl:InvalidInput', 'Columns not present in relation: %s', ...
                    strjoin(columns(~tf), ', '));
            end
            out = loc;
        else
            error('jl:InvalidInput', 'columns must be numeric indexes or cellstr names, but got %s', ...
                class(columns));
        end
        end
    end
    
    methods (Static = true)
        
        function out = outerjoinFillValue(val)
        %OUTERJOINFILLVALUE Fill value to use for missing records
        
        % Special cases for known types
        if isnumeric(val)
            if isa(val, 'double')
                out = NaN;
            elseif isa(val, 'single')
                out = single(NaN);
            elseif isa2(val, 'integer')
                out = feval(class(val), 0);
            else
                % Unknown type: fall through to the general case
                % NOP
            end
        elseif iscell(val)
            if iscellstr(val)
                out = {''};
            else
                out = {[]};
            end
        elseif isstruct(val)
            fields = fieldnames(val);
            cell2struct(cell(numel(fields),1), fields)
        else
            % General case: infer fill value from array expansion filling or
            % constructor behavior
            if isempty(val)
                % Unfortunately, we can't expand an array to get an implicit fill
                % value, because we don't have a scalar value to populate the last
                % element with. Fall back to using the zero-arg constructor for that
                % class
                out = feval(class(val));
            else
                % Use the value that is implicitly filled during array expansion
                x = val(1);
                x(3) = val(1);
                out = x(2);
            end
        end
        
        % Validation
        if ~isscalar(out)
            error('jl:relation:OuterJoinFillInference', ...
                ['Failed to determine a fill value for type %s: '
                'inferred value was not scalar: got a %s %s'], ...
                class(val), sizestr(val), class(val));
        end
        end
        
        function out = ofVariables(varargin)
        %OFVARIABLES Create a relation from variables
        %
        % out = relation.ofVariables(a, b, c, ...)
        %
        % Creates a new relation from a set of variables holding column data. Each
        % variable's inputname becomes a column name, and its contents become that
        % column's data.
        %
        % Examples:
        %
        % name = {'Alice','Bob','Carol'}';
        % id = [ 1 2 345 ]';
        % r = relation.ofVariables(name, id);
        colData = {};
        colNames = {};
        for i = nargin:-1:1
            colNames{i} = inputname(i);
            x = reshapeEmptyColVector(varargin{i});
            mustBeVector(x, 'column input');
            colData{i} = x(:);
        end
        out = relation(colNames, colData);
        end
        
        function out = ofCell(c, colNames)
        %OFCELL Create a relation from a 2-D cell array
        
        % Cheat and just use cell2table logic
        t = cell2table(c);
        r = relation(t);
        if nargin > 1
            r.colNames = colNames;
        end
        out = r;
        end
        
        function out = ofCellVector(c)
        %OFCELLVECTOR Create a relation from a vector of column data vectors
        colNames = sprintfv('C%d', 1:numel(c));
        out = relation(colNames, c);
        end
        
    end
    
    methods (Access = private)
        function out = reprows(this, n)
        %REPROWS Replicate rows
        out = this;
        for iCol = 1:ncols(this)
            out.colData{iCol} = repmat(this.colData{iCol}, [n 1]);
        end
        end
    end
    
    methods (Static, Access = private)
        function [proxyKeysA,proxyKeysB] = proxyKeys(A, B)
        %PROXYKEYS Compute proxy keys for relations
        %
        % A and B must be scalar relations with the same column names, and
        % compatible column types.
        mustBeScalar(A);
        mustBeA(A, 'relation');
        if nargin == 1
            proxyKeysA = NaN(nrows(A), ncols(A));
            for i = 1:ncols(A)
                proxyKeysA(:,i) = identityProxy(A.colData{i});
            end
        else
            mustBeScalar(B);
            mustBeA(B, 'relation');
            proxyKeysA = NaN(nrows(A), ncols(A));
            proxyKeysB = NaN(nrows(B), ncols(B));
            for i = 1:ncols(A)
                [proxyKeysA(:,i), proxyKeysB(:,i)] = identityProxy(A.colData{i}, B.colData{i});
            end
        end
        end
    end
    
end

function x = reshapeEmptyColVector(x)
%RESHAPEEMPTYCOLVECTOR Reshapes empty input to be a column vector
if isempty(x)
    x = reshape(x, [0 1]);
end
end

