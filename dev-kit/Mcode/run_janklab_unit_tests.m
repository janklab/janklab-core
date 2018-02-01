function result = run_janklab_unit_tests(packageName)
% Runs all the Janklab unit tests
%
% result = run_janklab_unit_tests(packageName)
%
% Runs all the unit tests in the Janklab unit test suite or a subpackage.
%
% PackageName (char) is the name of the package to run tests under. Defaults to
% 'jl.test', which picks up all the Janklab tests.
%
% Some of the tests are brittle with respect to dynamically-generated class
% definitions. I recommend you do a `clear classes` each time before you run the
% test suite.
%
% Returns the test suite result.
%
% Examples:
%
% run_janklab_unit_tests
%
% testResult = run_janklab_unit_tests();

import matlab.unittest.TestSuite;

if nargin < 1 || isempty(packageName);  packageName = 'jl.test';  end

suite = TestSuite.fromPackage(packageName, 'IncludingSubpackages',true);
result = run(suite);