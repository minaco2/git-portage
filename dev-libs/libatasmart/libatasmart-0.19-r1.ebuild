# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-libs/libatasmart/libatasmart-0.19-r1.ebuild,v 1.3 2013/12/01 19:16:20 maekke Exp $

EAPI=5
inherit eutils

PATCH_LEVEL=2

DESCRIPTION="A small and lightweight parser library for ATA S.M.A.R.T. hard disks"
HOMEPAGE="http://0pointer.de/blog/projects/being-smart.html"
SRC_URI="http://0pointer.de/public/${P}.tar.xz
	mirror://debian/pool/main/liba/${PN}/${PN}_${PV}-${PATCH_LEVEL}.debian.tar.gz"

LICENSE="LGPL-2.1"
SLOT="0"
KEYWORDS="~alpha ~amd64 arm hppa ~ia64 ~mips ~ppc ~ppc64 ~sh ~sparc ~x86"
IUSE="static-libs"

RDEPEND="virtual/udev"
DEPEND="${RDEPEND}
	virtual/pkgconfig"

DOCS="README"

src_prepare() {
	# http://bugs.gentoo.org/470874
	local d="${WORKDIR}"/debian/patches
	sed -i -e '/#/d' "${d}"/series || die
	EPATCH_SOURCE="${d}" epatch $(<"${d}"/series)
}

src_configure() {
	econf \
		--docdir=/usr/share/doc/${PF} \
		$(use_enable static-libs static)
}

src_install() {
	default
	prune_libtool_files --all
}
