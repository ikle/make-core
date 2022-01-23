#
# Colibri Build System: Subprojects
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

#
# rules to manage subprojects
#

define declare-child

.PHONY: $(1) clean-$(1) install-$(1) doc-$(1)

all:       $(1).ok
clean:     clean-$(1)
install: install-$(1)
doc:         doc-$(1)

$(1): $(1).ok

$(1).ok:
	+$(MAKE) -C $(1)
	@echo > $(1).ok

clean-$(1):
	$(RM) $(1).ok
	+$(MAKE) -C $(1) clean

install-$(1):
	+$(MAKE) -C $(1) install

doc-$(1):
	+$(MAKE) -C $(1) doc

endef

$(foreach F,$(CHILDS),$(eval $(call declare-child,$(F))))