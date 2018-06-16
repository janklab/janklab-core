# Janklab

Janklab is a general-purpose library of functions, classes, and extensions for Matlab. It is informed by my background in quantitive analysis for finance, but should be useful in other application areas as well. It is designed for both interactive Matlab use and for building applications and production Matlab code.

Janklab is not a standalone application. It requires Matlab or the Matlab Compiler Runtime.

See [Feature Areas](doc/Feature-Areas.md) to learn what Janklab provides.

##  License

Apache 2.0, with other FOSS licenses for dependencies.

Janklab is licensed under the liberal, business-friendly Apache 2.0 License. You should be able to use it in most any application or environment, as long as you include the information from `NOTICE.txt` in your source distribution and/or user interface.

Janklab depends on and is redistributed with third-party libraries, some of which are covered under other FOSS licenses.

* FastUtil - Apache License
* Apache Commons - Apache License
* SwingExplorer - LGPL
* Dispstr - BSD 2-Clause License

##  Contributing

Janklab is a personal project, not a community one. Bug reports and feature requests are welcome, but I will probably not accept major PRs. See [CONTRIBUTING](.github/CONTRIBUTING.md) for details.

##  Installation and use

To use Janklab, install it to your local system by cloning the Git repo. In your Matlab session, run the `init_janklab` function found under `dist/Mcode/` in the repo. You can also use the initialization functions found in `bootstrap/`.

```
% Example initialization script
oldDir = pwd;

cd /path/to/janklab/installation/janklab/bootstrap
init_janklab

cd(oldDir)
```

##  Compatibility

Janklab requires Matlab R2017b or later, though parts of it may work on earlier versions of Matlab. Future Janklab releases will target newer versions of Matlab, and make use of their new features, so some features of Janklab may require later versions of Matlab.

Extended support of older Matlab versions is not a goal of Janklab. I haven't decided how long older versions of Matlab will be supported, but it's not going to be measured in years.
