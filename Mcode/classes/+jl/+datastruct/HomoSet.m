classdef (Sealed) HomoSet
  %HOMOSET A homoegeneously-typed set
  %
  % Works on any data type that supports:
  %   * ismember
  %   * unique
  %   * setdiff
  %   * Standard indexing functions
  %   * transpose
  %
  % Does not maintain sorting of values, and does not require member values
  % to support sort() or relops.
  
  properties (SetAccess = private)
    % The distinct values in this set, stored as a row vector
    vals = []
  end
  properties (Dependent)
    cardinality
  end
  
  methods
    function this = HomoSet(vals)
      if nargin == 0
        return
      end
      this.vals = unique(vals(:)');
    end
    
    function disp(this)
      fprintf('%s (element type %s)\n', class(this), class(this.vals));
      fprintf('  %d elements\n', numel(this.vals));
      fprintf('  Elements: %s\n', ellipses(this.vals, 42));
    end
    
    function out = add(this, vals)
      out = this;
      out.vals = unique([this.vals vals(:)']);
    end
    
    function out = remove(this, vals)
      [tf,loc] = ismember(vals, this.vals);
      out = this;
      out.vals(loc(tf)) = [];
    end
    
    function out = ismember(this, vals)
      out = ismember(vals, this.vals);
    end
    
    function out = get.cardinality(this)
      out = numel(this.vals);
    end
    
  end
end

