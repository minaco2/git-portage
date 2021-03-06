# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-office/abiword-docs/abiword-docs-3.0.0.ebuild,v 1.1 2013/10/14 20:57:26 pacho Exp $

EAPI=5
GCONF_DEBUG="no"

inherit gnome2

DESCRIPTION="Fully featured yet light and fast cross platform word processor documentation"
HOMEPAGE="http://www.abisource.com/"
SRC_URI="http://www.abisource.com/downloads/abiword/${PV}/source/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

RDEPEND=">=app-office/abiword-${PV}"
DEPEND="${RDEPEND}"

src_prepare() {
	# http://bugzilla.abisource.com/show_bug.cgi?id=13564
	epatch "${FILESDIR}"/${PN}-3.0.0-doc{1,2,3}.patch
	gnome2_src_prepare
}
