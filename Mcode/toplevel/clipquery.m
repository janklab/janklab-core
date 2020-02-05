function out = clipquery
%CLIPQUERY Query the system clipboard for available data
%
% clipquery
% flavors = clipquery
%
% Queries the system clipboard, getting a list of available data "flavors"
% for the data that has been copied to it.
%
% This implementation uses Java AWT's Clipboard mechanism, which influences
% and possibly limits the datatypes that it can see. To support full
% functionality, this will need to be modified to use native clipboard
% APIs, such as the Objective-C NSPasteboard API on macOS or Qt on Linux.
% For now, it's just hanging around as a little demo and a reminder that I
% want to do this later.
%
% Returns a table. If output is not captured, displays it to the console.

toolkit = java.awt.Toolkit.getDefaultToolkit;
cb = toolkit.getSystemClipboard;
%flavors = cb.getAvailableDataFlavors;
tranf = cb.getContents([]);
flavors = tranf.getTransferDataFlavors;
tb = jl.util.TableBuffer({'Flavor', ...
  'MimePrimaryType','MimeSubType','MimeShortType','MimeType', ...
  'JavaClass'});
for i = 1:numel(flavors)
  flav = flavors(i);
  mime = string(flav.getPrimaryType);
  mimeSub = string(flav.getSubType);
  tb = tb.addRow({
    string(flav.getHumanPresentableName)
    mime
    mimeSub
    (mime + "/" + mimeSub)
    string(flav.getMimeType)
    string(flav.getDefaultRepresentationClassAsString)
    }');
end
out = table(tb);
if nargout == 0
  disp(out)
  clear out
end

