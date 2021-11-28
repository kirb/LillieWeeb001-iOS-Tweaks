TARGET := iphone:clang:14.4:13.0
INSTALL_TARGET_PROCESSES = SpringBoard
GO_EASY_ON_ME = 1
THEOS_DEVICE_IP = 192.168.0.25
THEOS_DEVICE_PORT = 22

ifeq ($(DEBUG),1)
THEOS_PACKAGE_DIR_NAME = ../../../var/www/repo.lillieweeb001/beta/debs
else
THEOS_PACKAGE_DIR_NAME = ../../../var/www/repo.lillieweeb001/debs
endif

include $(THEOS)/makefiles/common.mk

TWEAK_NAME = ZZAccentCustom
ZZAccentCustom_FILES = Tweak.xm
ZZAccentCustom_CFLAGS = -fobjc-arc
ZZAccentCustom_FRAMEWORKS = UIKit Foundation
ZZAccentCustom_LIBRARIES = sparkcolourpicker sparkapplist
ARCHS = arm64 arm64e

include $(THEOS_MAKE_PATH)/tweak.mk
SUBPROJECTS += accentcustomprefs
include $(THEOS_MAKE_PATH)/aggregate.mk
