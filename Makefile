include $(THEOS)/makefiles/common.mk

SUBPROJECTS += IPCServer Tweak Prefs

include $(THEOS_MAKE_PATH)/aggregate.mk

after-install::
	install.exec "sbreload"