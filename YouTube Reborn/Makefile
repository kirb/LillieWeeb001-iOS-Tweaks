TARGET := iphone:clang:14.4:13.0
INSTALL_TARGET_PROCESSES = YouTube YouTubeRebornApp

ifeq ($(DEBUG),1)
THEOS_PACKAGE_DIR_NAME = ../../../var/www/html/debs
endif

include $(THEOS)/makefiles/common.mk
SUBPROJECTS += App Tweak
include $(THEOS_MAKE_PATH)/aggregate.mk
