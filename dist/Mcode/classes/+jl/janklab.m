classdef janklab
%JANKLAB Central info and management for the Janklab library

	methods(Static)
		function init_janklab
			%INIT_JANKLAB Runs Janklab initialization code
			%
			% This is for Janklab's internal use, to be called by the top-level
			% INIT_JANKLAB.
			% Do not call it yourself.
			
			% No initialization code is defined yet
			
			dispf('Janklab %s initalized', jl.janklab.version);
		end
		
		function out = version
		%VERSION Version information for Janklab
		out = 'v0.1-SNAPSHOT';
		end
	end
end