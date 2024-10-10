.PHONY=build usbmuxd clean
FEDORA_VERSION=$$(cat ./FEDORA_VERSION)

all: build

build: clean
	@podman build --build-arg=FEDORA_VERSION=$(FEDORA_VERSION) -t libimobiledevice:latest .
	@podman create --name libimobiledevice libimobiledevice:latest
	@mkdir -p ./dist/usr/
	@podman cp libimobiledevice:/root/libimobiledevice-0.1.0/usr/local ./dist/usr/
	@podman cp libimobiledevice:/usr/lib64/libzip.so.5.5 ./dist/usr/local/lib/
	@ln -s libzip.so.5.5 ./dist/usr/local/lib/libzip.so.5
	@ln -s libzip.so.5.5 ./dist/usr/local/lib/libzip.so
	@podman cp libimobiledevice:/root/rpmbuild/RPMS/x86_64/libimobiledevice-0.1.0-1.fc$(FEDORA_VERSION).x86_64.rpm ./dist/

usbmuxd:
	@-sudo systemctl stop usbmuxd
	@-sudo pkill usbmuxd
	@sudo rm -f /var/run/usbmuxd.pid /var/run/usbmuxd
	@sudo rm -rf /var/lib/lockdown/
	@sudo LD_LIBRARY_PATH=$$PWD/dist/usr/local/lib dist/usr/local/sbin/usbmuxd -U root -f -vv
	@-sudo pkill usbmuxd
	@sudo rm -f /var/run/usbmuxd.pid /var/run/usbmuxd
	@sudo rm -rf /var/lib/lockdown/

clean:
	@podman unshare rm -rf ./dist
	@-podman rm -f libimobiledevice 2>/dev/null
