TARGET = iphone:clang:latest:14.0
ARCHS = arm64

include $(THEOS)/makefiles/common.mk

TWEAK_NAME = PubgLoader

PubgLoader_FILES = Tweak.mm
PubgLoader_CFLAGS = -fobjc-arc
PubgLoader_FRAMEWORKS = UIKit Foundation CoreGraphics

include $(THEOS_MAKE_PATH)/tweak.mk
