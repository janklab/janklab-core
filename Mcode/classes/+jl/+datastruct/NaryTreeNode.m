classdef NaryTreeNode
    %NARYTREENODE A node in an NaryTree
    
    properties
        % The value held at this node
        value = []
        % This node's child nodes
        children jl.datastruct.NaryTreeNode
    end
    
    properties (Dependent)
        % The number of children this node has
        nChildren
    end
    
    methods
        function this = NaryTreeNode(value)
        if nargin < 1
            return;
        end
        this.value = value;
        end
        
        function [this,child] = addChild(this, value)
        % Add a child node
        %
        % [this,child] = addChild(obj, node)
        % [this,child] = addChild(obj, value)
        if isa(value, 'jl.types.NaryTreeNode')
            child = value;
            this.children(end+1) = child;
        else
            child = jl.datastruct.NaryTreeNode(value);
            this.children(end+1) = child;
        end
        end
        
        function this = removeChild(this, ixChildren)
        % Remove children at given index(es)
        this.children(ixChildren) = [];
        end
        
        function out = get.nChildren(this)
        % The number of children this node has
        out = numel(this.children);
        end
    end
end