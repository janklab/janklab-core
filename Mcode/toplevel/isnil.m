function out = isnil(x)
% True for nil value.
%
% out = isnil(x)
%
% True if the input x is a nil value, and false if it is not. This means whether
% it is of type nil; the only thing that is considered to be nil is the nil
% class.
%
% Whether something is nil is a characteristic of the entire array
%
% Nothing besides instances of the nil class is considered to be nil. Other
% classes should not override ISNIL.
%
% Returns a scalar logical.
%
% See also:
% nil
 
out = isa(x, 'nil');
 
end
