# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/kde-base/krdc/krdc-4.9.4.ebuild,v 1.2 2012/12/23 19:17:40 maekke Exp $

EAPI=4

KDE_HANDBOOK="optional"
KMNAME="kdenetwork"
KDE_SCM="svn"
inherit kde4-meta

DESCRIPTION="KDE remote desktop connection (RDP and VNC) client"
KEYWORDS="~amd64 ~arm ~ppc ~x86 ~amd64-linux ~x86-linux"
IUSE="debug jpeg rdesktop vnc zeroconf telepathy"

#nx? ( >=net-misc/nxcl-0.9-r1 ) disabled upstream, last checked 4.3.61

DEPEND="
	jpeg? ( virtual/jpeg )
	vnc? ( >=net-libs/libvncserver-0.9 )
	zeroconf? ( net-dns/avahi )
	telepathy? ( >=net-libs/telepathy-qt-0.9 )
"
RDEPEND="${DEPEND}
	rdesktop? ( net-misc/rdesktop )
"

src_configure() {
	mycmakeargs=(
		$(cmake-utils_use_with jpeg)
		$(cmake-utils_use_with telepathy TelepathyQt4)
		$(cmake-utils_use_with vnc LibVNCServer)
		$(cmake-utils_use_with zeroconf DNSSD)
	)

	kde4-meta_src_configure
}
