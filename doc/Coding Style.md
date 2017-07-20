#  Coding Style and Approach

* Failures are indicated with errors (exceptions), not return codes that need to be checked.
 * Except for tasks inside UIs that need to be reported back to the user, in which case the status and result are both wrapped in a single return object.
* Do not change output types or structure based on whether inputs are scalar.
* Prefer OOP approaches instead of sets of related functions, in general.

##  Formatting

* alllowercase or TitleCase class names
* alllowercase function and method names
 * (or should we use camelCase or snake_case?)
* snake_case local variable and helper function names
* Indent with tabs, not spaces.
 * Assume a two-space tab display width, if it matters

##  Naming conventions

* `this` - the method dispatch object in an instance method
 * `obj` - an older name used in place of `this`
* `tf` - a logical array, indicating whether a test was met
* `loc` - an array of indexes indicating the location of something
* `i`, `j` - loop indexes
 * I use `i` and `j` as loop indexes even though they mask the `i` and `j` functions. Imaginary values can still be constructed with the `1i` syntax.
* `iFoo` - an index into `foo`, usually used in iteration
* `ixFoo` - an array of indexes into `foo`
* `r` - a relation held in a local variable
* `RAII` - a struct holding cleanup objects used for RAII style ("Resource Acquisition Is Initialization") cleanup
