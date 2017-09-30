function inhtree(x)
  %INHTREE Display inverse inheritance tree for objects
  %
  % jl.lang.inhtree(x)
  %
  % Displays the inverse inheritance tree for the class of x.
  %
  % x can be an object of any type.
  %
  %
  % Examples:
  %
  % jl.lang.inhtree(42)
  % jl.lang.inhtree(java.util.ArrayList)
  % jl.lang.inhtree(database('foo'))
  %
  % See also:
  % INHTREEFORCLASS
  
  jl.lang.inhtreeForClass(class(x));
  
end

