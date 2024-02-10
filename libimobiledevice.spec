Name:           libimobiledevice
Version:        0.1.0
Release:        1%{?dist}
Summary:        libimobiledevice
License:        GPL
Source0:        %{name}-%{version}.tar.gz
BuildArch:      x86_64

%description
libimobiledevice RPM

%prep
%autosetup

%install
rm -rf $RPM_BUILD_ROOT
mkdir -p $RPM_BUILD_ROOT/
cp -r usr $RPM_BUILD_ROOT/
chmod +x $RPM_BUILD_ROOT/usr/local/bin/*

%clean
rm -rf $RPM_BUILD_ROOT

%files
/usr/local/bin/*
/usr/local/sbin/*
/usr/local/lib/*.so
/usr/local/lib/*.so.*
/usr/local/share/*

%changelog
* Sat Feb 10 2024
- Init
