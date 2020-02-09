classdef Workbook < jl.office.excel.Workbook
  % An Excel 2007 format Workbook
  
  % TODO: Chart support (done through DrawingPatriarch)
  % TODO: PivotTable/PivotCache support
  % TODO: CalculationChain support
  % TODO: get/setCellFormulaValidation
  % TODO: external links (ExternalLinksTable)
  % TODO: getTable/XSSFTable
  % TODO: Macro support
  % TODO: OLE stuff
  
  properties
  end
  
  methods (Static)
    
    function out = createNew()
        j = org.apache.poi.xssf.usermodel.XSSFWorkbook();
        out = jl.office.excel.xlsx.Workbook(j);
    end
    
  end
  
  methods
    
    function this = Workbook(jObj)
      if nargin == 0
        return
      end
      mustBeA(jObj, 'org.apache.poi.xssf.usermodel.XSSFWorkbook');
      this.j = jObj;
    end
    
    function save(this, file)
      %SAVE Write this workbook out to a file in .xlsx format
      %
      % save(obj, file)
      %
      % file (char, str) is the path to the file to write out to. Overwrites any
      % existing file.
      %
      % Throws an error if the write operation fails for any reason.
      
      pid = feature('getpid');
      tmpFile1 = sprintf('%s.%d.orig.tmp', file, pid);
      tmpFile2 = sprintf('%s.%d.fixed.tmp', file, pid);
      
      jOutStream = java.io.FileOutputStream(tmpFile1);
      this.j.write(jOutStream);
      jOutStream.close();
      
      % When running under matlab, POI produces bad files with the "xmlns="
      % attribute missing on some elements. (I have no idea why.) So we have to
      % fix them up.
      % See: https://stackoverflow.com/questions/59811366/apache-poi-3-16-creates-invalid-files-when-run-inside-matlab?noredirect=1#comment105804128_59811366
      
      replacements = {
        '<Types>' '<Types xmlns="http://schemas.openxmlformats.org/package/2006/content-types">'
        '<Relationships>' '<Relationships xmlns="http://schemas.openxmlformats.org/package/2006/relationships">'
        '<styleSheet xmlns="http://schemas.openxmlformats.org/spreadsheetml/2006/main">' ...
            [ '<styleSheet xmlns="http://schemas.openxmlformats.org/spreadsheetml/2006/main" ' ...
                'xmlns:mc="http://schemas.openxmlformats.org/markup-compatibility/2006" ' ...
                'mc:Ignorable="x14ac x16r2 xr" ' ...
                'xmlns:x14ac="http://schemas.microsoft.com/office/spreadsheetml/2009/9/ac" ' ...
                'xmlns:x16r2="http://schemas.microsoft.com/office/spreadsheetml/2015/02/main" ' ...
                'xmlns:xr="http://schemas.microsoft.com/office/spreadsheetml/2014/revision">']
        };
      zIn = jl.util.ZipFile(tmpFile1);
      zOut = jl.util.ZipWriter.forFile(tmpFile2);
      zEntries = zIn.getEntries;
      for iEntry = 1:numel(zEntries)
        zEntry = zEntries(iEntry);
        bytes = zIn.getContents(zEntry);
        needToEdit = {'[Content_Types].xml', '_rels/.rels', 'docProps/core.xml' ...
          'xl/_rels/workbook.xml.rels', 'xl/styles.xml'};
        if ismember(zEntry.name, needToEdit)
          str = native2unicode(bytes, 'UTF-8')';
          for iRep = 1:size(replacements, 1)
            str = strrep(str, replacements{iRep,1}, replacements{iRep,2});
          end
          bytes = unicode2native(str, 'UTF-8');
        end
        zEntryOut = jl.util.ZipEntry(zEntry.name);
        if ~ismissing(zEntry.comment)
          zEntryOut.comment = zEntry.comment;
        end
        extra = zEntry.getExtra;
        if ~isempty(extra)
          zEntryOut.setExtra(extra);
        end
        if ~isnat(zEntry.creationTime)
          zEntryOut.creationTime = zEntry.creationTime;
        end
        if ~isnat(zEntry.lastAccessTime)
          zEntryOut.lastAccessTime = zEntry.lastAccessTime;
        end
        zOut.writeEntry(zEntryOut, bytes);
      end
      zIn.close;
      zOut.close;
      delete(tmpFile1);
      movefile(tmpFile2, file);
    end

    function out = createCellStyle(this)
      out = jl.office.excel.xlsx.CellStyle(this, this.j.createCellStyle);
    end

    function out = createFont(this)
      out = jl.office.excel.xlsx.Font(this.j.createFont);
    end
    
    function out = createName(this)
      out = jl.office.excel.xlsx.Name(this.j.createName);
    end
    
    function out = getDataFormatTable(this)
      out = jl.office.excel.xlsx.DataFormatTable(this.j.createDataFormat);
    end
    
    function out = getAllPictures(this)
      list = this.j.getAllPictures;
      out = repmat(jl.office.excel.xlsx.PictureData, [1 list.size]);
      for i = 1:list.size
        out(i) = jl.office.excel.xlsx.PictureData(list.get(i-1));
      end
    end
    
    function out = isDate1904(this)
      out = this.j.isDate1904;
    end
    
  end
  
  methods (Access = protected)
    
    function out = fileFormat(this) %#ok<MANU>
      out = 'xlsx';
    end
        
    function out = wrapSheetObject(this, jObj)
      out = jl.office.excel.xlsx.Sheet(this, jObj);
    end
    
    function out = wrapCellStyleObject(this, jObj)
      out = jl.office.excel.xlsx.CellStyle(this, jObj);
    end
    
    function out = wrapPictureDataObject(this, jObj) %#ok<INUSL>
      out = jl.office.excel.xlsx.PictureData(jObj);
    end
    
    function out = wrapFontObject(this, jObj) %#ok<INUSL>
      out = jl.office.excel.xlsx.Font(jObj);
    end
    
  end
  
end