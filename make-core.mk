#
# Generic make helpers
#
# Copyright (c) 2006-2019 Alexei A. Smekalkine <ikle@ikle.ru>
#
# SPDX-License-Identifier: BSD-2-Clause
#

#
# target paths
#

PREFIX	?= /usr
BINDIR	?= $(PREFIX)/bin
DESTDIR	?=

#
# build tools
#

RANLIB	?= ranlib

#
# guarantie default target
#

.PHONY: all clean install

all:

#
# source and target file filters
#

SOURCES	= $(filter-out %-main.c, $(wildcard *.c))
OBJECTS	= $(patsubst %.c,%.o, $(SOURCES))
TOOLS	= $(patsubst %-main.c,%, $(wildcard *-main.c))

#
# rules to manage base library
#

%.a:
	$(AR) rc $@ $^
	$(RANLIB) $@

.PHONY: clean-static

AFILE	= bundle.a

$(AFILE): $(OBJECTS)

clean: clean-static

clean-static:
	$(RM) $(AFILE) $(OBJECTS)

#
# rules to manage tools (ordinary programs)
#

%: %-main.c
	$(CC) $(CFLAGS) $(LDFLAGS) -o $@ $^

.PHONY: build-tools clean-tools install-tools

all:     build-tools
clean:   clean-tools
install: install-tools

$(TOOLS): $(AFILE)

build-tools: $(TOOLS)
clean-tools:
	$(RM) $(TOOLS)

install-tools: build-tools
	install -d $(DESTDIR)$(BINDIR)
	install -m 755 $(TOOLS) $(DESTDIR)$(BINDIR)
