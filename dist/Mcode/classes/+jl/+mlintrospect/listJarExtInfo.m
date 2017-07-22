function [out,fullResults] = listJarExtInfo
%LISTJAREXTINFO Get info about the external JARs included with Matlab
%
% [out,fullResults] = jl.mlintrospect.listJarExtInfo
%
% Lists info about all the external (third-party) Java library JARs bundled
% with this distribution of Matlab. This can be used to assess
% compatibility with your own Java code.
%
% This may take a while to run, as it queries external web services for
% information about each JAR file it found.
%
% The info is returned as a table with at least the following variables:
%   * File    - the path of the JAR file, relative to the jarext directory
%   * Title   - the title of the library
%   * Vendor  - the name of the vendor
%   * Version - the version of the library
% The values for any of the columns except File may be blank. All variables
% will be char/cellstr. The fullResults output is a table with even more
% columns, such as:
%   * ImplVer - the implementation version
%   * SpecVer - the specification version
%   * BundleName  - the bundle name
% 
% Returns a table.

mavenClient = jl.mlintrospect.MavenCentralRepoClient;

jarextDir = [matlabroot '/java/jarext'];

% Recursively find all JAR files under jarext
files = findFiles(jarextDir);

iJar = 0;
for iFile = 1:numel(files)
    file = files{iFile};    
    if isempty(regexp(file, '\.jar$', 'once'))
        continue
    end
    iJar = iJar + 1;
    File{iJar} = file;
    
    filePath = [jarextDir '/' file];
    jar = java.util.jar.JarFile(filePath);
    manifest = jar.getManifest;
    
    % SHA1 can be used to search Maven Central Repo for unidentified files
    bytes = org.apache.commons.io.FileUtils.readFileToByteArray(...
        java.io.File(filePath));
    Sha1{iJar} = char(org.apache.commons.codec.digest.DigestUtils.shaHex(bytes));
    
    if isempty(manifest)
        attr = containers.Map;
    else
        attribs = manifest.getMainAttributes();

        % Convert the attributes to something we can work with
        attr = containers.Map;
        entries = attribs.entrySet();
        it = entries.iterator();
        while it.hasNext()
            entry = it.next();
            attr(lower(char(entry.getKey().toString()))) = char(entry.getValue());
        end
    end
    jar.close();
        
    BundleName{iJar} = getAttrib(attr, 'bundle-name'); %#ok<*AGROW>
    BundleVendor{iJar} = getAttrib(attr, 'bundle-vendor');
    BundleVer{iJar} = getAttrib(attr, 'bundle-version');
    ImplTitle{iJar} = getAttrib(attr, 'implementation-title');
    ImplVer{iJar} = getAttrib(attr, 'implementation-version');
    ImplVendor{iJar} = getAttrib(attr, 'implementation-vendor');
    SpecTitle{iJar} = getAttrib(attr, 'specification-title');
    SpecVer{iJar} = getAttrib(attr, 'specification-version');
    SpecVendor{iJar} = getAttrib(attr, 'specification-vendor');
    
    % Search Maven Central for more info
    mvn = mavenClient.searchBySha1(Sha1{iJar});
    if mvn.response.numFound == 0
        MavenGroup{iJar} = '';
        MavenArtifact{iJar} = '';
        MavenVersion{iJar} = '';
        MavenRelDate{iJar} = '';
        MavenLatestVer{iJar} = '';
        MavenLatestDate{iJar} = '';
    else
        MavenGroup{iJar} = mvn.response.docs(1).g;
        MavenArtifact{iJar} = mvn.response.docs(1).a;
        MavenVersion{iJar} = mvn.response.docs(1).v;
        timestamp = datetime(mvn.response.docs(1).timestamp/1000,...
            'ConvertFrom', 'posixtime');
        MavenRelDate{iJar} = datestr(timestamp, 'yyyy-mm-dd');
        latest = mavenClient.getLatestRelease(MavenGroup{iJar}, MavenArtifact{iJar});
        if isempty(latest)
            MavenLatestVer{iJar} = '';
            MavenLatestDate{iJar} = '';
        else
            MavenLatestVer{iJar} = latest.version;
            MavenLatestDate{iJar} = datestr(latest.timestamp, 'yyyy-mm-dd');
        end
            
    end
    
    Title{iJar} = firstNonEmptyStr(BundleName{iJar}, ImplTitle{iJar}, ...
        SpecTitle{iJar}, MavenArtifact{iJar});
    Version{iJar} = firstNonEmptyStr(BundleVer{iJar}, ImplVer{iJar}, ...
        SpecVer{iJar}, MavenVersion{iJar});
    Vendor{iJar} = firstNonEmptyStr(BundleVendor{iJar}, ImplVendor{iJar}, ...
        SpecVendor{iJar}, MavenGroup{iJar});
            
end

fullResults = jl.util.tableutil.tableFromVectors(File, Title, Version, Vendor, ...
    BundleName, BundleVer, BundleVendor,...
    ImplTitle, ImplVer, ImplVendor, SpecTitle, SpecVer, SpecVendor, Sha1, ...
    MavenGroup, MavenArtifact, MavenVersion, MavenRelDate, MavenLatestVer, MavenLatestDate);
out = fullResults(:,{'Title','Vendor','Version','File','MavenGroup','MavenArtifact', ...
    'MavenVersion','MavenRelDate','MavenLatestVer','MavenLatestDate'});

end

function out = firstNonEmptyStr(varargin)
out = firstNonEmpty(varargin{:});
if isempty(out)
    out = '';
end
end

function out = getAttrib(attr, key)
    if attr.isKey(key)
        out = attr(key);
    else
        out = '';
    end
end

function out = findFiles(file)

if ~isdir(file)
    error('File %s is not a directory or does not exist', file);
end
out = findFilesStep(file, '');
out = out(:);

end

function out = findFilesStep(root, rel)

files = {};
p = [ root '/' rel ];
children = dir(p);
children = { children.name };
for i = 1:numel(children)
    child = children{i};
    childRel = ifthen(isempty(rel), child, [rel '/' child]);
    childPath = [ p '/' child ];
    if ismember(child, {'.' '..'})
        continue
    elseif isdir(childPath)
        childFiles = findFilesStep(root, childRel);
        files = [files childFiles]; 
    else
        files{end+1} = childRel; 
    end
end

out = files;

end