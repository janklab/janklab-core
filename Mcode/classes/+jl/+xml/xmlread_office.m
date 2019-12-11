function out = xmlread_office(file)
% xmlread_office Read in the internal XML contents of a MS Office file
%
% out = jl.xml.xmlread_office(file)
%
% Reads a Microsoft Office OpenXML format file (the new Office 2003
% format), pulling in its internal XML data. Will work on .xlsx, .docx,
% .pptx, and other Office 2003 format files.
%
% This function is just a stunt to demonstrate how Janklab's XML stuff can
% be used. It's likely to be removed in the future.
%
% Returns a table with variables:
%   Entry  - (string) relative path to the XML file in the office file
%   Xml    - (jl.xml.Document) XML document read from that file
%   Zsize  - compressed size of file in bytes
%   Size   - uncompressed size of file in bytes
%   Mtime  - internal modification timestamp on this entry (probably
%            not actually useful)
%   ... and maybe some other info columns ...
%
% Examples:
% t = jl.xml.xmlread_office('My Word Doc.docx')
% t.Xml(5).prettyprint

%#ok<*AGROW>

zipFile = java.util.zip.ZipFile(java.io.File(file));
RAII.zipFile = onCleanup(@() zipFile.close);

entries = zipFile.entries;
c = {};
while entries.hasNext
  entry = entries.next;
  name = string(entry.getName);
  if entry.isDirectory
    continue
  end
  istream = zipFile.getInputStream(entry);
  xmlDoc = jl.xml.xmlread(istream);
  istream.close; % dunno if this is necessary
  mtimeLong = entry.getTime; % this is milliseconds since the Unix epoch
  mtime = datetime(mtimeLong/1000, 'ConvertFrom','POSIX');
  c = [c; { name xmlDoc entry.getCompressedSize entry.getSize mtime }];
end

zipFile.close;

out = cell2table(c, 'VariableNames', {'Entry', 'Xml', ...
  'Zsize', 'Size', 'Mtime'});
out.Properties.Description = sprintf('Office file: %s', file);
