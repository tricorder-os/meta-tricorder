DESCRIPTION = "android platform tools"
LICENSE = "APACHE-2.0"
LIC_FILES_CHKSUM = "file://MODULE_LICENSE_APACHE2;md5=d41d8cd98f00b204e9800998ecf8427e"

SRC_URI = " \
  git://android.googlesource.com/platform/system/core;protocol=https;tag=android-8.1.0_r14;nobranch=1 \
  "

inherit allarch

BBCLASSEXTEND = "native"
RDEPENDS_mkbootimg = " \
  python-core \
  python-argparse \
  "

S = "${WORKDIR}/git"

do_install() {
  install -d ${D}/${bindir}
  install -m 0755 ${S}/mkbootimg/mkbootimg ${D}/${bindir}
}
