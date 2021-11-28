TARGET := iphone:clang:14.4:13.0
INSTALL_TARGET_PROCESSES = YouTube
GO_EASY_ON_ME = 1

ifeq ($(DEBUG),1)
THEOS_PACKAGE_DIR_NAME = ../../../var/www/repo.lillieweeb001/beta/debs
else
THEOS_PACKAGE_DIR_NAME = ../../../var/www/repo.lillieweeb001/debs
endif

include $(THEOS)/makefiles/common.mk

TWEAK_NAME = YouTubeReborn
YouTubeReborn_FILES = Tweak.xm $(shell find Controllers -name '*.m') $(shell find Reachability -name '*.m') $(shell find AFNetworking -name '*.m') $(shell find XCDYouTubeKit -name '*.m')
YouTubeReborn_CFLAGS = -fobjc-arc
YouTubeReborn_FRAMEWORKS = UIKit Foundation AVFoundation AVKit
YouTubeReborn_PRIVATE_FRAMEWORKS = MediaRemote
ARCHS = arm64 arm64e

include $(THEOS_MAKE_PATH)/tweak.mk
include $(THEOS_MAKE_PATH)/aggregate.mk
