# Janklab

Janklab is a general-purpose library of functions, classes, and extensions for Matlab. It is informed by my background in quantitive analysis for finance, but should be useful in other application areas as well. It is designed for both interactive Matlab use and for building applications.

Janklab is not a standalone system. It requires Matlab or the Matlab Compiler Runtime.

See [Feature Areas](doc/Feature_Areas.md) to learn what Janklab provides.

##  License

Janklab is licensed under the liberal, business-friendly Apache 2.0 License. You should be able to use it in most any application or environment, as long as you include the information from `NOTICE.txt` in your source distribution and/or user interface.

The Janklab code itself is licensed under the Apache 2.0 license. Janklab includes and is redistributed with third-party software, also covered by the Apache license.

Janklab also includes a redistribution of the ThreeTenBackport project's binary distribution, which is Copyright (c) 2007-present, Stephen Colebourne & Michael Nascimento Santos. The redistribution terms for ThreeTenBackport are contained in the `LICENSE-ThreeTenBackport.txt` file.

##  Contributing

Janklab is a personal project, not a community one. Bug reports and feature requests are welcome, but I will probably not accept major PRs. See [CONTRIBUTING](.github/CONTRIBUTING.md) for details.

##  Installation and use

To use Janklab, install it to your local system by cloning the Git repo. In your Matlab session, run the `init_janklab` function found under `dist/Mcode/` in the repo. You can also use the initialization functions found in `bootstrap/`.

You should also configure logging by calling one of the `configureXxx()` methods in `jl.log.Configurator`.

```
% Example initialization script

cd /path/to/janklab/installation/janklab/bootstrap
init_janklab

jl.log.Configurator.configureBasicConsoleLogging()

format compact
```

Janklab requires and is developed on Matlab R2016b, though parts of it may well work on earlier versions of Matlab. Future Janklab releases will target newer versions of Matlab, and make use of their new features. If something in Janklab actually requires a later version of Matlab, that is a bug, and feel free to report it.
