#!/bin/bash -ex
#

PKG_VERSION=${1:-0.0.5}

# Get the user's gem directory using Ruby
GEM_USER_DIR=$(ruby -r rubygems -e 'puts Gem.user_dir')

# Construct the bin path
GEM_BIN_DIR="$GEM_USER_DIR/bin"

export PATH=$PATH:$GEM_BIN_DIR

if [ ! -f $GEM_BIN_DIR/fpm ]; then
  echo "FPM not found, installing..."
  sudo gem install fpm
fi

if [ -f /etc/os-release ]; then
  source /etc/os-release

  if [ "$ID" == "debian" ]; then
    ARCH=$(dpkg --print-architecture)
    TARGET="deb"
    DEPS="libpython3.11"
  else
    ARCH=$(uname -m)
    DEPS="python3.11-libs"
    TARGET="rpm"
  fi
  PKG_VERSION=${PKG_VERSION}~${ID}${VERSION_ID}

  rm -f axonops-cqlsh_${PKG_VERSION}_${ARCH}.deb
  fpm -s dir -t $TARGET -n axonops-cqlsh -v ${VERSION} -a $DEB_ARCH \
    --maintainer "AxonOps Limited <support@axonops.com>" \
    --description "CQL Shell for interacting with Apache Cassandra" \
    --deb-use-file-permissions \
    -d libpython3.11 \
    --prefix /opt/AxonOps \
    axonops-cqlsh=/bin/cqlsh \
    build/lib.linux-$(uname -m)-cpython-311/=/lib
fi

if [ "$(uname -s)" == "Darwin" ]; then
  PKG_VERSION=${VERSION}~darwin${redhat_version}
  ARCH=$(uname -m)
  MAJOR_VERSION=$(sw_vers -productVersion | cut -d '.' -f 1)
  LIB_DIR=$(ls -1 build/ | grep lib.)

  fpm -s dir -t zip -n axonops-cqlsh-macos-${PKG_VERSION}-${ARCH} -v ${PKG_VERSION} -a $ARCH \
    --maintainer "AxonOps Limited <support@axonops.com>" \
    --description "CQL Shell for interacting with Apache Cassandra" \
    --prefix /opt/AxonOps \
    axonops-cqlsh=/bin/cqlsh \
    build/${LIB_DIR}/=/lib
fi
