classdef SwingHacks
  %SWINGHACKS Utils for debugging Swing GUIs
  %
  % This entire class is a big hack and work-in-progress, and is subject to change
  % at any time. Don't use it.
  
  methods
    function bigOldBorder(this, c, color)
      %BIGOLDBORDER Set a big colored border on the target component
      %
      % If applied to a Frame or Window, sets the border on all child
      % components of the frame.
      if nargin < 3 || isempty(color); color = 'red'; end
      
      jColor = colorArg2JavaColor(color);
      border = javax.swing.BorderFactory.createLineBorder(jColor, 5);
      this.setBorderOnComponentOrFrameChildren(c, border);
    end
    
    function noBorder(this, c)
      %NOBORDER Set an empty border on the target component
      border = javax.swing.BorderFactory.createEmptyBorder();
      this.setBorderOnComponentOrFrameChildren(c, border);
    end
    
    function inspectTree(this, c)
      %INSPECTTREE Dump the Swing component tree for a given component
      this.inspectTreeStep(c, '');
    end
  end
  
  methods (Access = private)
    
    function inspectTreeStep(this, c, prefix)
      %INSPECTTREESTEP Implementation for inspectTree()
      cStr = char(c.toString());
      fprintf('%s%s\n', prefix, cStr);
      children = c.getComponents();
      for i = 1:numel(children)
        this.inspectTreeStep(children(i), [prefix '  ']);
      end
    end
    
    function setBorderOnComponentOrFrameChildren(this, c, border)
      % Implementation for bigOldBorder() and related methods
      if isa(c, 'java.awt.Window')
        children = c.getComponents();
        for i = 1:numel(children)
          this.setBorderOnComponentOrFrameChildren(children(i), border);
        end
      else
        c.setBorder(border);
      end
    end
  end
end

function out = colorArg2JavaColor(color)
  if ischar(color)
    out = eval(['java.awt.Color.' upper(color)]);
  else
    error('Invalid color');
  end
end