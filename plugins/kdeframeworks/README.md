Some KDE Frameworks 5 used by Kdenlive

An additional requirement on build system is qtbase-dev.

To use these libraries, add in you settings.mk:
override MXE_PLUGIN_DIRS += plugins/kdeframeworks

To upgrade all frameworks in one shot:
make $(for i in plugins/kdeframeworks/*.mk ; do i=${i##*/}; echo update-package-${i%%.mk} ; done)
