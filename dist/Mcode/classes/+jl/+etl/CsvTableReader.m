classdef CsvTableReader < handle
    %CSVTABLEREADER Can read tabular data from CSV files
    %
    % The CsvTableReader can read tabular data from CSV files or other CSV data
    % sources. It is intended as an improvement on Matlab's csvread() function. It
    % provides support for additional column types, including date/time types, column
    % type autodetection, and returning data in a table and supporting heterogeneous
    % column types.
    
    properties
        % The underlying Java implementation object for this reader
        javaReader = net.janklab.etl.csvtable.CsvTableReader
    end
    
    properties (Dependent)
        % Format to use for parsing LOCALDATETIME columns
        localDateTimeFormat
        % Format to use for parsing LOCALDATE columns
        localDateFormat
        % Format to use for parsing LOCALTIME columns
        localTimeFormat
        % How many lines to skip in input before starting to read table data
        lineOffset
        % How many columns to skip on each line
        columnOffset
        % Whether the table has a header row
        hasHeader
        % A list of column names supplied by the client, to use instead of a header
        clientProvidedColNames
        % CSV format options
        csvFormat
        % A map of forced column types to use instead of autodetection
        colTypeMap
    end
    
    methods
        function out = readFile(this, file)
        %READFILE Read from a CSV file.
        this.javaReader.attachFile(file);
        bufs = this.javaReader.read();
        
        data = {};
        for iBuf = 0:bufs.size()-1
            buf = bufs.get(iBuf);
            x = buf.getValues();
            if isa(x, 'java.lang.String[]')
                %TODO: Switch to a more efficient conversion
                mx = cellstr(string(x));
            elseif isa(x, 'java.time.LocalDate[]')
                mx = localdate.fromJavaLocalDate(x);
            elseif isa(x, 'java.time.LocalTime[]')
                mx = localtime.fromJavaLocalTime(x);
            elseif isa(x, 'java.time.LocalDateTime[]')
                mx = jl.time.util.javaLocalDateTime2datetime(x);
            elseif isa(x, 'net.janklab.util.SymbolArrayList')
                mx = symbol(x);
            elseif isnumeric(x)
                mx = x;
            else
                error('Unsupported type coming back from column buffer %d: %s', ...
                    iBuf, class(x));
            end
            data{iBuf+1} = mx; %#ok<AGROW>
        end
        
        colNames = cellstr(char(this.javaReader.getEffectiveColNames()));
        colNames = tablifyColNames(colNames);
        out = table(data{:}, 'VariableNames', colNames);
        end
        
        function setColTypesByName(this, colTypes)
        %SETCOLTYPESBYNAME Set column type mapping by column names
        mustBeCellrec(colTypes);
        for i = 1:size(colTypes, 1)
            [colName,typeName] = colTypes{i,:};
            typeObj = net.janklab.etl.csvtable.ColType.valueOf(upper(typeName));
            if isempty(typeObj)
                error('jl:InvalidInput', 'Unknown column type: %s', typeName);
            end
            this.javaReader.colTypeMap.setTypeByName(colName, typeObj);
        end
        end
        
        function set.localDateTimeFormat(this, fmt)
        %SET.LOCALDATETIMEFORMAT
        %
        % TODO: Add explicit locale support.
        if isequal(fmt, 'auto')
            this.javaReader.localDateTimeFormat = [];
        else
            this.javaReader.localDateTimeFormat ...
                = java.time.format.DateTimeFormatter.ofPattern(fmt);
        end
        end
        
        function out = get.localDateTimeFormat(this)
        fmt = this.javaReader.localDateTimeFormat;
        if isempty(fmt)
            out = 'auto';
        else
            out = char(fmt.toString());
        end
        end
        
        function set.localDateFormat(this, fmt)
        %SET.LOCALDATEFORMAT
        %
        % TODO: Add explicit locale support.
        if isequal(fmt, 'auto')
            this.javaReader.localDateFormat = [];
        else
            this.javaReader.localDateFormat ...
                = java.time.format.DateTimeFormatter.ofPattern(fmt);
        end
        end
        
        function out = get.localDateFormat(this)
        fmt = this.javaReader.localDateFormat;
        if isempty(fmt)
            out = 'auto';
        else
            out = char(fmt.toString());
        end
        end
        
        function set.localTimeFormat(this, fmt)
        %SET.LOCALTIMEFORMAT
        %
        % TODO: Add explicit locale support.
        if isequal(fmt, 'auto')
            this.javaReader.localTimeFormat = [];
        else
            this.javaReader.localTimeFormat ...
                = java.time.format.DateTimeFormatter.ofPattern(fmt);
        end
        end
        
        function out = get.localTimeFormat(this)
        fmt = this.javaReader.localTimeFormat;
        if isempty(fmt)
            out = 'auto';
        else
            out = char(fmt.toString());
        end
        end
        
        function out = get.lineOffset(this)
        out = this.javaReader.lineOffset;
        end
        
        function set.lineOffset(this, lineOffset)
        this.javaReader.lineOffset = lineOffset;
        end
        
        function out = get.columnOffset(this)
        out = this.javaReader.columnOffset;
        end
        
        function set.columnOffset(this, colOffset)
        this.javaReader.columnOffset = colOffset;
        end
        
        function out = get.colTypeMap(this)
        out = this.javaReader.colTypeMap;
        end
        
        function out = get.csvFormat(this)
        out = this.javaReader.csvFormat;
        end
        
        function out = get.hasHeader(this)
        out = this.javaReader.hasHeader;
        end
        
        function set.hasHeader(this, hasHeader)
        this.javaReader.hasHeader = hasHeader;
        end
        
        function out = get.clientProvidedColNames(this)
        out = string(this.javaReader.clientProvidedColNames);
        out = out(:)';
        if isempty(out)
            out = {};
        end
        end
        
        function set.clientProvidedColNames(this, clientProvidedColNames)
        this.javaReader.clientProvidedColNames = clientProvidedColNames;
        end
          
    end
    
end

function out = tablifyColNames(colNames)
    out = regexprep(colNames, '[^a-zA-Z0-9_]', '_');
end
