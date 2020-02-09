classdef PrintSetup < handle
  %
  
  % TODO: PaperSize enum class
  
  properties
    j
  end

  properties (Dependent)
    draft
    fitHeight
    fitWidth
    footerMargin
    headerMargin
    horizontalResolution
    landscape
    leftToRight
    noColor
    noOrientation
    notes
    numCopies
    pageStart
    paperSize
    paperSizeCode
    scale
    usePage
    validSettings
    verticalResolution
  end
  
  methods
    
    function this = PrintSetup(jObj)
      if nargin == 0
        return
      end
      mustBeA(jObj, 'org.apache.poi.ss.usermodel.PrintSetup');
      this.j = jObj;
    end
    
    function out = get.numCopies(this)
      out = this.j.getCopies;
    end
    
    function set.numCopies(this, val)
      this.j.setCopies(val);
    end
    
    function out = get.draft(this)
      out = this.j.getDraft;
    end
    
    function set.draft(this, val)
      this.j.setDraft(val);
    end
    
    function out = get.fitHeight(this)
      out = this.j.getFitHeight;
    end
    
    function set.fitHeight(this, val)
      this.j.setFitHeight(val);
    end
    
    function out = get.fitWidth(this)
      out = this.j.getFitWidth;
    end
    
    function set.fitWidth(this, val)
      this.j.setFitWidth(val);
    end
    
    function out = get.footerMargin(this)
      out = this.j.getFooterMargin(this);
    end
    
    function set.footerMargin(this, val)
      this.j.setFooterMargin(val);
    end
    
    function out = get.headerMargin(this)
      out = this.j.getHeaderMargin;
    end
    
    function set.headerMargin(this, val)
      this.j.setHeaderMargin(val);
    end
    
    function out = get.horizontalResolution(this)
      out = this.j.getHResolution;
    end
    
    function set.horizontalResolution(this, val)
      this.j.setHResolution(val);
    end
    
    function out = get.landscape(this)
      out = this.j.getLandscape;
    end
    
    function set.landscape(this, val)
      this.j.setLandscape(val);
    end
    
    function out = get.leftToRight(this)
      out = this.j.getLeftToRight;
    end
    
    function set.leftToRight(this, val)
      this.j.setLeftToRight(val);
    end
    
    function out = get.noColor(this)
      out = this.j.getNoColor;
    end
    
    function set.noColor(this, val)
      this.j.setNoColor(val);
    end
    
    function out = get.noOrientation(this)
      out = this.j.getNoOrientation;
    end
    
    function set.noOrientation(this, val)
      this.j.setNoOrientation(val);
    end
    
    function out = get.notes(this)
      out = this.j.getNotes;
    end
    
    function set.notes(this, val)
      this.j.setNotes(val);
    end
    
    function out = get.pageStart(this)
      out = this.j.getPageStart;
    end
    
    function set.pageStart(this, val)
      this.j.setPageStart(val);
    end
    
    function out = get.paperSizeCode(this)
      out = this.j.getPaperSize;
    end
    
    function set.paperSizeCode(this, val)
      this.j.setPaperSize(val);
    end
    
    function out = get.scale(this)
      out = this.j.getScale;
    end
    
    function set.scale(this, val)
      this.j.setScale(val);
    end
    
    function out = get.usePage(this)
      out = this.j.getUsePage;
    end
    
    function set.usePage(this, val)
      this.j.setUsePage(val);
    end
    
    function out = get.validSettings(this)
      out = this.j.getValidSettings;
    end
    
    function set.validSettings(this, val)
      this.j.ssetValidSettings(val);
    end
    
    function out = get.verticalResolution(this)
      out = this.j.getVResolution;
    end
    
    function set.verticalResolution(this, val)
      this.j.setVResolution(val);
    end
    
  end
  
end

