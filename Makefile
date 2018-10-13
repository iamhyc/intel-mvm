# SPDX-License-Identifier: GPL-2.0
# common
CONFIG_IWLWIFI=m
CONFIG_IWLMVM=m

PWD := $(shell pwd)
KDIR := /lib/modules/$(shell uname -r)/build

obj-$(CONFIG_IWLWIFI)	+= iwlwifi.o
iwlwifi-objs		+= iwl-io.o
iwlwifi-objs		+= iwl-drv.o
iwlwifi-objs		+= iwl-debug.o
iwlwifi-objs		+= iwl-eeprom-read.o iwl-eeprom-parse.o
iwlwifi-objs		+= iwl-phy-db.o iwl-nvm-parse.o
iwlwifi-objs		+= pcie/drv.o pcie/rx.o pcie/tx.o pcie/trans.o
iwlwifi-objs		+= pcie/ctxt-info.o pcie/trans-gen2.o pcie/tx-gen2.o
iwlwifi-$(CONFIG_IWLDVM) += cfg/1000.o cfg/2000.o cfg/5000.o cfg/6000.o
iwlwifi-$(CONFIG_IWLMVM) += cfg/7000.o cfg/8000.o cfg/9000.o cfg/a000.o
iwlwifi-objs		+= iwl-trans.o
iwlwifi-objs		+= fw/notif-wait.o
iwlwifi-$(CONFIG_IWLMVM) += fw/paging.o fw/smem.o fw/init.o fw/dbg.o
iwlwifi-$(CONFIG_IWLMVM) += fw/common_rx.o fw/nvm.o
iwlwifi-$(CONFIG_ACPI) += fw/acpi.o

iwlwifi-objs += $(iwlwifi-m)

iwlwifi-$(CONFIG_IWLWIFI_DEVICE_TRACING) += iwl-devtrace.o

ccflags-y += -I$(src)
ccflags-y += -DCONFIG_IWLWIFI -DCONFIG_IWLMVM
ccflags-y += -DCONFIG_IWLWIFI_DEBUGFS -DCONFIG_IWLWIFI_DEBUG -DCONFIG_IWLWIFI_DEVICE_TRACING

obj-$(CONFIG_IWLMVM)	+= mvm/

CFLAGS_iwl-devtrace.o := -I$(src)

all:
	$(MAKE) -C $(KDIR) M=$(PWD) $(CFLAGS)

insmod:
	sudo insmod iwlwifi.ko && sleep 0.5 && sudo rmmod iwlmvm && sudo insmod mvm/iwlmvm.ko

rmmod:
	sudo rmmod iwlmvm iwlwifi

modprobe:
	sudo modprobe iwlwifi

dmesg:
	sudo dmesg | grep 'LAB1112:' --color

clean:
	rm -f .cache.mk .*.cmd
	rm -f *.o *.o.cmd *.ko *.mod.c *.symvers *.order
	rm -rf .tmp_versions
	rm -f mvm/*.o mvm/*.o.cmd mvm/*.ko mvm/*.mod.c
	rm -f mvm/.*.o.cmd mvm/*.symvers mvm/*.order