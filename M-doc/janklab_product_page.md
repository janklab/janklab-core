# Janklab

Janklab is a general-purpose library of functions, classes, and  extensions for Matlab. It is informed by my background in quantitive analysis for finance, but should be useful in other application areas as well. It is designed for both interactive Matlab use and for building  applications and production Matlab code.

See <https://github.com/apjanke/janklab> for details and more documentation.

## Getting Started

Once you've installed Janklab, run `init_janklab` in Matlab.

## Features

* New general-purpose "computer sciencey" data structures and functions
* Excel I/O for programmatic reading and writing without needing the Excel application
* MDBC, an enhancement to the Database Toolbox
* The Dispstr API for customized object display
* Extension to Matlab’s validator functions
* A nicer XML reading API
* Some additional date/time classes
* Lots of miscellaneous functions and objects

## Setup

You must call the `init_janklab` function before using the stuff in this Toolbox. Janklab needs to do some initialization work that is not taken care of by the Matlab Toolbox mechanism itself.

If you want to use the MDBC Database Toolbox extension, you will need to install JDBC drivers for the database servers you want to connect to and get them on your Matlab JAVACLASSPATH. See `doc javaclasspath` for info on how to do this.

## License

Janklab is licensed under the Apache License 2.0.
Janklab is redistributed with libraries that are licensed under various licenses. These include:

* Swing Explorer - LGPL 3.0
* Apache Commons CSV - Apache License 2.0
* Apache Commons Primitives - Apache License 2.0
* FastUtil - Apache License 2.0

## Examples

Coming soon, hopefully!

## Contact and Support

Janklab’s author is Andrew Janke. You can contact him at floss@apjanke.net.

For support, including bug reports and feature requests, post an Issue on the project’s GitHub Issue Tracker at <https://github.com/apjanke/janklab/issues>.
