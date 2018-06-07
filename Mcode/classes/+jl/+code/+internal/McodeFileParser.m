classdef McodeFileParser
    %MCODEFILEPARSER A very simple Mcode parser
    %
    % This is a parser that can extract a few pieces of information from an
    % Mcode file. It does not understand the full grammar by any means; just
    % enough to tell things like whether the file looks like a class, function,
    % or script, and so on.
    %
    % This exists just to support jl.code.CodeRoot, not to be useful on its own.
    
    properties
        file
    end
    
    methods
        function this = McodeFileParser(file)
        this.file = file;
        end
        
        function out = parse(this)
        %PARSE Parse the file
        out = struct;
        fid = fopen(this.file);
        txt = fread(fid, '*char');
        txt = txt(:)';
        fclose(fid);
        
        [~,fileName,ext] = fileparts(this.file);
        
        lines = regexp(txt, '\r?\n', 'split');
        out.NLines = numel(lines);
        type = [];
        if isequal([fileName ext], 'Contents.m')
            type = 'Contents';
        end
        nCommentLines = 0;
        nLOC = 0;
        errorIdInfo = {}; % { type, id, lineNum; ... }
        for iLine = 1:numel(lines)
            line = lines{iLine};
            if regexpMatch(line, '^\s*%') || regexpMatch(line, '^\s*$')
                nCommentLines = nCommentLines + 1;
                continue;
            end
            if isempty(type)
                if regexpMatch(line, '^\s*classdef ')
                    type = 'classdef';
                elseif regexpMatch(line, '^\s*function ')
                    type = 'function';
                elseif regexpMatch(line, '^\s*\S')
                    type = 'script';
                end
            end
            % Here we know it's not an empty or comment line
            if ~regexpMatch(line, ' \.\.\.\s*$')
                nLOC = nLOC + 1;
            end
            % Look for warning() and error() identifiers
            [ix,tok] = regexp(line, 'error(\s*''(\w+:[\w:]+)''\s*,', 'once',...
                'match','tokens');
            if ~isempty(ix)
                errorIdInfo = [errorIdInfo; { 'error', tok{1}, iLine }]; %#ok<AGROW>
            end
            [ix,tok] = regexp(line, 'warning(\s*''(\w+:[\w:]+)''\s*,', 'once',...
                'match','tokens');
            if ~isempty(ix)
                errorIdInfo = [errorIdInfo; { 'warning', tok{1}, iLine }]; %#ok<AGROW>
            end
        end
        if isempty(type)
            type = 'script';
        end
        if isempty(errorIdInfo)
            errorIdInfo = table;
        else
            errorIdInfo = cell2table(errorIdInfo, ...
                'VariableNames', {'Type','Id','LineNum'});
        end
        out.Type = type;
        out.CommentLines = nCommentLines;
        out.LOC = nLOC;
        out.ErrorIds = errorIdInfo;
        end
    end
end

function out = regexpMatch(str, pattern)
ix = regexp(str, pattern, 'once');
out = ~isempty(ix);
end