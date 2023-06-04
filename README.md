# libfig (libfigpar + libfigput)

This repository consists of the **_libfigpar_** and **_libfigput_** libraries
from the FreeBSD Project. libfigpar is config file parser and libfigput config
file modifier. They are originally part of the FreeBSD Project and are used
widely within that context — libfigput is not yet finalised and is still under
development, though.

In FreeBSD, the build system for these libraries is based on **bsd.lib.mk**, a
makefile included in the base system providing a lot of common functionality for
building libraries. However, bsd.lib.mk and the build process around it are
specific to FreeBSD, creating portability issues when attempting to use these
libraries as is on other systems.

This libfig repository is an attempt to make these useful libraries easily
available on other systems for development or use purposes.
