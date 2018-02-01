classdef CodeRoot
    %CODEROOT Analyzes an Mcode codebase with a single source directory
    
    properties
        % The path to the root of the source tree
        path
        % A label for this code root to distinguish it from others
        label char = '';
    end
    
    methods
        function this = CodeRoot(path, label)
        %CODEROOT Construct a new CodeRoot at a given path
        if nargin == 0
            return;
        end
        path = char(path);
        this.path = path;
        if ~isfolder(path)
            error('Folder not found: %s', path);
        end
        if nargin > 1
            this.label = label;
        end
        end
        
        function out = analyze(this)
        %ANALYZE List the things that are defined in this codebase
        
        % Traverse the code tree
        % Actually, we can use ** now; let's try that
        origDir = pwd();
        RAII.dir = onCleanup(@() cd(origDir));
        cd(this.path);
        mFiles = dir('**/*.m');
        
        infos = [];
        for iFile = 1:numel(mFiles)
            baseFile = mFiles(iFile).name;
            fullPath = [mFiles(iFile).folder '/' baseFile];
            [~,baseName,~] = fileparts(baseFile);
            relativePath = fullPath;
            relativePath(1:numel(this.path)+1) = [];
            % Source code
            % Read the file to see if it's a classdef, function, or script
            info = jl.code.internal.McodeFileParser(fullPath).parse();
            info.Label = this.label;
            info.Name = baseName;
            info.File = relativePath;
            info.FullFile = fullPath;
            info.Package = packageForFile(relativePath);
            info.CheckcodeReport = checkcode(fullPath);
            if isempty(infos)
                infos = info;
            else
                infos(end+1) = info; %#ok<AGROW>
            end
        end
        
        % Assemble results in a table
        if isempty(infos)
            details = table;
        else
            details = struct2table(infos, 'AsArray',true);
            details = details(:, {'Label','File','Type','Package','Name',...
                'NLines','LOC','CommentLines','FullFile','CheckcodeReport', ...
                'ErrorIds'});                
        end
        out = jl.code.CodeBaseReport(details);
        end
    end
end

function out = packageForFile(file)
elems = regexp(file, '/', 'split');
pkgPath = {};
for i = 1:numel(elems)
    if elems{i}(1) == '+'
        pkgPath{end+1} = elems{i}(2:end); %#ok<AGROW>
    else
        break;
    end
end
out = strjoin(pkgPath, '.');
end
