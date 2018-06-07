classdef CodeBaseReport
    % A report produced by CodeBase
    %
    % This is a report that contains info on the code inside a CodeBase.
    
    properties
        details table
    end
    
    methods
        function this = CodeBaseReport(details)
        %CODEBASEREPORT Construct a new CodeBaseReport
        if nargin == 0
            return;
        end
        this.details = details;
        end
        
        function out = merge(this)
        %MERGE Merge multiple reports together
        d = {};
        for i = 1:numel(this)
            d{i} = this(i).details; %#ok<AGROW>
        end
        allDetails = cat(1, d{:});
        out = jl.code.CodeBaseReport(allDetails);
        end
        
        function out = lineTotals(this)
        %LINETOTALS Line and file count totals
        out = struct;
        d = this.details;
        out.NFiles = size(d, 1);
        out.NLines = sum(d.NLines);
        out.LOC = sum(d.LOC);
        out.CommentLines = sum(d.CommentLines);
        end
        
        function [out,t] = errorIdInfo(this)
        %ERRORIDINFO Info on error and warning IDs used in the code base
        %
        % [out,t] = errorIdInfo(obj)
        %
        % Returns a table with summary info about the error and warning IDs that
        % appear in this code base.
        %
        % Also returns t, a table containing details about where those
        % identifiers appeared, which can be used to map them back to files.
        c = {};
        d = this.details;
        for i = 1:size(d,1)
            file = d{i, 'FullFile'}{1};
            errorInfo = d{i, 'ErrorIds'}{1};
            if ~isempty(errorInfo)
                errorInfo.File = repmat({file}, [size(errorInfo,1) 1]);
                errorInfo.Count = ones(size(errorInfo,1), 1);
                c{end+1} = errorInfo;
            end
        end
        if isempty(c)
            out = table;
        else
            t = cat(1, c{:});
            t = sortrows(t, {'Type','Id','File','LineNum'});
            out = jl.util.tables.groupby(t, {'Type','Id'}, ...
                {'Count', @sum, 'Count'
                 'NFiles', @(x) numel(unique(x)), 'File'});
            t.Count = [];
        end
        end
    end
    
end