function genPlanarClass(file)
%GENPLANARCLASS Generate boilerplate code for a planar-organized class
%
% genPlanarClass(file)
%
% Generates boilerplate method definitions for a planar-organized class. This is
% a tool to make it easy to define planar-organized classes, which require many
% standard functions to be overridden in order to work properly. A
% planar-organized class is one whose fields contain arrays, where the i-the
% element of each array corresponds to each other and is to be read as a record.
% (This is like column-organized storage in a database.) Planar-organized
% objects are the way to make user-defined objects in Matlab fast.
%
% GenPlanarClass() will generate definitions for many common structural-manipulation
% methods, like size(), ndims(), cat(), repmat(), circshift(), subsref(), and 
% so on. It can also generate relational operations (eq(), le(), gt(), etc.) and
% set/ordering operations (sort(), ismember(), unique(), setdiff(), etc.).
%
% In your class definition, annotate planar-organized properties with the
% "@planar" attribute in a comment, like so:
%
%     classdef MyClass
%         properties
%             foo  % @planar
%             bar  % @planar
%             baz
%         end
%     end
%
% Annotations supported:
%   Property level:
%      @planar
%      @planarnanflag
%      @planarnonan
%   Class level:
%      @planarprecedence(...)
%      @planarsetops
%
%   @planar  - Flags a field as planar-organized, causing it to be included in
%       structure-manipulation operations.
%   @planarnanflag  - Indicates this field is a planar logical array indicating
%       if the array elements are to be considered NaN.
%   @planarnonan  - Declares that this field is of a type that does not support
%       isnan(), so isnan() should not be called on it, and its values should always
%       be considered non-NaN.
%   @planarprecedence(...)  - Defines the precedence of @planar fields for use
%       in sorting and comparison operations.
%   @planarsetops  - Causes the set operations (sort, unique, ismember, setdiff,
%       union, and intersect) to be generated. Requires @planarprecedence to be
%       defined. (Maybe this should be the default, actually.)
%
% Properties without a "@planar" annotation are assumed to be shared across the
% entire array, and not planar-organized. They are ignored and just carried
% along from the first object in a functions input arguments. (That's kind of
% sloppy; this behavior may be changed in the future.)
%
% The @planarprecedence(...) annotation defines the precedence order of the
% fields when they are considered for relops (<, >, <=, >=) and sorting. If this
% annotation is defined, then relop methods will be generated.
%
% If @planarsetops is defined, you must define a `proxyKeys(a, b)` method in your
% class. This method must take two arrays of your class, and return a
% n-by-k numeric array, where n = numel(a) + numel(b), and k is any number >= 1
% that you want. These key arrays will be used with `sortrows()` and
% `ismember(..., 'rows')` to determine ordering and set membership.
%
% This modifies the target file in-place. If there are existing genPlanarClass
% boilerplate definitions in the file, they will be replaced. If there aren't
% any, they will be added.
%
% You may define your own custom subsref() and/or subsasgn() methods outside the
% boilerplate code. In this case, genPlanarClass() will not generate them, but
% will only generate subsasgnParensPlanar() and subsrefParensPlanar() for you to
% call from within your custom subsref() or subsasgn().
%
% GenPlanarClass requires your existing class definition file to be valid. If
% there are syntax errors in it, genPlanarClass will error out. (This is a
% bummer if genPlanarClass() itself is buggy and produces invalid code. In that
% case, just delete everything in the boilerplate section and re-run it.)
%
% Remember: When defining a planar class and overriding subsref, ()-indexing
% within the class is not going to do what you want. Instead of doing
% "out = this(ix)", you need to call "out = parensRef(this, ix)".
%
% Bugs and Issues:
%  - Support for handle classes is incomplete.
%  - Does not support superclasses that also have planar fields.
%  - If your class definition has local functions, then the first time you
%    generate the definitions, the boilerplate code will end up in the wrong
%    place. Just cut and paste it to its proper place, and it'll stick there on
%    future regenerations.
%  - TODO: Decide whether subclasses should be allowed to do relops (==, <=,
%    etc) against superclasses. It's probably not legit.
%  - TODO: Detect user-defined versions of generatable methods and skip
%    generation (maybe). This would support things like optimized CMP
%    implementations.
%  - TODO: 'rows' and 'stable' variants of set operations
%  - Some of the generated relop method implementations are suboptimal. I'm
%    focused on getting the semantics and interface correct first, and 
%    optimizing later.
%  - Implementation: the subst() and perfield() functions are copy-pasted
%    across multiple methods. Gross.
%  - TODO: Decide whether having one field component be NaN makes the whole
%    value NaN, or if that's only for one-field components, and the
%    planarnanflag is what really indicates NaN-ness.
%  - TODO: In cmp(), should NaNs sort to the end, as they do in sort()? Unclear
%    what the right thing to do here is, since NaN < NaN, NaN > NaN, and NaN ==
%    NaN all return false. Maybe should support 'MissingPlacement' like sort()
%    does.
%  - sort() does not implement 'MissingPlacement' or 'ComparisonMethod'.
%  - TODO: issorted(), sortrows(), min(), max(), mink(), maxk()
%
% Examples:
%
% jl.code.genPlanarClass('MyPlanarClass.m')

generator = jl.code.internal.PlanarClassGenerator;

generator.genBoilerplate(file);

end