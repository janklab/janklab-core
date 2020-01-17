classdef FileHandle < handle
	%FILEHANDLE OOP style filehandle
	%
	% This is an object-oriented wrapper around Matlab's file I/O operations. This
	% provides for automatic closing of filehandles, and reports errors as exceptions
	% instead of status codes the caller must check.
	%
	% FileHandle presents OOP versions of all of Matlab's normal file I/O functions,
	% and adds additional convenience methods.
	
	properties
		% The underlying Matlab fID (like that returned by fopen())
		fid         double
		% Filename of the opened file
		filename    char
		% Permissions
		permission  char
		% Machine format
		machinefmt  char
		% Character encoding
		encoding    char
	end
	
	methods (Static = true)
		function out = fopen(filename, permission, machinefmt, encodingIn)
		%FOPEN Open a file
		%
		% out = fopen(filename)
		% out = fopen(filename, permission)
		% out = fopen(filename, permission, machinefmt, encodingIn)
		%
		% The semantics of the input arguments is the same as for Matlab's base FOPEN.
		%
		% See also:
		% FOPEN
		narginchk(1,4);
		if nargin == 1
			[fid, errmsg] = fopen(filename);
		elseif nargin == 2
			[fid, errmsg] = fopen(filename, permission);
		else
			[fid, errmsg] = fopen(filename, permission, machinefmt, encodingIn);
		end
		if ~isempty(errmsg)
			error('jl:io:IOError', 'Failed to open file "%s": %s', filename, errmsg);
		end
		out = jl.io.FileHandle(fid);
		end
	end
	
	methods
		function this = FileHandle(fid)
		%FILEHANDLE Create a new FileHandle object for a given filehandle
		%
		% this = FileHandle(fid)
		%
		% Typically you will not call this yourself; instead, use the static fopen()
		% method to open a file and get the resulting FileHandle.
		%
		% Fid is the fileID returned from a call to Matlab's FOPEN function.
		mustBeScalar(fid);
		mustBeNumeric(fid);
		this.fid = fid;
		[this.filename, this.permission, this.machinefmt, this.encoding] = fopen(fid);
		end
		
		function out = disp(this)
		%DISP Custom display
		if isscalar(this)
			out = sprintf('FileHandle: "%s" (%s, %s, %s, fid=%d)',...
				this.filename, this.permission, this.machinefmt, this.encoding, this.fid);
		else
			out = sprintf('%s %s', size2str(size(this)), class(this));
		end
		if nargout == 0
			disp(out);
			clear out
		end
		end
		
		function fclose(this)
		%FCLOSE Close this file
		%
		% fclose(this)
		%
		% Closes this file if it is open. Calling fclose on a FileHandle that is
		% already closed is a no-op.
		%
		% Throws an error if the close operation was unsuccessful.
		if ~isempty(this.fid)
			status = fclose(this.fid);
			if status ~= 0
				error('jl:io:IOError', 'Failed to close file');
			end
		end
		this.detach();
		end
		
		function detach(this)
		%DETACH Detach this object from its FID without closing it
		%
		% This is a lower-level method that is not called during normal use of
		% FileHandle.
		this.fid = [];
		[this.filename, this.permission, this.machinefmt, this.encoding] = deal([]);
		end
		
		function delete(this)
		%DELETE Cleanup function
		%
		% This method is automatically called when the object is about to be
		% destroyed. It is used to automatically close the file handle.
		this.fclose();
		end
		
		function out  = feof(this)
		%FEOF Test for end-of-file
		%
		% feof(this) returns 1 if the end-of-file indicator for this file has been
		% set, and 0 otherwise. The end-of-file indicator is set when a read
		% operation on the file attempts to read past the end of the file.
		out = feof(this.fid);
		end
		
		function out = fprintf(this, formatSpec, varargin)
		%FPRINTF Write formatted data to text file
		%
		% Writes text data to this' file using the normal FPRINTF syntax.
		%
		% Raises an error if the operation fails.
		out = fprintf(this.fid, formatSpec, varargin{:});
		[errmsg, errnum] = ferror(this.fid);
		if errnum ~= 0
			error('jl:io:IOError', 'Writing to file failed: %s', errmsg);
		end
		end
		
		function [out, count] = fread(this, sizeA, precision, skip, machinefmt)
		%FREAD Read data from binary file
		%
		% [out, count] = fread(this, sizeA, precision, skip, machinefmt)
		%
		% Reads binary data from this file handle in the same manner as base Matlab's
		% FREAD.
		%
		% See also:
		% FREAD
		if nargin == 1
			[out, count] = fread(this.fid);
		elseif nargin == 2
			[out, count] = fread(this.fid, sizeA);
		elseif nargin == 3
			[out, count] = fread(this.fid, sizeA, precision);
		elseif nargin == 4
			[out, count] = fread(this.fid, sizeA, precision, skip);
		elseif nargin == 5
			[out, count] = fread(this.fid, sizeA, precision, skip, machinefmt);
		end
		[errmsg, errnum] = ferror(this.fid);
		if errnum ~= 0
			error('jl:io:IOError', 'Reading from file failed: %s', errmsg);
		end
		end
		
		function frewind(this)
		%FREWIND Move file position indicator to beginning of file
		%
		% frewind(this)
		%
		% Sets the file position indicator to the beginning of this file.
		frewind(this.fid);
		end
		
		function [out,count] = fscanf(this, formatSpec, sizeA)
		%FSCANF Read data from text file
		%
		% [out,count] = fscanf(this, formatSpec, sizeA)
		%
		% Reads data from this file in the same manner as base Matlab's FSCANF.
		%
		% See also:
		% FSCANF
		narginchk(2,3);
		if nargin == 2
			[out,count] = fscanf(this, formatSpec);
		else
			[out,count] = fscanf(this, formatSpec, sizeA);
		end
		[errmsg, errnum] = ferror(this.fid);
		if errnum ~= 0
			error('jl:io:IOError', 'Reading from file failed: %s', errmsg);
		end
		end
		
		function fseek(this, offset, origin)
		%FSEEK Move to specified position in file
		%
		% fseek(this, offset, origin)
		%
		% Sets the file position indicator offset bytes from origin for this file handle.
		%
		% Raises an error if the operation was not successful.
		status = fseek(this.fid, offset, origin);
		if status ~= 0
			error('jl:io:IOError', 'fseek() on file failed');
		end
		end
		
		function out = ftell(this)
		%FTELL Current position in open file
		%
		% out = ftell(this)
		%
		% Returns the current position in this file, as the number of bytes from the
		% beginning of the file.
		%
		% Raises an error if the query is unsuccessful.
		out = ftell(this.fid);
		if out == -1
			error('jl:io:IOError', 'ftell() failed');
		end
		end
		
		function out = fwrite(this, A, precision, skip, machinefmt)
		%FWRITE Write data to binary file
		%
		% out = fwrite(this, A, precision, skip, machinefmt)
		%
		% Writes data to this file in the same manner as base Matlab's FWRITE.
		%
		% Raises an error if the operation fails.
		%
		% See also:
		% FWRITE
		if nargin == 2
			out = fwrite(this, A);
		elseif nargin == 3
			out = fwrite(this, A, precision);
		elseif nargin == 4
			out = fwrite(this, A, precision, skip);
		elseif nargin == 5
			out = fwrite(this, A, precision, skip, machinefmt);
		end
		[errmsg, errnum] = ferror(this.fid);
		if errnum ~= 0
			error('jl:io:IOError', 'Writing to file failed: %s', errmsg);
		end		
		end
	end
	
	methods ( Static = true )
		function out = listAllOpenFiles(varargin)
		%LISTALLOPENFILES List all open filehandles
		%
		% out = jl.io.FileHandle.listAllOpenFiles()
		% out = jl.io.FileHandle.listAllOpenFiles('includestd')
		%
		% Lists all open file handles in this Matlab session, in table form.
		%
		% If 'includestd' is specified, then stdin, stdout, and stderr are included
		% in the table.
		fids = fopen('all');
		if ismember('includestd', varargin)
			fids = [0 1 2 fids];
		end
		n = numel(fids);
		fID = fids(:);
		[filename, permission, machinefmt, encoding] = deal(cell(n, 1));
		for i = numel(fids):-1:1
			[filename{i}, permission{i}, machinefmt{i}, encoding{i}] = fopen(fids(i));
		end
		out = table(fID, filename, permission, machinefmt, encoding);
		end
	end
end
