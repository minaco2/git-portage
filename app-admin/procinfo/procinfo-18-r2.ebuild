# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-admin/procinfo/procinfo-18-r2.ebuild,v 1.4 2013/12/03 14:02:45 nimiux Exp $

EAPI=5
inherit eutils toolchain-funcs

DESCRIPTION="Displays some kernel stats and info on a running Linux system"
HOMEPAGE="http://www.kozmix.org/src/"
SRC_URI="http://www.kozmix.org/src/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~alpha amd64 arm hppa ~ia64 ~ppc ~ppc64 ~s390 ~sh ~sparc ~x86"
IUSE=""

src_prepare() {
	epatch "${FILESDIR}"/kernel-2.6.patch
	epatch "${FILESDIR}"/cpu-usage-fix.patch
	epatch "${FILESDIR}"/${PN}-flags.patch
	epatch "${FILESDIR}"/${P}-stat.patch
}

src_compile() {
	emake \
		CC=$(tc-getCC) \
		LDLIBS="$( $(tc-getPKG_CONFIG) --libs ncurses )"
}

src_install() {
	dobin procinfo
	newbin lsdev.pl lsdev
	newbin socklist.pl socklist

	doman *.8
	dodoc README CHANGES
}
