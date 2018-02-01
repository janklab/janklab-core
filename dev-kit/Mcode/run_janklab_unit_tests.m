function result = run_janklab_unit_tests
% Runs all the Janklab unit tests
%
% result = run_janklab_unit_tests()
%
% Runs all the unit tests in the Janklab unit test suite.
%
% Returns the test suite result.
%
% Examples:
%
% run_janklab_unit_tests
%
% testResult = run_janklab_unit_tests();

import matlab.unittest.TestSuite;

suite = TestSuite.fromPackage('jl.test', 'IncludingSubpackages',true);
result = run(suite);