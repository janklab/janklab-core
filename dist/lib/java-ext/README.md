# java-ext

This is a directory where you can drop third-party/external JARs to be loaded by
Janklab, and they won't get checked in to the Git repo.

There's also a sketchy utility in dev-kit to download well-known JARs to this
directory, particularly for JDBC drivers.

All JARs in this directory will be loaded in to the Java classpath at Janklab
initialization time.

This mechanism is a work in progress.
