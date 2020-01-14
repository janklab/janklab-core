function BADSWITCH(val)
%BADSWITCH Indicates that a a "can't get here" point in a switch was reached
%
% Put a call to BADSWITCH in the "otherwise" leg or other places in a 
% switch statement if they're never supposed to be reached.

if nargin == 0
    error('jl:BadSwitch', ['BUG: The code reached an unexpected point in '...
        'a switch statement. This indicates a bug in the code.']);
else
    error('jl:BadSwitch', ['BUG: The code reached an unexpected point in '...
        'a switch statement. This indicates a bug in the code. ' ...
        'Bad switch value: ' dispstr(val)]);
end
