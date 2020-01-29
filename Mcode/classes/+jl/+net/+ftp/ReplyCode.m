classdef ReplyCode < jl.util.Displayable
  % ReplyCode An FTP reply code and its meaning
  %
  % See RFC 959 for definitions: https://tools.ietf.org/html/rfc959.
  % And Wikipedia: https://en.wikipedia.org/wiki/List_of_FTP_server_return_codes
  %
  % See also:
  % jl.net.ftp.FtpClient
  
  properties
    % The response code
    code (1,1) double = NaN
    % A message describing the meaning of the response code
    message (1,1) string = string(missing)
  end
  properties (Dependent)
    % The series of the response code (e.g. 100, 200, etc)
    %   100: Positive Preliminary reply
    %   200: Positive Completion reply
    %   300: Positive Intermediate reply
    %   400: Transient Negative Completion reply
    %   500: Permanent Negative Completion reply
    %   600: Confidentiality and Integrity replies
    series
    % The subseries of the response code (the second digit in the code)
    %   0: Syntax or command error
    %   1: Information
    %   2: Connections
    %   3: Authentication and accounting
    %   4: Unspecified
    %   5: File system status
    subseries
  end
  
  methods (Static)
    
    function out = ofNumericCode(code)
      % Convert a numeric code to a ReplyCode object
      mustBeScalarNumeric(code);
      out = jl.net.ftp.ReplyCode;
      out.code = code;
      out.message = jl.net.ftp.ReplyCode.messageForCode(code);
    end
    
    function out = messageForCode(code)
      mustBeScalarNumeric(code)
      switch code
        case 110; out = 'Restart marker reply.';
        case 120; out = 'Service ready in nnn minutes.';
        case 125; out = 'Data connection already open; transfer starting.';
        case 150; out = 'File status okay; about to open connection.';
        case 202; out = 'Command not implemented on this server, superfluous on this site.';
        case 211; out = 'System status or help.';
        case 212; out = 'Directory status.';
        case 213; out = 'File status.';
        case 214; out = 'Help message.';
        case 215; out = 'System type (see NAME).';
        case 220; out = 'Service ready for new user.';
        case 221; out = 'Service closing control connection.';
        case 225; out = 'Data connection open; no transfer in progress.';
        case 226; out = 'Closing data connection. Requested action successful.';
        case 227; out = 'Entering Passive Mode.';
        case 228; out = 'Entering Long Passive Mode.';
        case 229; out = 'Entering Extended Passive Mode.';
        case 230; out = 'User logged in, proceed. Logged out if appropriate.';
        case 231; out = 'User logged out, service terminated.';
        case 232; out = 'Logout command noted, will complete when transfer done.';
        case 234; out = 'Server accepts client''s authentication mechanism (nonstandard Microsoft code)';
        case 250; out = 'Requested file action okay, completed.';
        case 257; out = 'File or directory created.';
        case 331; out = 'User name okay, need password.';
        case 332; out = 'Need account for login.';
        case 350; out = 'Requested file action pending further information';
        case 421; out = 'Service not available, closing control connection.';
        case 425; out = 'Can''t open data connection.';
        case 426; out = 'Connection closed, transfer aborted.';
        case 430; out = 'Invalid username or password.';
        case 434; out = 'Requested host unavailable.';
        case 450; out = 'Requested file action not taken.';
        case 451; out = 'Requested action aborted. Local error in processing.';
        case 452; out = 'Requested action not taken. Insufficient storage space or file not available.';
        case 501; out = 'Syntax error in parameters or arguments.';
        case 502; out = 'Command not implemented.';
        case 503; out = 'Bad sequence of commands.';
        case 504; out = 'Command not implemented for that parameter.';
        case 530; out = 'Not logged in.';
        case 532; out = 'Need account for storing files.';
        case 534; out = 'Could not connect to server - policy requires SSL.';
        case 550; out = 'Requested action not taken; file unavailable.';
        case 551; out = 'Requested action aborted. Page type unknown.';
        case 552; out = 'Requested file action aborted. Exceeded storage allocation.';
        case 553; out = 'Requested action not taken. File name not allowed.';
        case 631; out = 'Integrity protected reply.';
        case 632; out = 'Confidentiality and integrity protected reply.';
        case 633; out = 'Confidentiality protected reply.';
        otherwise; out = sprintf('Unknown reply code (%d)', code);
      end
    end
    
  end
  
  methods
    
    function this = ReplyCode()
      % Construct a new object
      %
      % You generally don't want to call this. Use OFNUMERICCODE instead.
    end
    
    function out = get.series(this)
      out = (floor(this.code/100)) * 100;
    end
    
    function out = get.subseries(this)
      out = floor(mod(this.code, 100) / 10);
    end
    
    function out = isPositiveCompletion(this)
      % Whether this indicates a successful, completed operation
      out = this.series == 200;
    end
    
  end
  
  methods (Access = protected)
    
    function out = dispstr_scalar(this)
      out = sprintf('%d: %s', this.code, this.message);
    end
    
  end
    
end