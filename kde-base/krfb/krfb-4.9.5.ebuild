# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/kde-base/krfb/krfb-4.9.5.ebuild,v 1.4 2013/01/27 23:47:26 ago Exp $

EAPI=4

KDE_HANDBOOK="optional"
KMNAME="kdenetwork"
KDE_SCM="svn"
inherit kde4-meta

DESCRIPTION="VNC-compatible server to share KDE desktops"
KEYWORDS="amd64 ~arm ppc x86 ~amd64-linux ~x86-linux"
IUSE="debug telepathy"

DEPEND="
	sys-libs/zlib
	virtual/jpeg
	!aqua? ( x11-libs/libXdamage )
	telepathy? ( >=net-libs/telepathy-qt-0.9 )
"
RDEPEND="${DEPEND}"

src_configure() {
	mycmakeargs=(
		$(cmake-utils_use_with telepathy TelepathyQt4)
	)

	kde4-meta_src_configure
}
