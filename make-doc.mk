#
# Colibri Build System: Documentation
#
# Copyright (c) 2006-2022 Alexei A. Smekalkine <ikle@ikle.ru>
#
# SPDX-License-Identifier: BSD-2-Clause
#

#
# target paths
#

PREFIX  ?= /usr
DOCDIR  ?= $(PREFIX)/share/doc
DESTDIR ?=

#
# guarantie default target
#

.PHONY: all clean install doc

all:

#
# source and target file filters
#

DOCS	+= $(wildcard doc/html/*.html doc/html/*.css doc/html/*.png)

ifdef LIBNAME

.PHONY: build-doc clean-doc install-doc

doc: build-doc

build-doc:
	mkdir -p doc/html
	gtkdoc-scan --module=$(LIBNAME) \
		--source-dir=. --output-dir=doc/db --rebuild-sections
	(cd doc/db && gtkdoc-mkdb --module=$(LIBNAME) --source-dir=$(CURDIR))
	(cd doc/html && \
	gtkdoc-mkhtml $(LIBNAME) $(CURDIR)/doc/db/$(LIBNAME)-docs.xml)

clean: clean-doc

clean-doc:
	rm -rf doc/db doc/html doc/*.stamp

install: install-doc

DOCROOT = $(DOCDIR)/$(LIBNAME)-$(LIBVER)

define install-docfile
install-doc:: build-doc; install -Dm 644 $(1) $(DESTDIR)$(DOCROOT)/$(1:doc/%=%)
endef

$(foreach F,$(DOCS),$(eval $(call install-docfile,$(F))))

endif  # LIBNAME
