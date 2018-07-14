classdef NaryTree
    %NARYTREE An n-ary tree, holding values at its nodes
    %
    % "N-ary" means that each node can have any number of children.
    
    properties
        rootNode jl.datastruct.NaryTreeNode
    end
    
    methods
        function this = NaryTree(rootNode)
        %NARYTREE Construct a new NaryTree
        %
        % jl.types.NaryTree()
        % jl.types.NaryTree(rootNode)
        %
        % RootNode, if provided, must be a jl.types.NaryTreeNode.
        %
        % The zero-arg constructor returns an empty tree.
        if nargin == 0
            return;
        end
        this.rootNode = rootNode;
        end
        
        function out = depth(this)
        %DEPTH Tree depth
        %
        % Returns the depth of this tree. The depth is the length of the longest
        % path between the root node and a leaf node.
        if isempty(this.rootNode)
            out = 0;
            return;
        end
        out = recursiveDepthCount(this.rootNode);
        end
        
        function prettyprint(this)
        %PRETTYPRINT Display a pretty-printed representation of this tree
        if isempty(this.rootNode)
            fprintf('(empty tree)');
        end
        prettyprintImpl(this.rootNode);
        end
    end
    
end

function out = recursiveDepthCount(node)
if isempty(node.children)
    out = 1;
    return;
end
childDepths = NaN(1, node.nChildren);
for i = 1:node.nChildren
    childDepth = recursiveDepthCount(node.children(i));
    childDepths(i) = childDepth;
end
out = 1 + max(childDepths(:));
end

function prettyprintImpl(rootNode)
%PRETTYPRINTIMPL Implementation of prettyprint

% Note: Can't use Unicode box drawing characters literals in code because they
% get misinterpreted. But we can use them if we explicitly encode them by value,
% and use the "safe" DOS subset.
up_right = char(9492);
horiz = char(9472);
vert = char(9474);

prefix = '';
    function prettyprintStep(node)
    fprintf('%s\n', dispstr(node.value));
    for i = 1:node.nChildren
        fprintf('%s %s', prefix, [up_right horiz horiz]);
        if i < node.nChildren
            prefix = [prefix ' ' vert '  ']; %#ok<AGROW>
        else
            prefix = [prefix '    ']; %#ok<AGROW>
        end
        prettyprintStep(node.children(i));
        prefix(end-3:end) = [];
    end
    end
prettyprintStep(rootNode);
end