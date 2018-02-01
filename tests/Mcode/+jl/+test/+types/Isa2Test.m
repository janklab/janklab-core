classdef Isa2Test < jl.unittest.TestCase
   
     methods (Test)
         function testSomeIsa2Cases(t)
         % Test some example cases of isa2()
         
         dt = datetime;
         
         % { Value, Type, ExpectedAnswer; ... }
         checks = {
             42         'numeric'   true
             42         'double'    true
             42         'integer'   false
             int32(42)  'integer'   true
             {}         'cellstr'   true
             {'foo','bar'}      'cellstr'   true
             {'foo','bar',42}   'cellstr'   false
             dt         'object'    true
             dt         'datetime'  true
             dt         'double'    false
             dt         'numeric'   false
             };
         
         for i = 1:size(checks, 1)
             [value,type,expectedAnswer] = checks{i,:};
             t.verifyEqual(isa2(value, type), expectedAnswer);
         end
         end
     end
end