# Janklab-core

Janklab-core is a general-purpose library of functions, classes, and extensions for Matlab. It is the main "utility" library in the [Janklab](https://janklab.net) library suite.

Janklab is informed by my background in quantitive analysis for finance, but should be useful in other application areas as well. It is designed for both interactive Matlab use and for building applications and production Matlab code.

Janklab-core is not a standalone application. It requires Matlab or the Matlab Compiler Runtime.

Janklab-core provides:

* Extended type system
* Additional date/time classes
* A Database Toolbox (“MDBC”) with increased performance and features
* Advanced Excel I/O suitable for server-side use
* Advanced FTP client
* More validators
* A bunch of miscellaneous utilities

See [Feature Areas](docs/Feature-Areas.md) for details.

## License

Apache 2.0, with other FOSS licenses for dependencies.

Janklab is licensed under the liberal, business-friendly Apache 2.0 License. You should be able to use it in most any application or environment, as long as you include the information from `NOTICE.txt` in your source distribution and/or user interface.

Janklab-core depends on and is redistributed with third-party libraries, some of which are covered under other FOSS licenses.

* FastUtil - Apache License
* Apache Commons - Apache License
* SwingExplorer - LGPL
* Dispstr - BSD 2-Clause License

## Contributing

Janklab is a personal project, not a community one. Bug reports and feature requests are welcome, but I will probably not accept major PRs. See [CONTRIBUTING](.github/CONTRIBUTING.md) for details.

## Installation and use

### Installing as a Matlab Toolbox

You can install Janklab-core as a Matlab Toolbox by downloading the `.mltbx` file from one of the [releases](https://github.com/janklab/janklab-core/releases) and opening that file in Matlab to install it.

You can download the current release directly from: <https://github.com/janklab/janklab-core/releases/download/v0.2.2/Janklab-0.2.2.mltbx>

You must run `init_janklab` inside your Matlab session to initialize the library before using it.

### Installing from a release

You can also use Janklab-core without installing it as a Matlab Toolbox. Download the [source code archive](https://github.com/janklab/janklab-core/archive/v0.2.2.zip) from one of the [releases](https://github.com/janklab/janklab-core/releases) and extract it to somewhere on your computer’s hard drive.

In your Matlab session, run the `init_janklab` function found under `dist/Mcode/toplevel` in the repo.

```matlab
% Example initialization script
oldDir = pwd;

cd /path/to/janklab/installation/janklab-core/Mcode/toplevel
init_janklab

cd(oldDir)
```

### Running from the repo

If you want the current development version of Janklab-core, install it to your local system by cloning the Git repo.

```bash
git clone https://github.com/apjanke/janklab
```

In your Matlab session, run the `init_janklab` function found under `dist/Mcode/toplevel` in the repo.

```matlab
% Example initialization script
oldDir = pwd;

cd /path/to/janklab/installation/janklab-core/Mcode/toplevel
init_janklab

cd(oldDir)
```

## Compatibility

Janklab requires Matlab R2019b or later, though parts of it may work on earlier versions of Matlab. Future Janklab releases will target newer versions of Matlab, and make use of their new features, so some features of Janklab may require later versions of Matlab.

Extended support of older Matlab versions is not a goal of Janklab. I haven't decided how long older versions of Matlab will be supported, but it's not going to be measured in years.

### Octave compatibility

Parts of Janklab are compatible with GNU Octave; others are not. If you're interested in seeing a particular part work under Octave, let me know.

Janklab makes extensive use of some features not supported by Octave. Parts using these won't be made Octave-compatible unless Octave grows support for them. Features:

* Dot-style Java class references
* `table`
* `datetime`
* Handle object destructors

## Author

Janklab is made by [Andrew Janke](https://apjanke.net).

The project home page is the [Janklab repo on GitHub](https://github.com/apjanke/janklab).

Thanks to [Polkadot Stingray](https://www.facebook.com/polkadotstingray/) for powering my coding.
