classdef nil
    % A "null" value that means "use the default value" for arguments and properties.
    %
    % The nil class is a special placeholder value that is passed to function
    % arguments, object properties, and other. It is an indicator that the
    % default value for that argument, property, or other thing should be used.
    %
    % A nil has no state or value. All nil values and instances are 
    % entirely equivalent, and should be treated as such. The only test code
    % should do on nil values is the ISNIL function; other operations on it are
    % meaningless and should generally be avoided.
    %
    % A nil is not the same as a Matlab missing value (whether that's of the
    % particular type "missing", or a missing value of a class like datetime or
    % string that supports missing-element semantics), or an empty array like
    % [].
    %
    % The main reason for nil to exist is to support optional arguments in
    % functions. In Matlab, you can omit trailing arguments in a function call,
    % and those are not supplied to the function at all. This "not supplied"
    % status or behavior is distinct from any value that can be passed in to an
    % argument. The issue is that Matlab function parameters are positional, and
    % you can only omit trailing arguments. You cannot omit an argument and also
    % provide a later argument. (Unless you use the new name/value argument
    % syntax from Matlab R2021b or so, but that has some drawbacks, and in some
    % places the positional parameter calling form is preferable.)
    %
    % For example, say you have a function with five argin parameters:
    %
    %     function out = foo(a, b, c, d, e)
    %
    % And let's say you have values you want to supply for a, d, and e, but you
    % want to use the default values for b and c. That is, you wish the function
    % would treat your b and c as if you had called it with one argument like
    % `foo(a)`, but you also want to specify values it should use for d and e.
    % There's no good way in Matlab to do that.
    %
    % If the caller knows what the default value is, they can just choose to
    % pass that value in explicitly. But that's inconvenient: it may be a long
    % expression to type out. And the caller might not even know, or be able to
    % know what the default value should be: The default value for an argument
    % is an aspect of the internal behavior of that function. It may or may not
    % be documented, and that documentation may not be correct. The default
    % value behavior may change over time, and it may not be easy or even
    % possible to coordinate the version of the caller code with the version of
    % the calling code, especially if they're in different libraries, or if the
    % default value depends on some state that only the callee function has
    % access to.
    %
    % It is conventional in some Matlab code bases to use the empty numeric
    % array [] as a placeholder argument that means "do the default, as if I had
    % omitted this argument". But that's not a great approach, because there's
    % ambiguity: an empty [] array is a totally valid value in many contexts; it
    % can mean the empty set or something similar. Functions which adopt [] as a
    % "default" indcator have trouble determining whether a caller passing []
    % means "do the default" or "I mean the empty set here". This is a common
    % problem when a function takes arguments that serve as filtering or
    % selection criteria specifications. [] could mean "none", but the default
    % behavior for filter arguments is usually "any".
    %
    % NIL ARRAY SIZES
    %
    % The size of a nil array is not meaningful. We might have defined nil to
    % only ever be a scalar, and not support nonscalar construction. But there
    % are certain cases where a nil array of a particular size is necessary to
    % allow certain assignments. For example, if a function argument or object
    % property have size validators defined on them, nil must support being of
    % that size in order to be passed or assigned to them.
    %
    % Could shouldn't test the size of nil values or define any behavior that is
    % conditional upon the size or dimensionality of a nil value.
    %
    % RETURNING NIL
    %
    % I haven't decided whether it's appropriate to return nil from functions in
    % any circumstances, except for use in little internal helper functions.
    % 
    % SUPPORTING NIL
    %
    % Functions and classes that wish to support nil behavior should do so in
    % the following ways.
    %
    % Functions that allow nil for arguments should replace the nil value with
    % the default value for that argument immediately at the beginning of the
    % function. The "default value" should be exactly what is used in the case
    % when that argument is omitted. This means that it needs to be exactly the
    % same as what is in the "= <defaultvalue>" expression in arguments block
    % expressions defining default values; copy and paste that code.
    %
    % Functions with arguments whose default values depend on the values of
    % other arguments and whether those arguments are supplied may need to use
    % fancy logic to compute all the default values, taking in to account the
    % nilness/omittedness of each argument, before actually assigning those
    % default values to the various variables.
    %
    % Classes which support nil for their properties may accept nil for both
    % constructor arguments that determine those property values, and for
    % assignment to the properties. When nil is assigned to a property, it
    % should generally be immediately replaced with that property's default
    % values. This will probably require the class to implement set.<property>
    % methods for all its properties which support nil assignment. Sorry.
    %
    % When we talk about "default value" here, we mean the default value that is
    % assigned to an argument at function call time or a property at object
    % construction time. Nil should not be used as a value to indicate "do the
    % default behavior" or "use the default selection method" for properties 
    % that control object behavior. For example, let's say you have a function
    % that formats SQL expressions:
    %
    %     function out = formatSql(Filter, Style)
    %
    % And there are three variants of Style: a default style, a "loose" style
    % with more whitespace, and a "compact" style that is a one-line statement.
    % This function should not use nil internally to indicate that it's doing
    % the default style (by holding on to nil in the Style variable); instead
    % it should use the string "default" in addition to "loose" and "compact",
    % and when nil gets passed in to the Style argument, it should immediately
    % be replaced by the string "default" at the beginning of the function.
    %
    % Similarly, if this were a SqlFormatter class instead, and it had a Style
    % property:
    %
    %     classdef SqlFormatter
    %         properties
    %             property Style (1,1) = "default"
    %         end
    %         methods
    %             function formatSql(obj)
    %                 % Respects obj.Style in its behavior
    %             end
    %         end
    %     end
    %
    % Then if Style is set to nil, it shouldn't be left as nil, and have
    % formatSql check `if isnil(obj.Style)` to see if it should do the default
    % style. Instead, SqlFormatter should have a `set.Style(obj, NewVal)` setter
    % method that does `obj.Style = "default"` when NewVal is nil.
    %
    % It can be convenient to stick the default values for properties in
    % Constant properties, so you don't have repeated code from copy-pasting the
    % default value expression in multiple places. If you do this, you can't use
    % "= <default>" default definitions in the property declaration, though,
    % because they can't reference Constant properties (I think). This is a
    % limitation of the Matlab language. Instead, you'll need to assign them in
    % the constructor.
    %
    %     classdef SqlFormatter
    %         properties (Constant, Hidden, Access = protected)
    %             property DefaultStyleValue = "default"
    %         end
    %         properties
    %             property Style (1,1)
    %         end
    %         methods
    %             function obj = SqlFormatter()
    %                 obj.Style = obj.DefaultStyleValue;
    %             end
    %             function obj = set.Style(NewValue)
    %                 if isnil(NewValue)
    %                     obj.Style = obj.DefaultStyleValue;
    %             end
    %             function formatSql(obj, Filter)
    %                 % Respects obj.Style in its behavior
    %             end
    %         end
    %     end
    %
    % PLACEHOLDER FOR UNINITIALIZED VALUES
    %
    % I'm still considering whether it would be appropriate to use nil as a
    % placeholder for "uninitialized" variables, in addition to its "do the
    % default" meaning for arguments and property assignment. It could be
    % useful to have that: Lots of Matlab code, including Matlab's own
    % `persistent` mechanism and object property defaults, uses [] as the 
    % placeholder for an uninitialized value. But there are cases when an
    % empty [] is valid as an initialized value, and has a distinct meaning
    % from "uninitialized", or your code might need to take expensive
    % actions to do the initialization, and you don't want to repeat them
    % if you have an actually-initialized [] that looks uninitialized. You
    % can accomplish this by using separate "isFooInitialized" variables,
    % but that's kind of cumbersome.
    %
    % See also:
    % isnil
    
    %#ok<*INUSL>
    
    methods
        
        function disp(this)
            % Custom object display.
            if isscalar(this)
                disp('  nil');
            else
                fprintf('  nil (%s)\n', size2str(size(this)));
            end
        end
        
        function out = reshape(this, sz)
            % Change size of array.
            %
            % out = reshape(this, sz)
            %
            % Any nil array can be reshaped to any size, even if that
            % changes the number of elements in it.
            out = repmat(nil, sz);
        end
        
    end
    
end

% Local copy of dependent functions, so I can send around the nil.m and
% isnil.m definitions without the rest of the Janklab source code.

function out = size2str(sz)
%SIZE2STR Format an array size for display
%
% out = size2str(sz)
%
% Sz is an array of dimension sizes, in the format returned by SIZE.
%
% Examples:
%
% size2str(size(magic(3)))

strs = cell(size(sz));
for i = 1:numel(sz)
	strs{i} = sprintf('%d', sz(i));
end

out = strjoin(strs, '-by-');

end

