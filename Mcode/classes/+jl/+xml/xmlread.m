function out = xmlread(input, varargin)
% xmlread Read an XML document
%
% out = jl.xml.xmlread(filename)
% out = jl.xml.xmlread(str, 'InputType', 'string')
% out = jl.xml.xmlread(input, 'InputType', InputType)
%
% Reads an XML document from a file or string and parses it into a
% jl.xml.Document object.
%
% Valid InputType values:
%   * 'auto' - auto-detect input type based on its type. Strings are
%              treated as filenames for now, because Matlab doesn't have
%              a distinct File type.
%   * 'file' - input is a filename
%   * 'string' - input is a string, a string or char or java.lang.String

% TODO: Support java.io.InputStream or java.io.Reader as input.
% TODO: Support java.io.File as input.
% TODO: Maybe support URLs?

opts = jl.util.parseOpts(varargin, {'InputType','file'});

mustBeMember(opts.InputType, {'file','string'});

% Read the XML doc into a Java DOM structure
switch opts.InputType
  case 'file'
    jdoc = xmlread(input);
  case 'string'
    % Ugh; have to bounce to a temp file
    % TODO: Replace the xmlread() call here with direct Java calls so we
    % can parse the string in-memory.
    tempFile = [tempname '.xml'];
    str = string(input);
    jl.io.spew(tempFile, str);
    jdoc = xmlread(tempFile);
    delete(tempFile);
end

% Convert the DOM structure into jl.xml objects

domConverter = jl.xml.JavaDomConverter;
out = domConverter.ofJavaDomDocument(jdoc);

end