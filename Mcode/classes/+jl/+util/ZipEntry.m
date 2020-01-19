classdef ZipEntry < jl.util.DisplayableHandle
  
  %#ok<*PROP>
  
  properties (Constant, Hidden)
    UnixEpoch = datenum('1/1/1970');
  end
  
  properties (SetAccess = private)
    % The underlying java.util.zip.ZipEntry object
    j
  end
  
  properties (Dependent)
    comment
    compressedSize
    crc
    creationTime
    isDirectory
    lastAccessTime
    lastModifiedTime
    method
    name
    uncompressedSize
    time
  end
  
  methods
    
    function this = ZipEntry(arg)
      if isa(arg, 'java.util.zip.ZipEntry')
        this.j = arg;
      else
        name = arg;
        this.j = java.util.zip.ZipEntry(name);
      end
    end
    
    function out = get.comment(this)
      out = jl.util.stringormissing(this.j.getComment);
    end
    
    function set.comment(this, val)
      this.j.setComment(val);
    end
    
    function out = get.compressedSize(this)
      out = this.j.getCompressedSize;
    end
    
    function set.compressedSize(this, val)
      this.j.setCompressedSize(val);
    end
    
    function out = get.crc(this)
      out = this.j.getCrc;
    end
    
    function set.crc(this, val)
      this.j.setCrc(val);
    end
    
    function out = get.creationTime(this)
      out = filetimeToDatetime(this.j.getCreationTime);
    end

    function set.creationTime(this, val)
      this.j.setCreationTime(datetimeToFiletime(val));
    end
    
    function out = get.lastAccessTime(this)
      out = filetimeToDatetime(this.j.getLastAccessTime);
    end
    
    function set.lastAccessTime(this, val)
      this.j.setLastAccessTime(datetimeToFiletime(val));
    end
    
    function out = get.lastModifiedTime(this)
      out = filetimeToDatetime(this.j.getLastModifiedTime);
    end
    
    function set.lastModifiedTime(this, val)
      this.j.setLastModifiedTime(datetimeToFiletime(val));
    end
    
    function out = get.method(this)
      jCode = this.j.getMethod;
      switch jCode
        case java.util.zip.ZipEntry.DEFLATED
          out = "DEFLATE";
        case java.util.zip.ZipEntry.STORED
          out = "STORE";
        otherwise
          out = sprintf('<UNKNOWN (code=%d)>', jCode);
      end
    end
    
    function set.method(this, val)
      if ischar(val) || isstring(val)
        switch upper(val)
          case "DEFLATE"
            jCode = java.util.zip.ZipEntry.DEFLATED;
          case "STORE"
            jCode = java.util.zip.ZipEntry.STORED;
          otherwise
            error('jl:InvalidInput', 'Invalid value for method: %s', val)
        end
        this.j.setMethod(jCode);
      else
        this.j.setMethod(val);
      end
    end
    
    function out = get.name(this)
      out = jl.util.stringormissing(this.j.getName);
    end
    
    function out = get.uncompressedSize(this)
      out = this.j.getSize;
    end
    
    function set.uncompressedSize(this, val)
      this.j.setSize(val);
    end
    
    function out = get.time(this)
      out = this.j.getTime;
    end
    
    function set.time(this, val)
      this.j.setTime(val);
    end
    
    function out = get.isDirectory(this)
      out = this.j.isDirectory;
    end
    
    function out = getExtra(this)
      out = typecast(this.j.getExtra, 'uint8');
    end
    
    function setExtra(this, val)
      this.j.setExtra(val);
    end
    
  end

  methods (Access = protected)
    
    function out = dispstr_scalar(this)
      name = this.name;
      if this.isDirectory
        name = [name '/'];
      end      
      out = sprintf('[ZipEntry: %s (%s %d KB / %d KB compressed)]', ...
        name, this.method, round(this.uncompressedSize/1024), round(this.compressedSize/1024));
      out = [out ']'];
    end
    
  end
  
end

function out = filetimeToDatetime(jTime)
if isempty(jTime)
  out = NaT;
  return
end
millis = double(jTime.toMillis);
dnum = jl.util.ZipEntry.UnixEpoch + (millis / (1000 * 60 * 60 * 24));
out = datetime(dnum, 'ConvertFrom','datenum');
end

function out = datetimeToFiletime(dt)
if isempty(dt) || ismissing(dt)
  out = [];
  return
end
dnum = datenum(dt);
daysAfterEpoch = dnum - jl.util.ZipEntry.UnixEpoch;
millis = int64(daysAfterEpoch * (1000 * 60 * 60 * 24));
out = java.nio.file.attribute.FileTime.from(millis);
end
