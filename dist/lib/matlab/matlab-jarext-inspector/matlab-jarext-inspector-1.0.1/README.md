matlab-jarext-inspector
=========================

Lists Matlab's bundled third-party Java libraries and their version info.

Matlab comes bundled with many third-party Java libraries. If you're writing Matlab/Java code, it's useful to know which libraries are bundled with Matlab and which versions they are, so you can determine compatibility with your custom Java code and third-party libraries you want to pull in.

This program inspects Matlab to determine which Java libraries it includes, extracts their metadata to see what version etc they are, and checks them against the Maven Central Repo to see where they're available.

The project home is [matlab-jarext-inspector on GitHub](https://github.com/apjanke/matlab-jarext-inspector).

##  Usage

```
  jarInfo = listJarExtInfo;
  fprintf('Found %d JAR libs\n', size(jarInfo,1));
```
Then open your Workspace view and double-click the jarInfo variable to view it as a table.

The program is located in the `Mcode/` folder in the repo or distribution.

###  Data Dictionary

The output table contains at least the following columns:

| Column  | Contents  |
| ------------- | ------------- |
| File    | The path to the JAR file, relative to the Matlab `jarext` directory |
| Title   | The title of the library |
| Vendor  | The name of the vendor, as extracted from the JAR metadata |
| Version | The version of the library |
| MavenGroup | The group id of the JAR detected on Maven |
| MavenArtifact | The artifact id of the JAR detected on Maven |
| MavenVersion | The version of the JAR detected on Maven |
| MavenRelDate | The release date of this JAR, as posted on Maven |
| MavenRecentestVer | The most recent version of the same group/artifact on Maven |
| MavenRecentestDate | The release date of the most recent version of this group/artifact on Maven |

See the `listJarExtInfo` helptext and source for more details.

##  Issues

Not all of the JARs included with Matlab have included metadata or are present on Maven Central, so some of them can't be identified.

The libraries on Maven are detected by SHA checksum matching, so it may not pick up the canonical version of the library there.

##  Author

`matlab-jarext-inspector` is written by [Andrew Janke](https://apjanke.net).
