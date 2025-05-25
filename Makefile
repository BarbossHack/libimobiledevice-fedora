.PHONY=build usbmuxd clean
FEDORA_VERSION=$$(cat ./FEDORA_VERSION)

all: build

build: clean
	@podman build --build-arg=FEDORA_VERSION=$(FEDORA_VERSION) -t libimobiledevice:latest .
	@podman create --name libimobiledevice libimobiledevice:latest
	@mkdir -p ./dist/usr/
	@podman cp libimobiledevice:/root/usr/local ./dist/usr/
	@podman cp libimobiledevice:/usr/lib64/libzip.so.5.5 ./dist/usr/local/lib/
	@ln -s libzip.so.5.5 ./dist/usr/local/lib/libzip.so.5
	@ln -s libzip.so.5.5 ./dist/usr/local/lib/libzip.so

usbmuxd:
	@-sudo systemctl stop usbmuxd
	@-sudo pkill usbmuxd
	@sudo rm -f /var/run/usbmuxd.pid /var/run/usbmuxd
	@sudo rm -rf /var/lib/lockdown/
	@sudo LD_LIBRARY_PATH=$$PWD/dist/usr/local/lib dist/usr/local/sbin/usbmuxd -U ${USER} -f -vv
	@-sudo pkill usbmuxd
	@sudo rm -f /var/run/usbmuxd.pid /var/run/usbmuxd
	@sudo rm -rf /var/lib/lockdown/

clean:
	@podman unshare rm -rf ./dist
	@-podman rm -f libimobiledevice 2>/dev/null
