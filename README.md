# idevicerestore-fedora

A Dockerfile to build [idevicerestore](https://github.com/libimobiledevice/idevicerestore) for Fedora !

## Usage

```bash
# 1. Build dependencies
make

# 2. Start usbmuxd
make usb

# 3. Plug your device

# 4. Pair your device
make pair

# 5. Restore
# Update restore is performed which will preserve user data.
make restore
# You can also force restoring with erasing all data and basically resetting the device by using:
make restore-erase
```

## Fedora version

Current supported Fedora version is 36, but you can change the version in `FEDORA_VERSION` file.
