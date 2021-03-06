# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/sci-mathematics/cado-nfs/cado-nfs-2.0_alpha2.ebuild,v 1.1 2013/10/21 02:34:56 patrick Exp $

EAPI=4
DESCRIPTION="Number Field Sieve (NFS) implementation for factoring integers"
HOMEPAGE="http://cado-nfs.gforge.inria.fr/"
SRC_URI="https://gforge.inria.fr/frs/download.php/32988/${PN}-2.0alpha_55e97b6a.tar.gz -> ${P}.tar.gz"

inherit eutils cmake-utils

LICENSE="LGPL-2.1"
SLOT="0"
#KEYWORDS="~amd64 ~x86"
KEYWORDS=""
IUSE=""

RDEPEND="dev-libs/gmp
	dev-lang/perl
	!sci-mathematics/ggnfs
	!sci-biology/shrimp
	"
DEPEND="${RDEPEND}
	"

# sigh :(
S="${WORKDIR}/cado-nfs-2.0alpha_55e97b6a"

src_prepare() {
	# looks like packaging mistake
	sed -i -e 's/add_executable (convert_rels convert_rels.c)//' misc/CMakeLists.txt || die
	sed -i -e 's/target_link_libraries (convert_rels utils)//' misc/CMakeLists.txt || die
	sed -i -e 's~install(TARGETS convert_rels RUNTIME DESTINATION bin/misc)~~' misc/CMakeLists.txt || die
}

src_configure() {
	DESTINATION="/usr/libexec/cado-nfs" cmake-utils_src_configure
}
src_compile() {
	# autodetection goes confused for gf2x
	ABI=default cmake-utils_src_compile
}
