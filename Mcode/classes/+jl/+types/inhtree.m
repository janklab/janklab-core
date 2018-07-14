function inhtree(x)
  %INHTREE Display inverse inheritance tree for objects
  %
  % jl.types.inhtree(x)
  %
  % Displays the inverse inheritance tree for the class of x.
  %
  % x can be an object of any type.
  %
  %
  % Examples:
  %
  % jl.types.inhtree(42)
  % jl.types.inhtree(java.util.ArrayList)
  % jl.types.inhtree(database('foo'))
  %
  % See also:
  % INHTREEFORCLASS
  
  jl.types.inhtreeForClass(class(x));
  
end

