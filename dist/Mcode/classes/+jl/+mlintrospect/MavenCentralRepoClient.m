classdef MavenCentralRepoClient
    %MAVENCENTRALREPOCLIENT Client for the Maven Central Repo web site/service
    
    properties
        numResults double = 10
        mavenSolrEndpoint char = 'http://search.maven.org/solrsearch';
    end
    
    methods
        function out = searchBySha1(this, sha1)
            %SEARCHBYSHA1 Search the repo for files matching a SHA1 digest
            rslt = webread([this.mavenSolrEndpoint '/select'],...
                'q', sprintf('1:"%s"', sha1), ...
                'rows', num2str(this.numResults), ...
                'wt', 'json');
            out = rslt;
        end
        
        function out = getLatestRelease(this, groupId, artifactId)
            %GETLATESTRELEASE Get latest release for an artifact
            %
            % Returns struct, or empty if artifact was not found.
            d = this.select(struct('g',groupId, 'a',artifactId));
            dd = d.response.docs;
            if isempty(dd)
                out = [];
                return;
            end
            out = struct('version',dd.latestVersion, 'timestamp', ...
                this.timestamp2datetime(dd.timestamp));
        end
        
        function out = timestamp2datetime(~, timestamp)
            %TIMESTAMP2DATETIME Convert an API timestamp to Matlab datetime
            out = datetime(timestamp/1000, 'ConvertFrom', 'posixtime');
        end
        
        function out = selectByCoordinates(this, coords)
            %SELECTBYCOORDINATES Select items by Maven coordinates
            %
            % Coords is a struct that may have the following fields:
            %  g - group ID
            %  a - artifact ID
            %  v - version
            %  p - packaging
            %  l - classifier
            %
            % This search uses all coordinates ("g" for groupId, "a" 
            % for artifactId, "v" for version, "p" for packaging, "l" for classifier) 
            out = this.select(coords);
        end
        
        function out = select(this, queryArgs, serviceArgs)
            %SELECT Generically exposes the select query
            %
            % QueryArgs (struct) is the name/val pairs to put in the "q"
            % query for the select function. Does not limit the number of
            % rows.
            %
            % ServiceArgs (cellstr) is a name/value list of arguments to
            % pass at the service call level.
            %
            % Returns a json object.
            if nargin < 3 || isempty(serviceArgs); serviceArgs = {}; end
            
            keys = fieldnames(queryArgs);
            for i = 1:numel(keys)
                queryEls{i} = sprintf('%s:"%s"', keys{i}, queryArgs.(keys{i}));  %#ok<AGROW>
            end
            queryStr = strjoin(queryEls, ' AND ');
            out = webread([this.mavenSolrEndpoint '/select'], ...
                'q', queryStr, ...
                serviceArgs{:}, ...
                'wt', 'json');
        end
    end
end