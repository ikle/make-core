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
INCDIR	?= $(PREFIX)/include
LIBDIR	?= $(PREFIX)/lib/$(MULTIARCH)
BINDIR	?= $(PREFIX)/bin
SBINDIR	?= $(PREFIX)/sbin
DESTDIR	?=

#
# guarantie default target
#

.PHONY: all clean install

all:

#
# source and target file filters
#

HEADERS	= $(filter-out %-int.h, $(wildcard *.h))
SOURCES	= $(filter-out %-main.c %-service.c, $(wildcard *.c))
OBJECTS	= $(patsubst %.c,%.o, $(SOURCES))

TOOLS	= $(patsubst %-main.c,%, $(wildcard *-main.c))
SERVICES = $(patsubst %-service.c,%, $(wildcard *-service.c))

#
# rules to manage static libraries
#

%.a:
	$(AR) rc $@ $^

.PHONY: install-headers
.PHONY: build-static clean-static install-static

ifdef LIBNAME

AFILE	= lib$(LIBNAME).a
LIBVER	?= 0
LIBREV	?= 0.1

install: install-headers

install-headers:
	install -d $(DESTDIR)$(INCDIR)/$(LIBNAME)-$(LIBVER)
	install -m 644 $(HEADERS) $(DESTDIR)$(INCDIR)/$(LIBNAME)-$(LIBVER)

all:     build-static
install: install-static

install-static: $(AFILE)
	install -d $(DESTDIR)$(LIBDIR)
	install -m 644 $(AFILE) $(DESTDIR)$(LIBDIR)

else  # not defined LIBNAME

AFILE	= bundle.a

endif  # LIBNAME

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

#
# rules to manage services (system programs)
#

%: %-service.c
	$(CC) $(CFLAGS) $(LDFLAGS) -o $@ $^

.PHONY: build-services clean-services install-services

all:     build-services
clean:   clean-services
install: install-services

$(SERVICES): $(AFILE)

build-services: $(SERVICES)
clean-services:
	$(RM) $(SERVICES)

install-services: build-services
	install -d $(DESTDIR)$(SBINDIR)
	install -m 755 $(SERVICES) $(DESTDIR)$(SBINDIR)
