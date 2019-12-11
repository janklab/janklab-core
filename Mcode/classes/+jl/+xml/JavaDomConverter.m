classdef JavaDomConverter
  % JavaDomConverter Converts between Java DOM objects and jl.xml objects
  
  % TODO: String canonicalization
  
  %#ok<*INUSL>
  %#ok<*STOUT>
  %#ok<*INUSD>
  
  methods
    function out = ofJavaDomDocument(this, jnode)
      narginchk(2, 2);
      mustBeA(jnode, 'org.w3c.dom.Document');
      jdoc = jnode;
      doc = jl.xml.Document;
      doc.xmlEncoding = string(jdoc.getXmlEncoding);
      doc.xmlStandalone = jdoc.getXmlStandalone;
      doc.xmlVersion = string(jdoc.getXmlVersion);
      jDocType = jdoc.getDoctype;
      if ~isempty(jDocType)
        doc.documentType = this.ofJavaDomDoctype(doc, jDocType);
      end
      jroot = jdoc.getDocumentElement;
      rootNode = this.ofJavaDomNode(doc, jroot);
      doc.rootNode = rootNode;
      out = doc;
    end
    
    function out = ofJavaDomNode(this, doc, jnode)
      narginchk(3, 3);
      mustBeA(doc, 'jl.xml.Document');
      mustBeA(jnode, 'org.w3c.dom.Node');
      
      switch jnode.getNodeType
        case org.w3c.dom.Node.ATTRIBUTE_NODE
          out = this.ofJavaDomAttribute(doc, jnode);
        case org.w3c.dom.Node.CDATA_SECTION_NODE
          out = this.ofJavaDomCDATASection(doc, jnode);
        case org.w3c.dom.Node.COMMENT_NODE
          out = this.ofJavaDomComment(doc, jnode);
        case org.w3c.dom.Node.DOCUMENT_FRAGMENT_NODE
          error("DOCUMENT_FRAGMENT_NODE is unimplemented")
        case org.w3c.dom.Node.DOCUMENT_NODE
          % Question-begging of where our doc input would come from?
          error('jl:InvalidInput', "You can't use a Document node here.");
        case org.w3c.dom.Node.DOCUMENT_TYPE_NODE
          out = this.ofJavaDomDoctype(doc, jnode);
        case org.w3c.dom.Node.ELEMENT_NODE
          out = this.ofJavaDomElement(doc, jnode);
        case org.w3c.dom.Node.ENTITY_NODE
          out = this.ofJavaDomEntity(doc, jnode);
        case org.w3c.dom.Node.ENTITY_REFERENCE_NODE
          out = this.ofJavaDomEntityReference(doc, jnode);
        case org.w3c.dom.Node.NOTATION_NODE
          out = this.ofJavaDomNotation(doc, jnode);
        case org.w3c.dom.Node.PROCESSING_INSTRUCTION_NODE
          out = this.ofJavaDomProcessingInstruction(doc, jnode);
        case org.w3c.dom.Node.TEXT_NODE
          out = this.ofJavaDomText(doc, jnode);
        otherwise
          error('Unimplemented DOM node type: %d', jnode.getNodeType);
      end
    end
    
    function out = ofJavaDomAttribute(this, doc, jnode)
      narginchk(3, 3);
      mustBeA(doc, 'jl.xml.Document');
      mustBeA(jnode, 'org.w3c.dom.Attr');
      name = string(jnode.getName);
      val = string(jnode.getValue);
      % TODO: Figure out how to get the parent element into the ctor
      out = jl.xml.Attr(name, val);
    end

    function out = ofJavaDomCDATASection(this, doc, jnode)
      narginchk(3, 3);
      mustBeA(doc, 'jl.xml.Document');
      mustBeA(jnode, 'org.w3c.dom.CDATASection');
      out = jl.xml.CDATASection(doc, string(jnode.getData));
    end
    
    function out = ofJavaDomComment(this, doc, jnode)
      narginchk(3, 3);
      mustBeA(doc, 'jl.xml.Document');
      mustBeA(jnode, 'org.w3c.dom.Comment');
      out = jl.xml.Comment(doc, string(jnode.getData));
    end
    
    function out = ofJavaDomDoctype(this, doc, jdtype)
      narginchk(3, 3);
      mustBeA(doc, 'jl.xml.Document');
      mustBeA(jdtype, 'org.w3c.dom.DocumentType');
      out = jl.xml.DocumentType;
      out.name = string(jdtype.getName);
      out.publicId = string(jdtype.getPublicId);
      out.systemId = string(jdtype.getSystemId);
      out.internalSubset = string(jdtype.getInternalSubset);
      out.entities = this.ofJavaDomNamedNodeMap(doc, jdtype.getEntities);
      out.notations = this.ofJavaDomNamedNodeMap(doc, jdtype.getNotations);
    end
    
    function out = ofJavaDomElement(this, doc, jnode)
      narginchk(3, 3);
      mustBeA(doc, 'jl.xml.Document');
      mustBeA(jnode, 'org.w3c.dom.Element');
      name = string(jnode.getNodeName);
      if name == "w:font"
        keyboard
      end
      out = jl.xml.Element(doc, name);
      % Attributes
      jAttrMap = jnode.getAttributes;
      n = jAttrMap.getLength;
      attrs = repmat(jl.xml.Attr, [1 n]);
      for i = 1:n
        attrs(i) = this.ofJavaDomAttribute(doc, jAttrMap.item(i-1));
      end
      out.attributes = attrs;
      % Child nodes
      jKids = jnode.getChildNodes;
      n = jKids.getLength;
      kids = repmat(jl.xml.Node, [1 n]);
      for i = 1:n
        kids(i) = this.ofJavaDomNode(doc, jKids.item(i-1));
      end
      out.children = kids;
      % And I think that's it
    end
    
    function out = ofJavaDomEntity(this, doc, jnode)
      narginchk(3, 3);
      mustBeA(doc, 'jl.xml.Document');
      mustBeA(jnode, 'org.w3c.dom.Entity');
      out = jl.xml.Entity(doc);
      % TODO: I think if these values are Java null, they'll get converted
      % to 0-by-0 string arrays; I think I'd rather have them be
      % missing(string).
      out.inputEncoding = string(jnode.getInputEncoding);
      out.notationName = string(jnode.getNotationName);
      out.publicId = string(jnode.getNotationName);
      out.systemId = string(jnode.getSystemId);
      out.xmlEncoding = string(jnode.getXmlEncoding);
      out.xmlVersion = string(jnode.getXmlVersion);
    end
    
    function out = ofJavaDomEntityReference(this, doc, jnode)
      % ofJavaDomEntityReference
      %
      % (Currently unimplemented because it seems pretty hard.)
      narginchk(3, 3);
      mustBeA(doc, 'jl.xml.Document');
      mustBeA(jnode, 'org.w3c.dom.EntityReference');
      error('jl:Unimplemented', "XML EntityReferences are currently unimplemented. Sorry.");
    end
    
    function out = ofJavaDomNotation(this, doc, jnode)
      narginchk(3, 3);
      mustBeA(doc, 'jl.xml.Document');
      mustBeA(jnode, 'org.w3c.dom.Notation');
      out = jl.xml.Notation(doc, string(jnode.getPublicId), ...
        string(jnode.getSystemId));
    end
    
    function out = ofJavaDomProcessingInstruction(this, doc, jnode)
      narginchk(3, 3);
      mustBeA(doc, 'jl.xml.Document');
      mustBeA(jnode, 'org.w3c.dom.ProcessingInstruction');
      out = jl.xml.ProcessingInstruction(doc, jnode.getTarget, ...
        jnode.getData);
    end
    
    function out = ofJavaDomText(this, doc, jnode)
      narginchk(3, 3);
      mustBeA(doc, 'jl.xml.Document');
      mustBeA(jnode, 'org.w3c.dom.Text');
      out = jl.xml.Text(doc, jnode.getData);
    end
    
    function out = ofJavaDomNamedNodeMap(this, doc, jmap)
      narginchk(3, 3);
      mustBeA(doc, 'jl.xml.Document');
      mustBeA(jmap, 'org.w3c.dom.NamedNodeMap');
      out = containers.Map;
      n = jmap.getLength;
      for i = 1:n
        node = jmap.item(i-1);
        out(string(node.getNodeName)) = this.ofJavaDomNode(doc, node);
      end
    end
  end
  
end