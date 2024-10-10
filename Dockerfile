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
        ./autogen.sh && \
        make && \
        make install; \
    done

# Build libimobiledevice RPM package
RUN rpmdev-setuptree && \
    mkdir -p libimobiledevice-0.1.0/usr/local/ && \
    cp -r /usr/local/{bin,sbin,share,lib} libimobiledevice-0.1.0/usr/local/ && \
    rm -r libimobiledevice-0.1.0/usr/local/lib/{*.a,*.la,pkgconfig} && \
    tar --create --file rpmbuild/SOURCES/libimobiledevice-0.1.0.tar.gz libimobiledevice-0.1.0
COPY libimobiledevice.spec rpmbuild/SPECS/
RUN QA_RPATHS=$(( 0x0002 )) rpmbuild -bs rpmbuild/SPECS/libimobiledevice.spec && \
    QA_RPATHS=$(( 0x0002 )) rpmbuild -bb rpmbuild/SPECS/libimobiledevice.spec
