classdef ZipFile < jl.util.DisplayableHandle
  
  properties (SetAccess = private)
    % The underlying java.util.zip.ZipFile object
    j
  end
  
  methods
    
    function this = ZipFile(file)
      jFile = java.io.File(file);
      this.j = java.util.zip.ZipFile(jFile);
    end

    function delete(this)
      this.close;
    end
    
    function out = getComment(this)
      jStr = this.j.getComment;
      if isempty(jStr)
        out = string(missing);
      else
        out = string(jStr);
      end
    end
    
    function out = getEntry(this, name)
      jEntry = this.j.getEntry(name);
      if isempty(jEntry)
        out = [];
        return
      end
      out = jl.util.ZipEntry(jEntry);
    end
    
    function out = getEntries(this)
      out = [];
      jEnum = this.j.entries;
      while jEnum.hasMoreElements
        jEntry = jEnum.nextElement;
        out = [out jl.util.ZipEntry(jEntry)]; %#ok<AGROW>
      end
    end
    
    function out = getName(this)
      out = string(this.j.getName);
    end
    
    function out = nEntries(this)
      out = this.j.size;
    end
    
    function out = getContents(this, entry)
      if isa(entry, 'jl.util.ZipEntry')
        jZipEntry = entry.j;
      elseif ischar(entry) || isstring(entry)
        jZipEntry = this.j.getEntry(entry);
      else
        error('jl:InvalidInput', 'Invalid input');
      end
      istr = this.j.getInputStream(jZipEntry);
      jbytes = com.google.common.io.ByteStreams.toByteArray(istr);
      out = typecast(jbytes, 'uint8');
    end
    
    function close(this)
      this.j.close;
    end
    
  end
  
end