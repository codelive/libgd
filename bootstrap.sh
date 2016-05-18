#!/bin/sh --
# $Id$
# Small shell script to build gd from source

# Generate the manual (unless naturaldocs isn't installed).  Source
# dists should include the docs so that end users don't need to
# install naturaldocs.  At the same time, we tolerate it being missing
# so that random hackers don't need it just to build the code.
if which naturaldocs >/dev/null 2>&1 ; then
	echo "Generation user docs:"
	(cd docs/naturaldocs; bash run_docs.sh)
else
	echo "Can't find naturaldocs; not generating user manual."
fi


if echo "${OSTYPE:-$(uname)}" | grep -q '^darwin' ; then
	echo "Having trouble on OS X? Try: brew install autoconf libtool automake gettext apple-gcc42 pkg-config cmake"
fi

echo "autoreconf -f -i"
if ! autoreconf -f -i ; then
	exit 1
fi

sed \
	-e '1d' \
	-e '2i/* Generated from config.hin via autoheader for cmake; see bootstraps.h. */' \
	-e 's:#undef:#cmakedefine:' \
	src/config.hin > src/config.h.cmake
