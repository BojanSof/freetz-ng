$(call TOOLS_INIT, 1.0.0)
$(PKG)_SOURCE:=meson-$($(PKG)_VERSION).tar.gz
$(PKG)_HASH:=aa50a4ba4557c25e7d48446abfde857957dcdf58385fffbe670ba0e8efacce05
$(PKG)_SITE:=https://github.com/mesonbuild/meson/releases/download/$($(PKG)_VERSION)
### WEBSITE:=https://mesonbuild.com/
### MANPAGE:=https://mesonbuild.com/
### CHANGES:=https://github.com/mesonbuild/meson/releases
### CVSREPO:=https://github.com/mesonbuild/meson

$(PKG)_BINARY:=$($(PKG)_DIR)/meson.pyz
$(PKG)_TARGET_BINARY:=$(TOOLS_DIR)/meson

$(PKG)_DEPENDS_ON+=python3-host
$(PKG)_DEPENDS_ON+=ninja-host


$(TOOLS_SOURCE_DOWNLOAD)
$(TOOLS_UNPACKED)
$(TOOLS_CONFIGURED_NOP)

$($(PKG)_BINARY): $($(PKG)_DIR)/.configured
	$(TOOLS_SUBPYTHON3) \
		$(MESON_HOST_DIR)/packaging/create_zipapp.py \
		--outfile $(MESON_HOST_BINARY) \
		--interpreter '/usr/bin/env python3' \
		$(MESON_HOST_DIR)

$($(PKG)_TARGET_BINARY): $($(PKG)_BINARY)
	$(INSTALL_FILE)

$(pkg)-precompiled: $($(PKG)_TARGET_BINARY)


$(pkg)-clean:
	$(RM) $(MESON_HOST_DIR)/.configured

$(pkg)-dirclean:
	$(RM) -r $(MESON_HOST_DIR)

$(pkg)-distclean: $(pkg)-dirclean
	$(RM) -r $(MESON_HOST_TARGET_BINARY) $(MESON_HOST_TARGET_EGGDIR)

$(TOOLS_FINISH)