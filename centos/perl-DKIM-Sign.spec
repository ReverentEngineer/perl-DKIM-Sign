Name:           perl-DKIM-Sign
Version:        0.1.1
Release:        1%{?dist}
Summary:        A command line DKIM signer

License:       MIT 
URL:           https://github.com/ReverentEngineer/%{name}
Source0:       https://github.com/ReverentEngineer/%{name}/archive/v%{version}.zip

Requires:      perl-Mail-DKIM, perl-YAML

%description
perl-DKIM-Sign is a command line interface for signing mail developed with Postfix content filtering in mind.

%prep
%{uncompress:%{SOURCE0}}

%install
rm -rf $RPM_BUILD_ROOT
cd %{name}-%{version}
make DESTDIR=$RPM_BUILD_ROOT PREFIX=/usr install

%files
%license %{name}-%{version}/LICENSE
%{_bindir}/dkim_sign



%changelog
* Sun Mar  1 2020 Jeff Caffrey-Hill <jeff@reverentengineer.com>
- 
