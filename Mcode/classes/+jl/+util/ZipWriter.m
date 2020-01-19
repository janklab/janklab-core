classdef ZipWriter < jl.util.DisplayableHandle
  
  properties (SetAccess = private)
    % The underlying java.util.zip.ZipOutputStream object
    jStream
  end
  
  methods (Static)
    function out = forFile(file)
      jFile = java.io.File(file);
      jFileStream = java.io.FileOutputStream(jFile);
      jOutStream = java.io.BufferedOutputStream(jFileStream);
      out = jl.util.ZipWriter(jOutStream);
    end
  end
  
  methods
    
    function this = ZipWriter(jOutStream)
      mustBeA(jOutStream, 'java.io.OutputStream');
      this.jStream = java.util.zip.ZipOutputStream(jOutStream);
    end
    
    function delete(this)
      this.close;
    end
    
    function writeEntry(this, zipEntry, contents)
      mustBeA(zipEntry, 'jl.util.ZipEntry');
      mustBeA(contents, 'uint8');
      this.jStream.putNextEntry(zipEntry.j);
      this.jStream.write(contents, 0, numel(contents));
      this.jStream.closeEntry;
    end
    
    function setLevel(this, level)
      this.jStream.setLevel(level);
    end
    
    function setComment(this, comment)
      this.jStream.setComment(comment);
    end
    
    function setMethod(this, val)
      if ischar(val) || isstring(val)
        switch upper(val)
          case 'DEFLATE'
            jCode = java.util.zip.ZipOutputStream.DEFLATED;
          case 'STORE'
            jCode = java.util.zip.ZipOutputStream.STORED;
          otherwise
            error('jl:InvalidInput', 'Invalid value for method: %s', val)
        end
        this.jStream.setMethod(jCode);
      else
        this.jStream.setMethod(val);
      end
    end
    
    function close(this)
      this.jStream.close;
    end
    
  end
  
end