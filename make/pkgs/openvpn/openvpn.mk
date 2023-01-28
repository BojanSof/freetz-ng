$(call PKG_INIT_BIN, $(if $(FREETZ_PACKAGE_OPENVPN_VERSION_24),2.4.12,$(if $(FREETZ_PACKAGE_OPENVPN_VERSION_25),2.5.8,2.6.0)))
$(PKG)_MAJOR_VERSION:=$(call GET_MAJOR_VERSION,$($(PKG)_VERSION))
$(PKG)_SOURCE:=$(pkg)-$($(PKG)_VERSION).tar.gz
$(PKG)_HASH_24:=66952d9c95490e5875f04c9f8fa313b5e816d1b7b4d6cda3fb2ff749ad405dee
$(PKG)_HASH_25:=a6f315b7231d44527e65901ff646f87d7f07862c87f33531daa109fb48c53db2
$(PKG)_HASH_26:=ebec933263c9850ef6f7ce125e2f22214be60b1cbb8ccff18892643fe083ae8f
$(PKG)_HASH:=$($(PKG)_HASH_$(subst .,,$($(PKG)_MAJOR_VERSION)))
$(PKG)_SITE:=https://swupdate.openvpn.net/community/releases,https://build.openvpn.net/downloads/releases
### WEBSITE:=https://openvpn.net/community-downloads/
### CHANGES:=https://github.com/OpenVPN/openvpn/blob/master/Changes.rst
### CVSREPO:=https://github.com/OpenVPN/openvpn

$(PKG)_CONDITIONAL_PATCHES+=$($(PKG)_MAJOR_VERSION)
ifeq ($(strip $(FREETZ_PACKAGE_OPENVPN_WITH_TRAFFIC_OBFUSCATION)),y)
$(PKG)_CONDITIONAL_PATCHES+=$($(PKG)_MAJOR_VERSION)/obfuscation
endif

$(PKG)_BINARY:=$($(PKG)_DIR)/src/openvpn/openvpn
$(PKG)_TARGET_BINARY:=$($(PKG)_DEST_DIR)/usr/sbin/openvpn

$(PKG)_STARTLEVEL=81

$(PKG)_DEPENDS_ON += $(if $(FREETZ_PACKAGE_OPENVPN_OPENSSL),openssl)
$(PKG)_DEPENDS_ON += $(if $(FREETZ_PACKAGE_OPENVPN_MBEDTLS),mbedtls)
$(PKG)_DEPENDS_ON += $(if $(FREETZ_PACKAGE_OPENVPN_WITH_LZO),lzo)
$(PKG)_DEPENDS_ON += $(if $(FREETZ_PACKAGE_OPENVPN_WITH_LZ4),lz4)
$(PKG)_DEPENDS_ON += $(if $(FREETZ_PACKAGE_OPENVPN_VERSION_26),libcap-ng)

$(PKG)_REBUILD_SUBOPTS += FREETZ_PACKAGE_OPENVPN_VERSION_24
$(PKG)_REBUILD_SUBOPTS += FREETZ_PACKAGE_OPENVPN_VERSION_25
$(PKG)_REBUILD_SUBOPTS += FREETZ_PACKAGE_OPENVPN_VERSION_26
$(PKG)_REBUILD_SUBOPTS += FREETZ_PACKAGE_OPENVPN_OPENSSL
$(PKG)_REBUILD_SUBOPTS += FREETZ_OPENSSL_SHLIB_VERSION
$(PKG)_REBUILD_SUBOPTS += FREETZ_PACKAGE_OPENVPN_MBEDTLS
$(PKG)_REBUILD_SUBOPTS += FREETZ_PACKAGE_OPENVPN_WITH_LZO
$(PKG)_REBUILD_SUBOPTS += FREETZ_PACKAGE_OPENVPN_WITH_LZ4
$(PKG)_REBUILD_SUBOPTS += FREETZ_PACKAGE_OPENVPN_WITH_TRAFFIC_OBFUSCATION
$(PKG)_REBUILD_SUBOPTS += FREETZ_PACKAGE_OPENVPN_WITH_MGMNT
$(PKG)_REBUILD_SUBOPTS += FREETZ_PACKAGE_OPENVPN_ENABLE_SMALL
$(PKG)_REBUILD_SUBOPTS += FREETZ_PACKAGE_OPENVPN_USE_IPROUTE
$(PKG)_REBUILD_SUBOPTS += FREETZ_PACKAGE_OPENVPN_STATIC
$(PKG)_REBUILD_SUBOPTS += FREETZ_TARGET_IPV6_SUPPORT
$(PKG)_REBUILD_SUBOPTS += $(if $(FREETZ_PACKAGE_OPENVPN_MBEDTLS),FREETZ_LIB_libmbedcrypto_WITH_BLOWFISH)

$(PKG)_CONFIGURE_PRE_CMDS += $(call PKG_PREVENT_RPATH_HARDCODING,./configure)

ifeq ($(strip $(FREETZ_PACKAGE_OPENVPN_VERSION_25)),y)
$(PKG)_CONFIGURE_ENV += ac_cv_header_poll_h=no
$(PKG)_CONFIGURE_ENV += ac_cv_header_sys_epoll_h=no
$(PKG)_CONFIGURE_ENV += ac_cv_func_epoll_create=no
$(PKG)_CONFIGURE_ENV += ac_cv_func_strsep=no
$(PKG)_CONFIGURE_ENV += ac_cv_func_poll=no
endif

ifneq ($(strip $(FREETZ_PACKAGE_OPENVPN_VERSION_26)),y)
$(PKG)_CONFIGURE_ENV += ac_cv_path_IFCONFIG=/sbin/ifconfig
$(PKG)_CONFIGURE_ENV += ac_cv_path_IPROUTE=/sbin/ip
$(PKG)_CONFIGURE_ENV += ac_cv_path_ROUTE=/sbin/route
else
$(PKG)_CONFIGURE_ENV += IFCONFIG=/sbin/ifconfig
$(PKG)_CONFIGURE_ENV += IPROUTE=/sbin/ip
$(PKG)_CONFIGURE_ENV += ROUTE=/sbin/route
endif

$(PKG)_CONFIGURE_PRE_CMDS += $(call PKG_ADD_EXTRA_FLAGS,(C|LD)FLAGS|LIBS)

$(PKG)_EXTRA_CFLAGS  += -ffunction-sections -fdata-sections
$(PKG)_EXTRA_LDFLAGS += -Wl,--gc-sections
$(PKG)_EXTRA_LDFLAGS += $(if $(FREETZ_PACKAGE_OPENVPN_STATIC),-all-static)

$(PKG)_CONFIGURE_OPTIONS += --sysconfdir=/mod/etc/openvpn
$(PKG)_CONFIGURE_OPTIONS += $(if $(FREETZ_PACKAGE_OPENVPN_WITH_LZO),--enable-lzo,--disable-lzo)
$(PKG)_CONFIGURE_OPTIONS += $(if $(FREETZ_PACKAGE_OPENVPN_WITH_LZ4),--enable-lz4,--disable-lz4)
$(PKG)_CONFIGURE_OPTIONS += --disable-debug
$(PKG)_CONFIGURE_OPTIONS += --disable-multihome
$(PKG)_CONFIGURE_OPTIONS += --disable-plugins
$(PKG)_CONFIGURE_OPTIONS += --disable-port-share
$(PKG)_CONFIGURE_OPTIONS += $(if $(FREETZ_PACKAGE_OPENVPN_WITH_MGMNT),--enable-management,--disable-management)
$(PKG)_CONFIGURE_OPTIONS += --disable-pkcs11
$(PKG)_CONFIGURE_OPTIONS += $(if $(FREETZ_PACKAGE_OPENVPN_OPENSSL),--with-crypto-library=openssl)
$(PKG)_CONFIGURE_OPTIONS += $(if $(FREETZ_PACKAGE_OPENVPN_MBEDTLS),--with-crypto-library=mbedtls)
$(PKG)_CONFIGURE_OPTIONS += $(if $(FREETZ_PACKAGE_OPENVPN_USE_IPROUTE),--enable-iproute2)
$(PKG)_CONFIGURE_OPTIONS += $(if $(FREETZ_PACKAGE_OPENVPN_ENABLE_SMALL),--enable-small,--disable-small)


$(PKG_SOURCE_DOWNLOAD)
$(PKG_UNPACKED)
$(PKG_CONFIGURED_CONFIGURE)

$($(PKG)_BINARY): $($(PKG)_DIR)/.configured
	$(SUBMAKE) -C $(OPENVPN_DIR) \
		EXTRA_CFLAGS="$(OPENVPN_EXTRA_CFLAGS)" \
		EXTRA_LDFLAGS="$(OPENVPN_EXTRA_LDFLAGS)" \
		EXTRA_LIBS="$(OPENVPN_EXTRA_LIBS)" \
		SOCKETS_LIBS=""

$($(PKG)_TARGET_BINARY): $($(PKG)_BINARY)
	$(INSTALL_BINARY_STRIP)

$(pkg):

$(pkg)-precompiled: $($(PKG)_TARGET_BINARY)


$(pkg)-clean:
	-$(SUBMAKE) -C $(OPENVPN_DIR) clean
	$(RM) $(OPENVPN_FREETZ_CONFIG_FILE)

$(pkg)-uninstall:
	$(RM) $(OPENVPN_TARGET_BINARY)

$(PKG_FINISH)
