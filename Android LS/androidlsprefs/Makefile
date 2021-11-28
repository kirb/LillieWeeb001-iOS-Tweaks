TARGET := iphone:clang:14.4:13.0
GO_EASY_ON_ME = 1

include $(THEOS)/makefiles/common.mk

BUNDLE_NAME = AndroidLSPrefs

AndroidLSPrefs_FILES = ALSRootListController.m
AndroidLSPrefs_FRAMEWORKS = UIKit Foundation
AndroidLSPrefs_PRIVATE_FRAMEWORKS = Preferences
AndroidLSPrefs_LIBRARIES = sparkcolourpicker
AndroidLSPrefs_INSTALL_PATH = /Library/PreferenceBundles
AndroidLSPrefs_CFLAGS = -fobjc-arc
ARCHS = arm64 arm64e

include $(THEOS_MAKE_PATH)/bundle.mk
