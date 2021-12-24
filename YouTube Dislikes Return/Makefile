TARGET := iphone:clang:14.4:13.0
INSTALL_TARGET_PROCESSES = YouTube
ARCHS = arm64

# ifeq ($(DEBUG),1)
# THEOS_PACKAGE_DIR_NAME = ../../../var/www/html/debs
# endif

include $(THEOS)/makefiles/common.mk

TWEAK_NAME = YouTubeDislikesReturn
YouTubeDislikesReturn_FILES = Tweak.xm
YouTubeDislikesReturn_CFLAGS = -fobjc-arc

include $(THEOS_MAKE_PATH)/tweak.mk
include $(THEOS_MAKE_PATH)/aggregate.mk

after-install::
	@install.exec "uiopen youtube:"
