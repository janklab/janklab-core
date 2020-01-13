Janklab TODO
============

### Usability

* Documentation
  * Documentation for MDBC

### Features

* Graphviz support, with class inheritance & structure diagrams
  * Generic Graphviz wrapper API
  * Class diagram generation code

### Code

* Add spaces between output arguments in planargen code.
* Change `isna` to be Octave-compatible, and respect the new `ismissing` indicators in recent Matlab versions.
* Refactor the validators to just do all the name-gathering and message construction inline; it’s not worth having that `reportBadValue`; its error messages just aren’t flexible enough.
* Maybe rename `nop` to `pass` to be like Python
* `cmp`/`valcmp` support for strings and cellstrs
* Rename `slurp`/`spew` to `fileread`/`filewrite`, to be like Octave?
  * Oh wait, Matlab has `fileread` now. So, probably should be `filewrite`, and ditch `slurp`.
* Build `binsearch_mex` on Windows and Linux
* Rename `dataarray` to `xarray` and fix it up
