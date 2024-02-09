# libimobiledevice-fedora

A Dockerfile to build [libimobiledevice](https://github.com/libimobiledevice) for Fedora !

## Usage

```bash
# 1. Build dependencies
make build

# 2. Start usbmuxd
make usbmuxd

# 3. Plug your device

# 4. Pair your device
source env.sh
idevicepair pair
idevicepair validate

# 5. Restore (need to be runned as root)
sudo -s
source env.sh
# Update restore is performed which will preserve user data.
idevicerestore --latest -y
# You can also force restoring with erasing all data and basically resetting the device by using:
idevicerestore --erase -y --latest
```

## Fedora version

Current supported Fedora version is 39, but you can change the version in `FEDORA_VERSION` file.
