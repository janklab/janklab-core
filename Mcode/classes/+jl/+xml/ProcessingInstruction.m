classdef ProcessingInstruction < jl.xml.Node
  % ProcessingInstruction An XML processing instruction
  
  properties
    target string = jl.xml.Util.missing_string
    data string = jl.xml.Util.missing_string
  end
  
  methods
    function this = ProcessingInstruction(varargin)
      %
      % ProcessingInstruction(target, data)
      % ProcessingInstruction(doc, target, data)
      narginchk(0, 1);
      if isempty(varargin)
        return;
      end
      args = varargin;
      if isa(args{1}, 'jl.xml.Document')
        this.document_ = args{1};
        args(1) = [];
      end
      if numel(args) >= 1
        this.target = string(args{1});
      end
      if numel(args) >= 2
        this.target = string(args{2});
      end
    end
  end
  
  methods (Access = protected)
    function out = getName(this)
      out = this.target;
    end    
  end
end