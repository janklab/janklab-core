classdef relation
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

	% Developer's notes:
	%
	% The term "col" is used as shorthand for "column" throughout the source code
	% for this class.
	
	properties
		% Column names
		colNames cell
		% Column data, stored as a cell vector of row vectors
		colData cell
	end
	
	methods
		out = subsref(this, s)
		this = subsasgn(this, s, b)
	end
	
	methods
		
		function this = relation(colNames, colData)
		%RELATION Create a new relation
		mustBeType(colNames, 'cellstr');
		if isempty(colNames)
			colNames = reshape(colNames, [1 0]);
		end
		mustBeVector(colNames);
		colNames = colNames(:)';
		mustBeType(colData, 'cell');
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
		end
		end
		
		function out = disp(this)
		%DISP Display object.
		if isscalar(this)
			out = sprintf('relation: %d cols x %d rows. Cols: %s', this.ncols,...
				this.nrows, strjoin(this.colNames, ', '));
		else
			out = sprintf('%s relation', size2str(size(this)));
		end
		if nargout == 0
			disp(out);
			clear out
		end
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
			colWidths(i) = max(strlen([this.colNames{i}; colStrs{i}]));
		end
		colWidths = max(colWidths, 3);
		dataStrs = cat(2, colStrs{:});
		fmt = sprintf('  %%%ds  ', colWidths);
		outLines = cell(1, this.nrows + 2);
		outLines{1} = sprintf(fmt, this.colNames{:});
		dashes = cell(size(this.colNames));
		for i = 1:this.ncols
			dashes{i} = repmat('-', [1 colWidths(i)]);
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
	end
	
	methods (Static = true)
		
		function out = fromVariables(varargin)
		%FROMVARIABLES Create a relation from variables
		%
		% out = relation.fromVariables(a, b, c, ...)
		%
		% Creates a new relation from a set of variables holding column data. Each
		% variable's inputname becomes a column name, and its contents become that
		% column's data.
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
		
	end
	
end

function x = reshapeEmptyColVector(x)
%RESHAPEEMPTYCOLVECTOR Reshapes empty input to be a column vector
if isempty(x)
	x = reshape(x, [0 1]);
end
end

