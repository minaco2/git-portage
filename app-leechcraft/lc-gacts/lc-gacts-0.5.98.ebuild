# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-leechcraft/lc-gacts/lc-gacts-0.5.98.ebuild,v 1.1 2013/07/03 15:59:24 maksbotan Exp $

EAPI="4"

inherit leechcraft

DESCRIPTION="Allows other LeechCraft modules to register global shortcuts"

SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="debug"

DEPEND="~app-leechcraft/lc-core-${PV}
	x11-libs/libqxt"
RDEPEND="${DEPEND}"
