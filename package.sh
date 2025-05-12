#!/bin/bash -ex
#

PKG_VERSION=${1:-0.0.5}

# Get the user's gem directory using Ruby
GEM_USER_DIR=$(ruby -r rubygems -e 'puts Gem.user_dir')

# Construct the bin path
if command -v fpm >/dev/null 2>&1; then
  GEM_BIN_DIR=$(dirname $(command -v fpm))
else
  GEM_BIN_DIR="$GEM_USER_DIR/bin"
fi

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
    DEPS=${PKG_DEPS:-"libpython3.11"}
  else
    ARCH=$(uname -m)
    DEPS=${PKG_DEPS:-"python3.11-libs"}
    TARGET="rpm"
  fi
  PKG_VERSION=${PKG_VERSION}~${ID}${VERSION_ID}
  LIB_DIR=$(ls -1 build/ | grep lib.linux)

  rm -f axonops-cqlsh_${PKG_VERSION}_${ARCH}.deb
  fpm -s dir -t $TARGET -n axonops-cqlsh -v ${PKG_VERSION} -a $ARCH \
    --maintainer "AxonOps Limited <support@axonops.com>" \
    --description "CQL Shell for interacting with Apache Cassandra" \
    --deb-use-file-permissions \
    -d $DEPS \
    --prefix /opt/AxonOps \
    axonops-cqlsh=/bin/axonops-cqlsh \
    build/${LIB_DIR}/=/lib
fi

if [ "$(uname -s)" == "Darwin" ]; then
  ARCH=$(uname -m)
  MAJOR_VERSION=$(sw_vers -productVersion | cut -d '.' -f 1)
  LIB_DIR=$(ls -1 build/ | grep lib.)
  PKG_VERSION=${PKG_VERSION}~osx${MAJOR_VERSION}


  codesign --force --options runtime \
    -s "Developer ID Application: AXONOPS Limited (UJ776LUP23)" axonops-cqlsh

  for f in $(find build/lib.macosx-15.0-arm64-cpython-311/ -name "*.so"); do
      codesign --force --options runtime \
        -s "Developer ID Application: AXONOPS Limited (UJ776LUP23)" "$f"
  done

  fpm -s dir -t zip -n axonops-cqlsh-${PKG_VERSION}-${ARCH} -v ${PKG_VERSION} -a $ARCH \
    --maintainer "AxonOps Limited <support@axonops.com>" \
    --description "CQL Shell for interacting with Apache Cassandra" \
    --prefix AxonOps-CQLSH \
    axonops-cqlsh=/bin/axonops-cqlsh \
    build/${LIB_DIR}/=/lib

  rm -f axonops-cqlsh*.pkg UNSIGNED-axonops-cqlsh*pkg
  $FPM -s dir -t osxpkg -n axonops-cqlsh -v ${PKG_VERSION} -a $ARCH \
    --maintainer "AxonOps Limited <support@axonops.com>" \
    --description "CQL Shell for interacting with Apache Cassandra" \
    --prefix /usr/local \
    axonops-cqlsh=/bin/axonops-cqlsh \
    build/${LIB_DIR}/=/lib
fi
