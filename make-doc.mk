#
# Colibri Build System: Documentation
#
# Copyright (c) 2006-2022 Alexei A. Smekalkine <ikle@ikle.ru>
#
# SPDX-License-Identifier: BSD-2-Clause
#

#
# guarantie default target
#

.PHONY: all clean install doc

all:

ifdef LIBNAME

.PHONY: build-doc clean-doc

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

endif  # LIBNAME
