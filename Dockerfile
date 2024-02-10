ARG FEDORA_VERSION
FROM docker.io/fedora:${FEDORA_VERSION}

RUN dnf update -y && \
    dnf install -y git make gcc clang libtool automake autoconf python-devel libcurl-devel zlib-devel readline-devel which libzip-devel diffutils openssl-devel pkg-config libusb1-devel libxml2-devel fuse-devel && \
    dnf install -y rpmdevtools

ENV PKG_CONFIG_PATH /usr/local/lib/pkgconfig
WORKDIR /root
RUN rm -rf /usr/local/*

# Build and install libplist
RUN git clone https://github.com/libimobiledevice/libplist.git && \
    cd libplist && \
    ./autogen.sh && \
    make && \
    make install

# Build and install libimobiledevice-glue
RUN git clone https://github.com/libimobiledevice/libimobiledevice-glue.git && \
    cd libimobiledevice-glue && \
    ./autogen.sh && \
    make && \
    make install

# Build and install libusbmuxd
RUN git clone https://github.com/libimobiledevice/libusbmuxd.git && \
    cd libusbmuxd && \
    ./autogen.sh && \
    make && \
    make install

# Build and install libimobiledevice
RUN git clone https://github.com/libimobiledevice/libimobiledevice.git && \
    cd libimobiledevice && \
    ./autogen.sh && \
    make && \
    make install

# Build and install usbmuxd
RUN git clone https://github.com/libimobiledevice/usbmuxd.git && \
    cd usbmuxd && \
    ./autogen.sh && \
    make && \
    make install

# Build and install libirecovery
RUN git clone https://github.com/libimobiledevice/libirecovery.git && \
    cd libirecovery && \
    ./autogen.sh && \
    make && \
    make install

# Build and install ideviceactivation
RUN git clone https://github.com/libimobiledevice/libideviceactivation.git && \
    cd libideviceactivation && \
    ./autogen.sh && \
    make && \
    make install

# Build and install ideviceinstaller
RUN git clone https://github.com/libimobiledevice/ideviceinstaller.git && \
    cd ideviceinstaller && \
    ./autogen.sh && \
    make && \
    make install

# Build and install ifuse
RUN git clone https://github.com/libimobiledevice/ifuse.git && \
    cd ifuse && \
    ./autogen.sh && \
    make && \
    make install

# Build and install idevicerestore
RUN git clone https://github.com/libimobiledevice/idevicerestore.git && \
    cd idevicerestore && \
    ./autogen.sh && \
    make && \
    make install

# Build libimobiledevice RPM package
RUN rpmdev-setuptree && \
    mkdir -p libimobiledevice-0.1.0/usr/local/ && \
    cp -r /usr/local/{bin,sbin,share,lib} libimobiledevice-0.1.0/usr/local/ && \
    rm -r libimobiledevice-0.1.0/usr/local/lib/{*.a,*.la,pkgconfig} && \
    tar --create --file rpmbuild/SOURCES/libimobiledevice-0.1.0.tar.gz libimobiledevice-0.1.0
COPY libimobiledevice.spec rpmbuild/SPECS/
RUN QA_RPATHS=$(( 0x0002 )) rpmbuild -bs rpmbuild/SPECS/libimobiledevice.spec && \
    QA_RPATHS=$(( 0x0002 )) rpmbuild -bb rpmbuild/SPECS/libimobiledevice.spec
