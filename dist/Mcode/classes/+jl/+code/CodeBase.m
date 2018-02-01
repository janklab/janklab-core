classdef CodeBase
    %CODEBASE Analyzes an Mcode codebase
    
    properties
        % Paths to the code roots of this code base
        paths = {};
        % CodeRoot objects for the code roots
        codeRoots jl.code.internal.CodeRoot
    end
    
    methods
        function this = CodeBase(paths)
        if nargin == 0
            return;
        end
        if ischar(paths)
            paths = regexp(paths, ':', 'split');
        end
        mustBeCellstr(paths);
        this = jl.code.CodeBase;
        this.paths = paths(:);
        for i = 1:numel(paths)
            [~,label] = fileparts(paths{i});
            this.codeRoots(i) = jl.code.internal.CodeRoot(paths{i}, label);
        end
        end
        
        function out = analyze(this)
        %ANALYZE List the things that are defined in this codebase        
        if isempty(this.paths)
            out = table;
            return;
        end
        reports = repmat(jl.code.CodeBaseReport, size(this.codeRoots));
        for i = 1:numel(this.paths)
            reports(i) = this.codeRoots(i).analyze();
        end
        out = merge(reports);
        end
    end
    
    methods (Static)
        function out = ofUserCodeOnMatlabPath()
        p = regexp(path, ':', 'split');
        p = p(:);
        paths = {};
        for i = 1:numel(p)
            if ~startsWith(p{i}, matlabroot)
                paths{end+1} = p{i}; %#ok<AGROW>
            end
        end
        out = jl.code.CodeBase.ofPaths(paths);
        end
        
        function out = ofMatlabPath()
        out = jl.code.CodeBase.ofPaths(path);
        end
        
        function out = ofMatlabItself()
        p = regexp(path, ':', 'split');
        p = p(:);
        paths = {};
        for i = 1:numel(p)
            if startsWith(p{i}, matlabroot)
                paths{end+1} = p{i}; %#ok<AGROW>
            end
        end
        out = jl.code.CodeBase.ofPaths(paths);
        end
        
        function out = ofPaths(paths)
        if ischar(paths)
            paths = regexp(paths, ':', 'split');
        end
        paths = ignoreNonexistentPaths(paths);
        out = jl.code.CodeBase(paths);
        end
    end
    
end

function out = ignoreNonexistentPaths(paths)
out = {};
for i = 1:numel(paths)
    if isfolder(paths{i})
        out{end+1} = paths{i}; %#ok<AGROW>
    end
end
end