Exiv2 for Native Client
=======================

This is a contribution to naclports, the collection of
ports of various open-source projects to Native Client.
 https://code.google.com/p/naclports/

The enclosed files extend naclports to build the Exiv2 
library, an image metadata library that supports the
commonly used metadata standards Exif, IPTC and XMP.
 http://www.exiv2.org/

Contents of this directory allow to build:
* Exiv2 library, version 0.23
    * PNG support
    * XMP metadata support

What does it NOT include:
* Exiv2 CLI
  Just use the library in another binary or use 
  a wrapper to use the library from Javascript.

What we did not test:
* Native language support
  gettext is only included in the glibc toolchain,
  while we only used newlib toolchain and no NLS.
  Exiv2 builds with both toolchains.

Requirements provided by naclports:
* expat
* jsoncpp
* zlib

How to build (pepper33)
* recursively copy ports/exiv2 to your copy of naclports (src/ports)
* build via *make exiv2* or *./make-all.sh exiv2*
    * this will build dependencies also

We originally created this port to include Exiv2 in a
Chrome extension, and by this allow the support of all
metadata standards mentioned before, while other 
Javascript-based solutions lack of such support.

The port was done in the context of privacy research
at the *Distributed Computing & Security Group* 
of the *Leibniz Universität Hannover*, Germany.
The original port was done as part of the
bachelor thesis of Maximilian Koch, which was
advised by Benjamin Henne.

http://www.dcsec.uni-hannover.de/
henne@dcsec.uni-hannover.de
