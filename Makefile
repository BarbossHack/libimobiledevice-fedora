.PHONY=build info restore restore-erase clean pair

FEDORA_VERSION=$$(cat ./FEDORA_VERSION)

all: build

build: clean
	@podman build --build-arg=FEDORA_VERSION=$(FEDORA_VERSION) -t ios-restore:latest .
	@podman create --name ios-restore ios-restore:latest
	@podman cp ios-restore:/output .
	@podman cp ios-restore:/usr/lib64/libzip.so.5 ./output/lib/libzip.so.5

info:
	@output/bin/ideviceinfo

restore:
	@sudo LD_LIBRARY_PATH=$$PWD/output/lib output/bin/idevicerestore --latest -y

restore-erase:
	@sudo LD_LIBRARY_PATH=$$PWD/output/lib output/bin/idevicerestore --erase -y --latest

usb:
	@-sudo systemctl stop usbmuxd
	@-sudo pkill usbmuxd
	@sudo rm -f /var/run/usbmuxd.pid /var/run/usbmuxd
	@sudo rm -rf /var/lib/lockdown/
	@sudo LD_LIBRARY_PATH=$$PWD/output/lib output/sbin/usbmuxd -U root -f -vv
	@-sudo pkill usbmuxd
	@sudo rm -f /var/run/usbmuxd.pid /var/run/usbmuxd
	@sudo rm -rf /var/lib/lockdown/

pair:
	@LD_LIBRARY_PATH=$$PWD/output/lib output/bin/idevicepair pair
	@LD_LIBRARY_PATH=$$PWD/output/lib output/bin/idevicepair validate

clean:
	@podman unshare rm -rf ./output
	@-podman rm -f ios-restore 2>/dev/null
