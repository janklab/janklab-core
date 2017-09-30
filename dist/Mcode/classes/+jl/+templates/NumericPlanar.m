classdef NumericPlanar
	%NUMERICPLANAR Support for planar objects with numeric-like arithmetic
	%
	% This is a mixin class for planar-organized classes whose planar fields
	% support arithmetic semantics, with operations like PLUS and TIMES. 
	% NUMERICPLANAR provides implementations for these methods which apply the
	% functions to all of the planar fields in turn.
	%
	% To use this, a class must supply a PLANARFIELDS method with the same
	% semantics as for DYNAMICPLANAR.
	%
	% NUMERICPLANAR supplies the following methods:
	%   PLUS
	%   MINUS
	%   TIMES
	%   RDIVIDE
	%   MINUS
	%   UMINUS
	%   POWER
	% It does not supply the matrix form of operations, like MTIMES, because 
	% they have more complex semantics that may not translate well to multi-field objects.
	% Note that UMINUS applies the minus to all fields, which may not be
	% appropriate for multi-field objects.
	
end