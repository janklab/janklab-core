classdef WriteTableOptions
  
  properties
    BoldColHeaders (1,1) logical = true
    FreezePanes (1,1) logical = false
  end
  
  methods
    
    function this = WriteTableOptions(arg)
      if nargin == 0
        return
      end
      if isa(arg, 'jl.office.excel.WriteTableOptions')
        this = arg;
        return
      end
      if isempty(arg)
        return;
      end
      if iscell(arg)
        arg = jl.util.parseOpts(arg);
      end
      if isstruct(arg)
        fnames = fieldnames(arg);
        for i = 1:numel(fnames)
          this.(fnames{i}) = arg.(fnames{i});
        end
      else
        error('jl:InvalidInput', ['Invalid input to WriteTableOptions(): '...
          'Expected struct or cell, got a %s'], class(arg));
      end
    end
    
  end
  
end