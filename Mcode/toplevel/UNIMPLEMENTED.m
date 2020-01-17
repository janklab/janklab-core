function UNIMPLEMENTED
  %UNIMPLEMENTED Placeholder for unimplemented functionality
  %
  % UNIMPLEMENTED
  %
  % Raises an error indicating the code has hit some unimplemented
  % functionality.
  %
  % Stick a call to UNIMPLEMENTED in parts of code you haven't gotten around to
  % writing yet. This makes sure it doesn't fall through and accidentally do a
  % no-op, possibly producing bad results.
  err = MException('jl:Unimplemented', ...
    'This functionality is not yet implemented. Sorry!');
  throwAsCaller(err);
end