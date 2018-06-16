function inhtreeForClass(className)
%INHTREEFORCLASS Display inverse inheritance tree for named class
%
% See also:
% INHTREE

% This is a hack to allow you to pass in a class object directly, for
% convenience.
if isa(className, 'java.lang.Class')
    klass = className;
    tree = inhtreeForJavaClass(klass);
    tree.prettyprint();
    return
end
if isa(className, 'meta.class')
    klass = className;
    tree = inhtreeForMatlabClass(klass);
    tree.prettyprint();
    return
end

% Matlab classes take precedence
klass = meta.class.fromName(className);
if ~isempty(klass)
    tree = inhtreeForMatlabClass(klass);
    tree.prettyprint();
    return
end
% Next try Java classes
klass = [];
try
    klass = jl.util.java.classForName(className);
catch
    % quash
end
if ~isempty(klass)
    tree = inhtreeForJavaClass(klass);
    tree.prettyprint();
    return
end

error('Could not resolve class: %s', className);

end

function out = inhtreeForMatlabClass(klass)
rootNode = inhtreeNodeForMatlabClass(klass);
out = jl.types.NaryTree;
out.rootNode = rootNode;
end

function node = inhtreeNodeForMatlabClass(klass)
node = jl.types.NaryTreeNode(klass.Name);
supers = klass.SuperclassList();
for i = 1:numel(supers)
    node.children(end+1) = inhtreeNodeForMatlabClass(supers(i));
end
end

function out = inhtreeForJavaClass(klass)
rootNode = inhtreeNodeForJavaClass(klass);
out = jl.types.NaryTree;
out.rootNode = rootNode;
end

function node = inhtreeNodeForJavaClass(klass)
if klass.isInterface()
    descr = [ '[' char(klass.getName()) ']' ];
else
    descr = char(klass.getName());
end
node = jl.types.NaryTreeNode(descr);
interfaces = klass.getInterfaces();
for i = 1:numel(interfaces)
    interface = interfaces(i);
    node.children(end+1) = inhtreeNodeForJavaClass(interface);
end
super = klass.getSuperclass();
if ~isempty(super)
    node.children(end+1) = inhtreeNodeForJavaClass(super);
end
end


