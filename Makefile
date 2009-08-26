include $(TOPDIR)/rules.mk

# Name and release number of this package
PKG_NAME:=umurmur
PKG_VERSION:=0.1.1
PKG_RELEASE:=4


PKG_BUILD_DIR := $(BUILD_DIR)/$(PKG_NAME)

include $(INCLUDE_DIR)/package.mk


define Package/umurmur
	SECTION:=net
	CATEGORY:=Network
	TITLE:=uMurmur
	DEPENDS:=+libopenssl +libconfig
endef


# Uncomment portion below for Kamikaze and delete DESCRIPTION variable above
define Package/umurmur/description
	Minimalistic Mumble server daemon.
endef

TARGET_CFLAGS := \
        -DWRT_TARGET \
        $(TARGET_CFLAGS)

define Build/Prepare
	mkdir -p $(PKG_BUILD_DIR)
	$(CP) ./src/* $(PKG_BUILD_DIR)/
endef

define Build/CompileTarget
	CFLAGS="$(TARGET_CFLAGS)" LDFLAGS="$(TARGET_LDFLAGS)"\
	$(MAKE) -C $(PKG_BUILD_DIR)/umurmur.$(1)/umurmur \
		all
endef

define Package/umurmur/install
	$(INSTALL_DIR) $(1)/usr/bin
	$(INSTALL_BIN) $(PKG_BUILD_DIR)/umurmurd $(1)/usr/bin/
	$(INSTALL_DIR) $(1)/etc
	$(INSTALL_BIN) ./files/umurmur.conf $(1)/etc/umurmur.conf
	$(INSTALL_DIR) $(1)/etc/init.d
	$(INSTALL_BIN) ./files/umurmur.init $(1)/etc/init.d/umurmur
	$(INSTALL_DIR) $(1)/etc/umurmur
endef

$(eval $(call BuildPackage,umurmur))

