

readonly URL=http://www.exiv2.org/exiv2-0.23.tar.gz
readonly PATCH_FILE=nacl-exiv2-0.23.patch
readonly PACKAGE_NAME=exiv2-0.23

source ../../build_tools/common.sh

export LIBS=-lnosys

CustomConfigureStep() {
  local EXTRA_CONFIGURE_OPTS=("${@:-}")
  Banner "Configuring ${PACKAGE_NAME}"
  # export the nacl tools
  export CC=${NACLCC}
  export CXX=${NACLCXX}" "-lpthread
  export AR=${NACLAR}
  export RANLIB=${NACLRANLIB}
  export PKG_CONFIG_PATH=${NACL_SDK_USR_LIB}/pkgconfig
  export PKG_CONFIG_LIBDIR=${NACL_SDK_USR_LIB}
  export FREETYPE_CONFIG=${NACL_SDK_USR_BIN}/freetype-config
  export PATH=${NACL_BIN_PATH}:${PATH};
  ChangeDir ${NACL_PACKAGES_REPOSITORY}/${PACKAGE_NAME}
  #Remove ${PACKAGE_NAME}-build
  #MakeDir ${PACKAGE_NAME}-build
  #cd ${PACKAGE_NAME}-build
  echo "Directory: $(pwd)"

  local conf_host=${NACL_CROSS_PREFIX}
  if [[ ${NACL_PACKAGES_BITSIZE} == "pnacl" ]]; then
    # The PNaCl tools use "pnacl-" as the prefix, but config.sub
    # does not know about "pnacl".  It only knows about "le32-nacl".
    # Unfortunately, most of the config.subs here are so old that
    # it doesn't know about that "le32" either.  So we just say "nacl".
    conf_host="nacl"
  fi
  ./configure \
    --host=${conf_host} \
    --disable-shared \
    --prefix=${NACL_SDK_USR} \
    --exec-prefix=${NACL_SDK_USR} \
    --libdir=${NACL_SDK_USR_LIB} \
    --oldincludedir=${NACL_SDK_USR_INCLUDE} \
    --with-http=off \
    --with-html=off \
    --with-ftp=off \
    --${NACL_OPTION}-mmx \
    --${NACL_OPTION}-sse \
    --${NACL_OPTION}-sse2 \
    --${NACL_OPTION}-asm \
    --with-x=no  \
    "${EXTRA_CONFIGURE_OPTS[@]}"
}


CustomPackageInstall() {
  DefaultPreInstallStep
  DefaultDownloadStep
  DefaultExtractStep
  DefaultPatchStep
  CustomConfigureStep
  #DefaultConfigureStep
  DefaultBuildStep
  DefaultInstallStep
  DefaultCleanUpStep
}


CustomPackageInstall
#DefaultPackageInstall
exit 0
