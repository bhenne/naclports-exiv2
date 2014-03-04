#!/bin/bash
# Copyright (c) 2011 The Native Client Authors. All rights reserved.
# Use of this source code is governed by a BSD-style license that can be
# found in the LICENSE file.
# 
# The original file was modified by Maximilian Koch and Benjamin Henne

CustomConfigureStep() {
  local EXTRA_CONFIGURE_OPTS=("${@:-}")
  Banner "Configuring ${PACKAGE_NAME}"
  # export the nacl tools
  export CC=${NACLCC}
  export CXX=${NACLCXX}" "-lpthread
  export AR=${NACLAR}
  export RANLIB=${NACLRANLIB}
  export PKG_CONFIG_PATH=${NACLPORTS_LIBDIR}/pkgconfig
  export PKG_CONFIG_LIBDIR=${NACLPORTS_LIBDIR}
  export FREETYPE_CONFIG=${NACLPORTS_LIBDIR}/freetype-config
  export PATH=${NACL_BIN_PATH}:${PATH};
  ChangeDir ${NACL_PACKAGES_REPOSITORY}/${PACKAGE_NAME}
  #Remove ${PACKAGE_NAME}-build
  #MakeDir ${PACKAGE_NAME}-build
  #cd ${PACKAGE_NAME}-build
  echo "Directory: $(pwd)"

  local conf_host=${NACL_CROSS_PREFIX}
  if [[ ${NACL_ARCH} == "pnacl" ]]; then
    # The PNaCl tools use "pnacl-" as the prefix, but config.sub
    # does not know about "pnacl".  It only knows about "le32-nacl".
    # Unfortunately, most of the config.subs here are so old that
    # it doesn't know about that "le32" either.  So we just say "nacl".
    conf_host="nacl"
  fi
  ./configure \
    --host=${conf_host} \
    --disable-shared \
    --prefix=${NACLPORTS_PREFIX} \
    --exec-prefix=${NACLPORTS_PREFIX} \
    --libdir=${NACLPORTS_LIBDIR} \
    --oldincludedir=${NACLPORTS_INCLUDE} \
    --${NACL_OPTION}-mmx \
    --${NACL_OPTION}-sse \
    --${NACL_OPTION}-sse2 \
    --${NACL_OPTION}-asm \
    "${EXTRA_CONFIGURE_OPTS[@]}"
}

CustomBuildStep() {
 BUILD_DIR=${SRC_DIR}
 # 
 ChangeDir ${BUILD_DIR}
 # Build ${MAKE_TARGETS} or default target if it is not defined
 if [ -n "${MAKEFLAGS:-}" ]; then
   echo "MAKEFLAGS=${MAKEFLAGS}"
   export MAKEFLAGS
 fi
 if [ "${VERBOSE:-}" = "1" ]; then
   MAKE_TARGETS+=" VERBOSE=1 V=1"
 fi
 export PATH=${NACL_BIN_PATH}:${PATH}
 LogExecute make -j${OS_JOBS} ${MAKE_TARGETS:-}
}

CustomPackageInstall() {
  DefaultPreInstallStep
  DefaultDownloadStep
  DefaultExtractStep
  DefaultPatchStep
  CustomConfigureStep
  #DefaultConfigureStep
  #DefaultBuildStep
  CustomBuildStep
  DefaultInstallStep
  #DefaultCleanUpStep
}


CustomPackageInstall
#DefaultPackageInstall
exit 0
