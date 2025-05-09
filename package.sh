#!/bin/bash
#

VERSION=${1:-0.0.5}

# Get the user's gem directory using Ruby
GEM_USER_DIR=$(ruby -r rubygems -e 'puts Gem.user_dir')

# Construct the bin path
GEM_BIN_DIR="$GEM_USER_DIR/bin"

export PATH=$PATH:$GEM_BIN_DIR

if [ ! -f $GEM_BIN_DIR/fpm ]; then
  echo "FPM not found, installing..."
  sudo gem install fpm
fi

if [ -f /etc/debian_version ]; then
  DEB_ARCH=$(dpkg --print-architecture)
  debian_version=$(cat /etc/debian_version)
  VERSION=${VERSION}~debian${debian_version}

  rm -f axonops-cqlsh_${VERSION}_${DEB_ARCH}.deb
  $FPM -s dir -t deb -n axonops-cqlsh -v ${VERSION} -a $DEB_ARCH \
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
  MAJOR_VERSION=$(sw_vers -productVersion | cut -d '.' -f 1)

  $FPM -s dir -t zip -n axonops-cqlsh -v ${VERSION} -a $ARCH \
    --maintainer "AxonOps Limited <support@axonops.com>" \
    --description "CQL Shell for interacting with Apache Cassandra" \
    --prefix /opt/AxonOps \
    axonops-cqlsh=/bin/cqlsh \
    build/lib.macosx-${MAJOR_VERSION}.0-$(uname -m)-cpython-311/=/lib
fi

if [ -f /etc/redhat-release ]; then
  RPM_ARCH=$(uname -m)
  redhat_version=$(cat /etc/redhat-release  | awk '{print $4}')
  VERSION=${VERSION}~rockylinux${redhat_version}

  rm -f axonops-cqlsh_${VERSION}_${RPM_ARCH}.rpm
  $FPM -s dir -t rpm -n axonops-cqlsh -v ${VERSION} -a $RPM_ARCH \
    --maintainer "AxonOps Limited <support@axonops.com>" \
    --description "CQL Shell for interacting with Apache Cassandra" \
    -d python3.11-libs \
    --prefix /opt/AxonOps \
    axonops-cqlsh=/bin/cqlsh \
    build/lib.linux-$(uname -m)-cpython-311/=/lib
fi