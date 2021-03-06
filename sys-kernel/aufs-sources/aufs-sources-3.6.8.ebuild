# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/sys-kernel/aufs-sources/aufs-sources-3.6.8.ebuild,v 1.5 2012/12/21 09:17:22 jlec Exp $

EAPI=5
ETYPE="sources"
K_WANT_GENPATCHES="base extras"
K_GENPATCHES_VER="9"
K_DEBLOB_AVAILABLE="1"
inherit kernel-2 eutils
detect_version
detect_arch

AUFS_TARBALL="${P}.tar.xz"

# git archive -v --remote=git://aufs.git.sourceforge.net/gitroot/aufs/aufs3-standalone.git aufs3.6 ${AUFS_TARBALL}
AUFS_URI="http://dev.gentoo.org/~jlec/distfiles/${AUFS_TARBALL}"

KEYWORDS="~amd64 ~x86"
HOMEPAGE="http://dev.gentoo.org/~mpagano/genpatches http://aufs.sourceforge.net/"
IUSE="deblob module"

DESCRIPTION="Full sources including the Gentoo patchset for the ${KV_MAJOR}.${KV_MINOR} kernel tree and aufs3 support"
SRC_URI="${KERNEL_URI} ${GENPATCHES_URI} ${ARCH_URI} ${AUFS_URI}"

UNIPATCH_LIST="
	"${WORKDIR}"/aufs3-kbuild.patch
	"${WORKDIR}"/aufs3-base.patch"
#	${WORKDIR}/aufs3-proc_map.patch"

PDEPEND="sys-fs/aufs-util"

src_unpack() {
	use module && UNIPATCH_LIST+=" "${WORKDIR}"/aufs3-standalone.patch"
	unpack ${AUFS_TARBALL}
	kernel-2_src_unpack
}

src_prepare() {
	cp -i "${WORKDIR}"/include/linux/aufs_type.h include/linux/aufs_type.h || die
	cp -ri "${WORKDIR}"/{Documentation,fs} . || die
	sed -i "s:__user::g" include/linux/aufs_type.h || die
}

pkg_postinst() {
	kernel-2_pkg_postinst
	einfo "For more info on this patchset, and how to report problems, see:"
	einfo "${HOMEPAGE}"
}

pkg_postrm() {
	kernel-2_pkg_postrm
}
