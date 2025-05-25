ARG FEDORA_VERSION
FROM docker.io/fedora:${FEDORA_VERSION}

RUN dnf update -y && \
    dnf install -y git make gcc clang libtool automake autoconf python-devel libcurl-devel zlib-devel readline-devel which libzip-devel diffutils openssl-devel pkg-config libusb1-devel libxml2-devel fuse-devel && \
    dnf install -y rpmdevtools

ENV PKG_CONFIG_PATH /usr/local/lib/pkgconfig
WORKDIR /root
RUN rm -rf /usr/local/*

# Build all libimobiledevice binaries, in this specific order
RUN for project in "libplist" "libimobiledevice-glue" "libusbmuxd" "libtatsu" "libimobiledevice" "usbmuxd" "libirecovery" "libideviceactivation" "ideviceinstaller" "ifuse" "idevicerestore"; do \
        cd /root/ && \
        git clone https://github.com/libimobiledevice/${project}.git && \
        cd ${project} && \
        ./autogen.sh --prefix=/usr/local && \
        make && \
        make install; \
    done

RUN mkdir -p /root/usr/local/ && \
    cp -r /usr/local/{bin,sbin,share,lib} /root/usr/local/ && \
    rm -r /root/usr/local/lib/{*.a,*.la,pkgconfig}
