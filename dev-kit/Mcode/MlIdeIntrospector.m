classdef MlIdeIntrospector
  %MLIDEINTROSPECTOR A pile of hacks for working with the Matlab Desktop
  %
  % This entire class is a big hack and work-in-progress, and is subject to change
  % at any time. Don't use it.

  methods
    function out = mlMainFrame(this) %#ok<MANU>
      %MLMAINFRAME Get the main frame for this Matlab session
      allFrames = java.awt.Frame.getFrames();
      for i = 1:numel(allFrames)
        if isa(allFrames(i), 'com.mathworks.mde.desk.MLMainFrame')
          out = allFrames(i);
          return
        end
      end
      error('Unable to locate MLMainFrame');
    end
    
    function out = dtRootPane(this)
      %DTROOTPANE Get the DTRootPane under the MLMainFrame
      mlMainFrame = this.mlMainFrame();
      out = childComponentOfType(mlMainFrame, 'com.mathworks.widgets.desk.DTRootPane');
    end
    
    function out = desktop(this)
      %DESKTOP Get the Desktop object
      out = com.mathworks.mde.desk.MLDesktop.getInstance();
      % Used to do it with this, but I think that's backwards:
      % out = this.mlMainFrame.getDesktop();
    end
  end
  
end

function out = childComponentOfType(parent, childType)
  children = parent.getComponents();
  for i = 1:numel(children)
    if isa(children(i), childType)
      out = children(i);
      return
    end
  end
  error('Unable to find child component of type %s', childType);
end