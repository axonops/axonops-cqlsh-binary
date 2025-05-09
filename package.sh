#!/bin/bash
#

VERSION=${1:-0.0.5}

RUBY_VERSION=$(ruby --version | awk '{print $2}')
export PATH=$PATH:~/.local/share/gem/ruby/${RUBY_VERSION}/bin:$(ruby -e 'puts Gem.bindir')

if [ -f /etc/debian_version ]; then
  DEB_ARCH=$(dpkg --print-architecture)
  debian_version=$(cat /etc/debian_version)
  VERSION=${VERSION}~debian${debian_version}

  rm -f axonops-cqlsh_${VERSION}_${DEB_ARCH}.deb
  fpm -s dir -t deb -n axonops-cqlsh -v ${VERSION} -a $DEB_ARCH \
    --maintainer "AxonOps Limited <support@axonops.com>" \
    --description "CQL Shell for interacting with Apache Cassandra" \
    --deb-use-file-permissions \
    -d libpython3.11 \
    --prefix /opt/AxonOps \
    axonops-cqlsh=/bin/cqlsh \
    build/lib.linux-$(uname -m)-cpython-311/=/lib
fi

if [ "$(uname -s)" == "Darwin" ]; then
  VERSION=${VERSION}~darwin${redhat_version}
  ARCH=$(uname -m)

  fpm -s dir -t zip -n axonops-cqlsh -v ${VERSION} -a $ARCH \
    --maintainer "AxonOps Limited <support@axonops.com>" \
    --description "CQL Shell for interacting with Apache Cassandra" \
    -d python3.11-libs \
    --prefix /opt/AxonOps \
    axonops-cqlsh=/bin/cqlsh \
    build/lib.linux-$(uname -m)-cpython-311/=/lib
fi

if [ -f /etc/redhat-release ]; then
  RPM_ARCH=$(uname -m)
  redhat_version=$(cat /etc/redhat-release  | awk '{print $4}')
  VERSION=${VERSION}~rockylinux${redhat_version}

  rm -f axonops-cqlsh_${VERSION}_${RPM_ARCH}.rpm
  fpm -s dir -t rpm -n axonops-cqlsh -v ${VERSION} -a $RPM_ARCH \
    --maintainer "AxonOps Limited <support@axonops.com>" \
    --description "CQL Shell for interacting with Apache Cassandra" \
    -d python3.11-libs \
    --prefix /opt/AxonOps \
    axonops-cqlsh=/bin/cqlsh \
    build/lib.linux-$(uname -m)-cpython-311/=/lib
fi