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
%   * 'auto'* - auto-detect input type based on its type. Strings are
%               treated as filenames for now, because Matlab doesn't have
%               a distinct File type.
%   * 'file' - input is a filename
%   * 'string' - input is a string, a string or char or java.lang.String
%
% Valid input types:
%   * string/char (treated as a file name by default)
%   * java.lang.String
%   * java.io.InputStream
%   * org.xml.sax.InputSource
%   * java.io.File

% TODO: Maybe do away with InputType option and detect it entirely based
%       on actual type of input. Except... how do we decide between strings
%       and files?
% TODO: Maybe support URLs?
% TODO: Add options for validation, external DTDs, etc

opts = jl.util.parseOpts(varargin, {'InputType','file'});

mustBeMember(opts.InputType, {'file','string'});

if isequal(opts.InputType, 'auto')
  if isstring(input) || isa(input, 'java.io.File')
    inputType = 'file';
  elseif isa(input, 'java.lang.String')
    inputType = 'string';
  elseif isa(input, 'java.io.InputStream') ...
      || isa(input, 'org.xml.sax.InputSource')
    inputType = 'java';
  else
    error('Could not automatically determine input type (input is a %s)', ...
      class(input));
  end
else
  inputType = opts.InputType;
end

% Read the XML doc into a Java DOM structure

switch inputType
  case 'file'
    jdoc = xmlread(input);
  case 'java'
    % This uses undocumented "advanced" behavior of Matlab's xmlread
    jdoc = xmlread(input);
  case 'string'
    % This uses undocumented "advanced" behavior of Matlab's xmlread
    jstr = java.lang.String(str);
    jByteStream = java.io.ByteArrayInputStream(jstr.getBytes);
    jdoc = xmlread(jByteStream);
end

% Convert the DOM structure into jl.xml objects

domConverter = jl.xml.JavaDomConverter;
out = domConverter.ofJavaDomDocument(jdoc);

end
