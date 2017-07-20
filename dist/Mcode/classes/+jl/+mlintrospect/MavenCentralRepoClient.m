classdef MavenCentralRepoClient
    %MAVENCENTRALREPOCLIENT Client for the Maven Central Repo web site/service
    
    properties
        numResults double = 10
    end
    
    methods
        function out = searchBySha1(this, sha1)
            %SEARCHBYSHA1 Search the repo for files matching a SHA1 digest
            rslt = webread('http://search.maven.org/solrsearch/select',...
                'q', sprintf('1:"%s"', sha1), ...
                'rows', num2str(this.numResults), ...
                'wt', 'json');
            out = rslt;
        end
    end
    
end