#  Coding Style and Approach

* Failures are generally indicated with errors (exceptions), not return codes that need to be checked.
 * Except for tasks inside UIs that need to be reported back to the user, in which case the status and result are both wrapped in a single return object.
* Do not change output types or structure based on whether inputs are scalar vs. non-scalar.
* Prefer OOP approaches instead of sets of related functions, in general.
* M-Lint-warning-clean
 * All M-Lint warnings should be suppressed (in the source files, not your Matlab configuration) or worked around.

##  Formatting

* alllowercase or TitleCase class names
* alllowercase function and method names
 * (or should we use camelCase or snake_case?)
* snake_case local variable and helper function names
* Indent with tabs, not spaces.
 * Assume a two-space tab display width, if it matters
* 80-character lines.
* Spacing
 * No space between function name and open paren in function calls
 * Spaces after commas between function arguments
 * Spaces after commas between argouts in multi-argout lists
 * No spaces after commas in array indexing calls

###  Matlab Editor Configuration for Formatting

* Wrap comments at 80 characters.
* Display line guide at 80 characters.
* Suppresss "input argument 'this' is unused" in all files

##  Naming conventions

* `this` - the method dispatch object in an instance method
 * `obj` - an older name used in place of `this` (DEPRECATED)
* `tf` - a logical array, indicating whether a test was met
* `loc` - an array of indexes indicating the location of something
* `i`, `j` - loop indexes
 * Yes, I use `i` and `j` as loop indexes even though they mask the `i` and `j` functions. Imaginary values can still be constructed with the `1i` syntax.
* `iFoo` - an index into `foo`, usually used in iteration
* `ixFoo` - an array of indexes into `foo`
* `t` or `tbl` – a temporary or generic table array
* `RAII` - a struct holding cleanup objects used for RAII style ("Resource Acquisition Is Initialization") cleanup
