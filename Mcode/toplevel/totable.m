function out = totable(varargin)
% "To Table": convenience function for creating table arrays from other arrays.
%
% out = totable(aTable)
% out = totable(aDataset)
% out = totable(aStruct)
% out = totable(aThing)
%
% out = totable(variableNames, aMatrix)
% out = totable(variableNames, variableTypes, aMatrix)
%
% DESCRIPTION
%
% Totable() is a function for creating arrays in a more convenient manner,
% or with nicer-looking source code, than with the standard Matlab TABLE,
% CELL2TABLE, ARRAY2TABLE, and related functions. (In my opinion,
% anyway.) Its various calling forms work around particular shortcomings
% with those standard Matlab functions. IMHO, while there are well-defined
% conversions from just about any Matlab array type to a table array, the
% conversion is inconvenient because:
%   a) What you get by calling table(x) on various types often isn't what
%   you want when converting a matrix,
%   b) Conversion from table-like datatypes such as datasets and some
%   struct arrays requires calling different input-type-specific functions,
%   and
%   c) The CELL2TABLE and ARRAY2TABLE functions put the variable names in a
%   trailing name/value argument pair, so the source code sometimes doesn't
%   read nicely.
%
% The main advantages totable has are:
%   * More readable arrangement of source code when converting cell
%     literal expressions to tables.
%   * Generic calling against table, dataset, cell, and numeric arrays,
%     instead of having to test the input type and call one of
%     DATASET2TABLE, CELL2TABLE, ARRAY2TABLE, etc. specifically.
%   * More "natural" (IMHO) conversions of some forms of matrices.
%
% USAGE
%
% Which of the various calling forms is invoked depends on both the number
% and type of input arguments. The various forms are:
%
% out = totable(aTable), where aTable is a table array, returns the input
% table array unmodified. For now, this uses `isa(x, 'table')` to perform
% the test, but may be modified to use `istable()` instead.
%
% out = totable(aDataset), where aDataset is a dataset array, converts the
% input to a table using dataset2table(aDataset).
%
% out = totable(aStruct), where aStruct is a struct (including nonscalar
% struct arrays), converts the input to a table using
% struct2table(aStruct).
%
% out = totable(aThing), where aThing is not a table, dataset, or struct, is
% currently an error. This behavior may change in the future to
% automatically call the `table(aThing)` conversion method when aThing is
% an object which defines a `table` method, and maybe additional
% things. But will probably not add support for generic conversion of
% matrixes of primitive or arbitrary types.
%
% out = totable(variableNames, aMatrix), where variableNames is a char,
% cellstr, or string array, and aMatrix is a cell, numeric, string,
% datetime, or categorical matrix (2-D array), converts aMatrix to a table
% using the appropriate CELL2TABLE or ARRAY2TABLE function. CELL2TABLE is
% always used for cells. This calling form may be expanded to accept other
% types of arrays for aMatrix; this is TBD.
%
% NOTE: The behavior of the 2- and 3-argument forms where aMatrix is a cell
% array may change in the future to automatically convert all resulting
% cellstr table variables to string arrays. This doesn't really make sense
% from a type definition perspective, but I really like to write my
% "string" literals using single quotes, and this behavior would make that
% convenient.
%
% out = totable(variableNames, variableTypes, aMatrix), where variableNames
% and aMatrix are as above, and variableTypes is a char, cellstr, or string
% array, works just like the `totable(variableNames, aMatrix)` calling
% form, but in addition, after aMatrix has been converted to a table, each
% variable is converted to the datatype specified in variableTypes{i} (if
% it is not already of that type, using the standard constructor or
% conversion function of that name, with the following exceptions:
%   * Type names missing, "", and "any" are treated as allowing any input
%     type, and cause no type test or conversion to be formed. (They do
%     *not* convert that column to cell.)
%   * Type name "datetime" is converted using the Janklab TODATETIME
%     function instead of the Matlab DATETIME function.
%     *  This behavior is subject to change, to support DATETIME overrides
%        by user-defined classes.
%   * Type "cell" is only supported for detection, not conversion.
%     * This behavior will change in the future to do the conversion in a
%       complex manner to be defined later, probably involving "smart"
%       selection amongst the CELL, NUM2CELL, CELLSTR, and related
%       functions.
%   * Type name "cellstr" is detected using ISCELLSTR instead of ISA, and
%     is converted using CELLSTR. Note that this may have performance
%     impacts.
%   * Type "table" is converted using TOTABLE instead of Matlab's TABLE.
%     * This behavior is subject to change, to support TABLE overrides by
%       user-defined classes.
%   * Type "numeric" is supported for type checking, but not conversion
%     (yet).
%     * In the future, this will probably change to introduce a default
%     conversion for the "numeric" type even if Matlab doesn't define one
%     itself, probably converting to double.
% If variableTypes is shorter than the number of variables, variables with
% no corresponding variableTypes element are not subject to conversion.
%
% NOTE: The type names in variableTypes are *not* checked to see if they
% are actually valid or defined Matlab types before attempting the check
% and conversion. This means that any value in variableTypes may end up
% causing a function of that name to be invoked. This may be a correctness
% and security issue. Sanitize or validate the values you are passing in to
% the variableTypes argument.
%
% Behavior for struct inputs is not defined yet, but will probably be added
% soon, and will use STRUCT2TABLE in some form.
%
% Other combinations of input types may also work without raising an error,
% but that is undocumented and undefined behavior due to quirks of
% totable's argument handling logic. That behavior may change at any time,
% either to become an error, or to do something different. This
% implementation intentionally does not error out all undefined
% combinations of inputs, because those run-time type tests may be
% expensive.
%
% Examples:
%
% % Type conversions
%
% x = [1:3]';
% y = [2:2:6]';
%
% tblIn = table(x, y)
% tbl1 = totable(tblIn)
%
% s = struct('x', x, 'y', y)
% tbl2 = totable(s)
%
% % Nicely-formatted literal expressions
%
% tbl3 = totable({
%     'Foo', 'Bar'}, {
%     "A"    2
%     "B"    420
%     "Cat"  3.1415
%     })
%
% tbl4 = totable({
%     'X'    'Y'        'Z'    }, [
%     1       3.2443    400000
%     3       7.37458    10000
%     7      16.32      999999
%     ])
%
% % Variable type conversion
%
% tbl5 = totable({
%     'Name'     'HeightCm' 'Birthdate'   'VoterReg'    }, {
%     ''         'int16'    'datetime'    'categorical' }, {
%     "Alice"    177        '1993-03-18'  'Democrat'
%     "Bob"      193        '1994-08-06'  'Independent'
%     "Carol"    183        '1982-12-25'  'Independent'
%     "Dave"     181        '1968-04-17'  'Republican'
%     })
%
% See also:
% TABLE CELL2TABLE ARRAY2TABLE STRUCT2TABLE DATASET2TABLE
% TODATETIME

if nargin == 1
    [x] = varargin{:};
    if isa(x, 'table')
        out = x;
    elseif isa(x, 'dataset')
        out = dataset2table(x);
    elseif isstruct(x)
        out = struct2table(x);
    else
        error('Unsupported type for totable(x): %s', class(x));
    end
elseif nargin == 2
    [varNames, x] = varargin{:};
    out = totableFromMatrix(x, varNames, {});
elseif nargin == 3
    [varNames, varTypes, x] = varargin{:};
    out = totableFromMatrix(x, varNames, varTypes);
else
    error('Too many inputs for totable(): %d', nargin);
end

end

function out = totableFromMatrix(aMatrix, variableNames, variableTypes)

mustBeStringy(variableNames);
variableNames = string(variableNames);
mustBeStringy(variableTypes);
variableTypes = string(variableTypes);

if iscell(aMatrix)
    tbl = cell2table(aMatrix, 'VariableNames', variableNames);
elseif isnumeric(aMatrix) || isstring(aMatrix)
    tbl = array2table(aMatrix, 'VariableNames', variableNames);
else
    error('Unsupported type for input aMatrix: %s', class(aMatrix));
end

if isempty(variableTypes)
    out = tbl;
    return
end
if numel(variableTypes) > width(tbl)
    error(['Input variableTypes is too long for converted table: %d types ' ...
        'vs. %d variables'], ...
        numel(variableTypes), width(tbl));
end

out = tbl;
for iVar = 1:numel(variableTypes)
    wantType = variableTypes(iVar);
    if ismissing(wantType) || wantType == "" || wantType == "any"
        continue
    end
    origVarVal = tbl.(iVar);
    if wantType == "cellstr"
        if iscellstr(origVarVal) %#ok<ISCLSTR>
            continue
        end
    elseif wantType == "numeric"
        if isnumeric(origVarVal)
            continue
        end
    elseif isa(origVarVal, wantType)
        continue
    end
    try
        switch wantType
            case "cellstr"
                newVarVal = cellstr(origVarVal);
            case "datetime"
                newVarVal = todatetime(origVarVal);
            case "cell"
                error('Conversion of variables to cell using totable() is not supported.');
            case "table"
                newVarVal = totable(origVarVal);
            otherwise
                newVarVal = feval(wantType, origVarVal);
        end
        out.(iVar) = newVarVal;
    catch err
        varName = tbl.Properties.VariableNames{iVar};
        error("totable(): Failed converting variable %d ('%s') to %s from %s: %s", ...
            iVar, varName, wantType, class(origVarVal), err.message);
    end
end

end

