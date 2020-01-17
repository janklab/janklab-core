classdef localdate
	%LOCALDATE A calendar date
	%
	% A calendar date without a time zone in the ISO-8601 calendar system.
	%
	% A LOCALDATE represents an entire calendar day, as opposed to a specific instant
	% in time. A LOCALDATE has no time zone or time of day components. It is
	% useful for storing things such as birthdays, holidays, or business days.
	%
	% TODO: Add support for datenums and strings in relational operations. I think
	% this can be done by just promoting/converting all relop inputs to localdate,
	% and making sure the conversion is well-defined for datetimes.
	%
	% See also:
	% datetime, duration, jl.time.localtime, jl.time.duration
	
	% Open questions:
	% How should < > <= >= comparisons between localdate and datetime work?
	% E.g. does jl.time.localdate('3/1/2015') come before datetime('3/1/2015 01:00')?
	
	% @planarprecedence(date)
	
	properties (Constant, GetAccess='public')
		iso8601Format = 'yyyy-MM-dd';
	end
	
	properties (Constant, Access='protected')
		defaultDateFormat = 'dd-mmm-yyyy'
	end
	
	properties (Access='protected')
		% Count of days from the Matlab epoch date, as double (i.e. datenum).
		% Constrained to never have fractional value.
		date double = NaN; % @planar
	end
	
	methods
		function this = localdate(in, varargin)
			%LOCALDATE Create a localdate array.
			%
			% d = jl.time.localdate
			% d = jl.time.localdate(relativeDay)
			% d = jl.time.localdate(datenum)
			% d = jl.time.localdate(DateStrings)
			% d = jl.time.localdate(DateStrings, 'InputFormat',infmt)
			% d = jl.time.localdate(Y, M, D)
			%
			% The zero-arg constructor returns a NaT value, unlike the zero-arg
			% datetime() constructor, which returns the current time. I'm not sure
			% if the inconsistency is worth it, but the intent is that uninitialized
			% values will be filled in with placeholders, instead of defaulting to
			% now.
			%
			% RelativeDay (char) may be 'now', 'yesterday', 'today', or 'tomorrow'.
			%
			% See also: jl.time.localdate.NaT, jl.time.localdate.today
			
			if nargin == 0
				return;
			elseif nargin == 1
				if isa(in, 'jl.time.localdate')
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
					error('jl:InvalidInput', ...
						'jl.time.localdate(in) is not defined for type %s',...
						class(in));
				end
			elseif nargin == 3
				date = datenum(datetime(in, varargin{1}, varargin{2}));
			else
				error('jl:InvalidInput', 'invalid number of arguments');
			end
			tfHasTime = ~isnan(date) & ~isinf(date) & mod(date, 1) ~= 0;
			if any(tfHasTime(:))
				error('jl:InvalidInput', ...
					'jl.time.localdate(in) input may not have time of day');
			end
			this.date = date;
		end
		
		function disp(this)
			%DISP Custom display.
			if isscalar(this)
				if isnat(this)
					out = 'NaT';
				elseif isinf(this.date)
					out = num2str(this.date);
				else
					out = datestr(this, jl.time.localdate.defaultDateFormat);
				end
			else
				out = sprintf('%s %s', size2str(size(this)), class(this));
			end
			disp(out);
		end
		
		function this = set.date(this, newValue)
			mustBeValidDateValue(newValue);
			this.date = newValue;
		end
		
		function out = eps(this)
			%EPS Precision of time representation at this value.
			out = jl.time.duration(eps(this.date));
		end
		
		function out = datestr(this, varargin)
			%DATESTR Convert to datestr.
			out = datestr(this.date, varargin{:});
		end
		
		function out = datetime(this)
			%DATETIME Convert to datetime, at midnight at the start of the day.
			%
			% Converts this to a datetime whose value is that of midnight at the start
			% of this calendar day, and has no TimeZone.
			out = datetime(this.date, 'ConvertFrom', 'datenum');
		end
		
		function out = datenum(this)
			%DATENUM Convert to datenum, at midnight at the start of the day.
			out = this.date;
		end
		
		function out = datevec(this)
			%DATEVEC Convert to datevec, at midnight at the start of the day.
			out = datevec(this.date);
		end
		
		function out = cellstr(this)
			%CELLSTR Convert to cellstr.
			strs = datestr(this, jl.time.localdate.defaultDateFormat);
			out = reshape(cellstr(strs), size(this));
		end
		
		function out = char(this)
			%CHAR Convert to char array.
			out = datestr(this);
		end
		
		function out = minus(A, B)
			%MINUS Difference between two localdates.
			A = jl.time.localdate(A);
			B = jl.time.localdate(B);
			out = jl.time.duration(A.date - B.date);
		end
		
		function out = plus(A, B)
			%PLUS Add a duration to a localdate.
			%
			% A + B
			%
			% A is converted to a jl.time.localdate, and B is converted to a
			% jl.time.duration. If the result contains fractional days, it is
			% an error.
			A = jl.time.localdate(A);
			B = jl.time.duration(B);
			out = jl.time.localdate(A.date + B.time);
		end
		
		% Component and conversion methods
		
		function [y,m,d] = ymd(this)
			%YMD year, month, and day numbers.
			[y,m,d] = ymd(datetime(this));
		end
		
		function y = year(this, kind)
			%YEAR Year numbers of localdates.
			if nargin == 1
				y = year(datetime(this));
			else
				y = year(datetime(this), kind);
			end
		end
		
		function out = quarter(this)
			%QUARTER Quarter numbers of localdates.
			out = quarter(datetime(this));
		end
		
		function out = month(this, kind)
			%MONTH Month numbers or names of localdates.
			if nargin == 1
				out = month(datetime(this));
			else
				out = month(datetime(this), kind);
			end
		end
		
		function out = week(this, kind)
			%WEEK Week numbers of localdates.
			if nargin == 1
				out = week(datetime(this));
			else
				out = week(datetime(this), kind);
			end
		end
		
		function out = day(this, kind)
			%DAY Day numbers or names of localdates.
			if nargin == 1
				out = day(datetime(this));
			else
				out = day(datetime(this), kind);
			end
		end
		
		function tf = isweekend(this)
			%ISWEEKEND True for localdates occurring on a weekend.
			tf = isweekend(datetime(this));
		end
		
		function tf = isnat(this)
			%ISNAT True for localdates that are Not-a-Time.
			tf = isnan(this.date);
		end
		
		function tf = isnan(this)
			%ISNAN True for localdates that are Not-a-Time.
			tf = isnan(this.date);
		end
		
		function out = toJavaLocalDates(this)
			%TOJAVALOCALDATES Convert this to java.time.LocalDate[].
			out = javaArray('java.time.LocalDate', numel(this));
			for i = 1:numel(this)
				out(i) = this(i).toJavaLocalDate();
			end
		end
		
		function out = toJavaLocalDate(this)
			%TOJAVALOCALDATE Convert this to java.time.LocalDate.
			mustBeScalar(this);
			dv = datevec(this.date);
			out = java.time.LocalDate.of(dv(1), dv(2), dv(3));
		end
		
		function out = withTimeOfDay(this, timeOfDay)
			%WITHTIMEOFDAY Combine with a localtime to create a datetime
			%
			% out = withTimeOfDay(this, timeOfDay)
			%
			% TimeOfDay (jl.time.localtime) is the local wall time.
			%
			% Returns a zoneless datetime.
			
			timeOfDay = jl.time.localtime(timeOfDay);
			out = datetime(this.date + timeOfDay.time, 'ConvertFrom', 'datenum');
		end
	end
	
	methods (Static = true)
		
		function out = today()
			%TODAY The current date
			out = jl.time.localdate(floor(now));
		end
		
		function out = now()
			%NOW The current date
			out = jl.time.localdate.today();
		end
		
		function out = NaT(sz)
			%NAT Create Not-a-Time localdates
			if nargin < 1; sz = [1 1]; end
			out = jl.time.localdate(NaN(sz));
		end
		
		function out = fromJavaLocalDate(jdate)
			%FROMJAVALOCALDATE Convert from Java Time LocalDate
			if isempty(jdate)
				out = jl.time.localdate.NaT;
			elseif isa(jdate, 'java.time.LocalDate')
				out = jl.time.localdate(jdate.getYear(), jdate.getMonthValue(), ...
					jdate.getDayOfMonth());
			elseif isa(jdate, 'java.time.LocalDate[]')
				out = repmat(jl.time.localdate, size(jdate));
				for i = 1:numel(jdate)
					out_i = jl.time.localdate.fromJavaLocalDate(jdate(i));
					out.date(i) = out_i.date;
				end
			else
				error('jl:InvalidInput', 'Invalid input type: %s', class(jdate));
			end
		end
	end
	
	methods
		function out = isequal(varargin)
			%ISEQUAL True if localdate arrays are equal
			proxies = jl.time.localdate.getEqProxies(varargin{:});
			out = isequal(proxies{:});
		end
		
		function out = isequaln(varargin)
			%ISEQUAL True if localdate arrays are equal, treating NaT elements as equal
			proxies = jl.time.localdate.getEqProxies(varargin{:});
			out = isequaln(proxies{:});
		end
		
	end
	
	methods (Static = true, Access = 'private')
		function varargout = getCmpProxies(varargin)
			%GETCMPPROXIES Get proxy values for use in relational comparisons
			varargout = cell(size(varargin));
			for i = 1:numel(varargin)
				x = varargin{i};
				if isa(x, 'jl.time.localdate')
					y = x.date;
				elseif isa(x, 'datetime')
					y = datenum(x);
				elseif isnumeric(x)
					y = x;
				else
					error('jl:InvalidInput', 'Cannot compare a %s to a jl.time.localdate',...
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
				if isa(x, 'jl.time.localdate')
					varargout{i} = x.date;
				else
					error('jl:InvalidInput', ...
						'Cannot compare a %s to a jl.time.localdate',...
						class(x));
				end
			end
		end
		
	end
	
	%%%%% START PLANAR-CLASS BOILERPLATE CODE %%%%%
	
	% This section contains code auto-generated by Janklab's genPlanarClass.
	% Do not edit code in this section manually.
	% Do not remove the "%%%%% START/END .... %%%%%" header or footer either;
	% that will cause the code regeneration to break.
	% To update this code, re-run jl.code.genPlanarClass() on this file.
	
	methods
		
		function out = size(this)
			%SIZE Size of array.
			out = size(this.date);
		end
		
		function out = numel(this)
			%NUMEL Number of elements in array.
			out = numel(this.date);
		end
		
		function out = ndims(this)
			%NDIMS Number of dimensions.
			out = ndims(this.date);
		end
		
		function out = isempty(this)
			%ISEMPTY True for empty array.
			out = isempty(this.date);
		end
		
		function out = isscalar(this)
			%ISSCALAR True if input is scalar.
			out = isscalar(this.date);
		end
		
		function out = isvector(this)
			%ISVECTOR True if input is a vector.
			out = isvector(this.date);
		end
		
		function out = iscolumn(this)
			%ISCOLUMN True if input is a column vector.
			out = iscolumn(this.date);
		end
		
		function out = isrow(this)
			%ISROW True if input is a row vector.
			out = isrow(this.date);
		end
		
		function out = ismatrix(this)
			%ISMATRIX True if input is a matrix.
			out = ismatrix(this.date);
		end
		
		function this = reshape(this)
			%RESHAPE Reshape array.
			this.date = reshape(this.date);
		end
		
		function this = squeeze(this)
			%SQUEEZE Remove singleton dimensions.
			this.date = squeeze(this.date);
		end
		
		function this = circshift(this)
			%CIRCSHIFT Shift positions of elements circularly.
			this.date = circshift(this.date);
		end
		
		function this = permute(this)
			%PERMUTE Permute array dimensions.
			this.date = permute(this.date);
		end
		
		function this = ipermute(this)
			%IPERMUTE Inverse permute array dimensions.
			this.date = ipermute(this.date);
		end
		
		function this = repmat(this)
			%REPMAT Replicate and tile array.
			this.date = repmat(this.date);
		end
		
		function this = ctranspose(this)
			%CTRANSPOSE Complex conjugate transpose.
			this.date = ctranspose(this.date);
		end
		
		function this = transpose(this)
			%TRANSPOSE Transpose vector or matrix.
			this.date = transpose(this.date);
		end
		
		function [this, nshifts] = shiftdim(this, n)
			%SHIFTDIM Shift dimensions.
			if nargin > 1
				this.date = shiftdim(this.date, n);
			else
				[this.date,nshifts] = shiftdim(this.date);
			end
		end
		
		function out = cat(dim, varargin)
			%CAT Concatenate arrays.
			args = varargin;
			for i = 1:numel(args)
				if ~isa(args{i}, 'jl.time.localdate')
					args{i} = jl.time.localdate(args{i});
				end
			end
			out = args{1};
			fieldArgs = cellfun(@(obj) obj.date, args, 'UniformOutput', false);
			out.date = cat(dim, fieldArgs{:});
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
		
		function out = eq(a, b)
			%EQ == Equal.
			if ~isa(a, 'jl.time.localdate')
				a = jl.time.localdate(a);
			end
			if ~isa(b, 'jl.time.localdate')
				b = jl.time.localdate(b);
			end
			tf = a.date == b.date;
			out = tf;
		end
		
		function out = lt(a, b)
			%LT < Less than.
			if ~isa(a, 'jl.time.localdate')
				a = jl.time.localdate(a);
			end
			if ~isa(b, 'jl.time.localdate')
				b = jl.time.localdate(b);
			end
			out = false(size(a));
			tfUndecided = true(size(out));
			tfThisStep = a.date(tfUndecided) < b.date(tfUndecided);
			out(tfUndecided) = tfThisStep;
		end
		
		function out = gt(a, b)
			%GT > Greater than.
			if ~isa(a, 'jl.time.localdate')
				a = jl.time.localdate(a);
			end
			if ~isa(b, 'jl.time.localdate')
				b = jl.time.localdate(b);
			end
			out = false(size(a));
			tfUndecided = true(size(out));
			tfThisStep = a.date(tfUndecided) > b.date(tfUndecided);
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
			
			if ~isa(a, 'jl.time.localdate')
				a = jl.time.localdate(a);
			end
			if ~isa(b, 'jl.time.localdate')
				b = jl.time.localdate(b);
			end
			out = NaN(size(a));
			tfUndecided = true(size(out));
			tf = a < b;
			out(tf) = -1;
			tfUndecided(tf) = false;
			tf = a(tfUndecided) == b(tfUndecided);
			nextTest = NaN(size(tf));
			nextTest(tf) = 0;
			out(tfUndecided) = nextTest;
			tfUndecided(tfUndecided) = ~tf;
			tf = a(tfUndecided) > b(tfUndecided);
			nextTest = NaN(size(tf));
			nextTest(tf) = 1;
			out(tfUndecided) = nextTest;
			tfUndecided(tfUndecided) = ~tf; %#ok<NASGU>
		end
		
	end
	
	methods (Access=private)
		
		function this = subsasgnParensPlanar(this, s, rhs)
			%SUBSASGNPARENSPLANAR ()-assignment for planar object
			if ~isa(rhs, 'jl.time.localdate')
				rhs = jl.time.localdate(rhs);
			end
			
			this.date(s.subs{:}) = rhs.date;
		end
		
		function out = subsrefParensPlanar(this, s)
			%SUBSREFPARENSPLANAR ()-indexing for planar object
			out = this;
			out.date = this.date(s.subs{:});
		end
		
	end
	
	%%%%% END PLANAR-CLASS BOILERPLATE CODE %%%%%
	
end

function mustBeValidDateValue(x)
tfValid = isnan(x) | isinf(x) | jl.types.tests.isWhole(x);
if ~all(tfValid)
	error('Invalid date values: %s', ...
		strjoin(jl.util.num2cellstr(x(~tfValid)), ', '));
end
end
