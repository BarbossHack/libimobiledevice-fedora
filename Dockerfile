ARG FEDORA_VERSION
FROM docker.io/fedora:${FEDORA_VERSION}

RUN dnf update -y && \
    dnf install -y git make gcc clang libtool automake autoconf python-devel libcurl-devel zlib-devel readline-devel which libzip-devel diffutils libusbmuxd-devel openssl-devel pkg-config libusb1-devel libxml2-devel fuse-devel

ENV PKG_CONFIG_PATH /output/lib/pkgconfig

# Build and install libplist
RUN git clone https://github.com/libimobiledevice/libplist.git && \
    cd libplist && \
    ./autogen.sh --prefix=/output && \
    make && \
    make install

# Build and install libimobiledevice-glue
RUN git clone https://github.com/libimobiledevice/libimobiledevice-glue.git && \
    cd libimobiledevice-glue && \
    ./autogen.sh --prefix=/output && \
    make && \
    make install

# Build and install libimobiledevice
RUN git clone https://github.com/libimobiledevice/libimobiledevice.git && \
    cd libimobiledevice && \
    ./autogen.sh --prefix=/output && \
    make && \
    make install

# Build and install usbmuxd
RUN git clone https://github.com/libimobiledevice/usbmuxd.git && \
    cd usbmuxd && \
    ./autogen.sh --prefix=/output && \
    make && \
    make install

# Build and install libirecovery
RUN git clone https://github.com/libimobiledevice/libirecovery.git && \
    cd libirecovery && \
    ./autogen.sh --prefix=/output && \
    make && \
    make install

# Build and install ideviceactivation
RUN git clone https://github.com/libimobiledevice/libideviceactivation.git && \
    cd libideviceactivation && \
    ./autogen.sh --prefix=/output && \
    make && \
    make install

# Build and install ideviceinstaller
RUN git clone https://github.com/libimobiledevice/ideviceinstaller.git && \
    cd ideviceinstaller && \
    ./autogen.sh --prefix=/output && \
    make && \
    make install

# Build and install ifuse
RUN git clone https://github.com/libimobiledevice/ifuse.git && \
    cd ifuse && \
    ./autogen.sh --prefix=/output && \
    make && \
    make install

# Build and install idevicerestore
RUN git clone https://github.com/libimobiledevice/idevicerestore.git && \
    cd idevicerestore && \
    ./autogen.sh --prefix=/output && \
    make && \
    make install
