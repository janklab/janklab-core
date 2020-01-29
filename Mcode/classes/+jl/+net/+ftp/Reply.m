classdef Reply < jl.util.Displayable
  % Reply An FTP reply, with both code and message string
  
  properties (SetAccess = private)
    % A ReplyCode object
    code (1,1) jl.net.ftp.ReplyCode = jl.net.ftp.ReplyCode
    % The message as a multi-line string
    message (1,1) string
  end
  
  methods (Static = true)
    
    function out = of(code, msg)
      if isnumeric(code)
        replyCode = jl.net.ftp.ReplyCode.ofNumericCode(code);
      elseif isa(code, 'jl.net.ftp.ReplyCode')
        replyCode = code;
      else
        error('Invalid type for code: %s', class(code));
      end
      out = jl.net.ftp.Reply;
      out.code = replyCode;
      out.message = msg;
    end
    
  end
  
  methods
    
  end
  
  methods (Access = protected)
    
    function out = dispstr_scalar(this)
      out = sprintf('[Reply: %s: %s]', ...
        dispstr(this.code), this.message);
    end
    
  end
  
end
