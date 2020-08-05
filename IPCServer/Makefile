INSTALL_TARGET_PROCESSES = SpringBoard

include $(THEOS)/makefiles/common.mk

TWEAK_NAME = ControlWidgetIPCServer

$(TWEAK_NAME)_CFLAGS = -fobjc-arc
$(TWEAK_NAME)_FILES = $(wildcard *.m) $(wildcard *.xm)
$(TWEAK_NAME)_LIBRARIES += mryipc

include $(THEOS_MAKE_PATH)/tweak.mk