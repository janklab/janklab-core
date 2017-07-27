# Janklab

Janklab is a general-purpose library of functions, classes, and extensions for Matlab. It is informed by my background in quantitive analysis for finance, but should be useful in other application areas as well. It is designed for both interactive Matlab use and for building applications.

Janklab is not a standalone system. It requires Matlab or the Matlab Compiler Runtime.

See [Feature Areas](doc/Feature Areas.md) to learn what Janklab provides.

##  License

Janklab is licensed under the liberal, business-friendly Apache 2.0 License. You should be able to use it in most any application or environment, as long as you include the information from `NOTICE.txt` in your source distribution and/or user interface.

The Janklab code itself is licensed under the Apache 2.0 license. Janklab includes and is redistributed with third-party software, also covered by the Apache license.

##  Contributing

Janklab is a personal project, not a community one. Bug reports and feature requests are welcome, but I will probably not accept major PRs. See [.github/CONTRIBUTING.md].

##  Installation and use

To use Janklab, install it to your local system by cloning the Git repo. In your Matlab session, run the `init_janklab` function found under `dist/Mcode/` in the repo. You can also use the initialization functions found in `bootstrap/`.

Janklab requires and is developed on Matlab R2017b, though parts of it may well work on earlier versions of Matlab. Future Janklab releases will target newer versions of Matlab, and make use of their new features.
