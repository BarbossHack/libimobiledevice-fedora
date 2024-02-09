.PHONY=build usbmuxd clean

FEDORA_VERSION=$$(cat ./FEDORA_VERSION)

all: build

build: clean
	@podman build --build-arg=FEDORA_VERSION=$(FEDORA_VERSION) -t libmobiledevice:latest .
	@podman create --name libmobiledevice libmobiledevice:latest
	@podman cp libmobiledevice:/output .
	@podman cp libmobiledevice:/usr/lib64/libzip.so.5 ./output/lib/libzip.so.5

usbmuxd:
	@-sudo systemctl stop usbmuxd
	@-sudo pkill usbmuxd
	@sudo rm -f /var/run/usbmuxd.pid /var/run/usbmuxd
	@sudo rm -rf /var/lib/lockdown/
	@sudo LD_LIBRARY_PATH=$$PWD/output/lib output/sbin/usbmuxd -U root -f -vv
	@-sudo pkill usbmuxd
	@sudo rm -f /var/run/usbmuxd.pid /var/run/usbmuxd
	@sudo rm -rf /var/lib/lockdown/

clean:
	@podman unshare rm -rf ./output
	@-podman rm -f libmobiledevice 2>/dev/null
