TARGET := iphone:clang:14.4:13.0
GO_EASY_ON_ME = 1

include $(THEOS)/makefiles/common.mk

APPLICATION_NAME = YouTubeRebornApp
YouTubeRebornApp_FILES = main.m YTRAppDelegate.m YTRRootViewController.m
YouTubeRebornApp_FRAMEWORKS = UIKit Foundation CoreGraphics CoreServices AVFoundation AVKit
YouTubeRebornApp_CFLAGS = -fobjc-arc
YouTubeRebornApp_CODESIGN_FLAGS = -SappEntitlements.xml

include $(THEOS_MAKE_PATH)/application.mk
