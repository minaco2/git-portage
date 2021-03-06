# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/sys-fs/leechcraft-vrooby/leechcraft-vrooby-9999.ebuild,v 1.5 2012/12/26 11:24:18 maksbotan Exp $

EAPI="4"

inherit leechcraft

DESCRIPTION="Vrooby, removable device manager for LeechCraft."

SLOT="0"
KEYWORDS=""
IUSE="debug udisks udisks2"

DEPEND="~net-misc/leechcraft-core-${PV}
		x11-libs/qt-dbus:4"
RDEPEND="${DEPEND}
		udisks? ( sys-fs/udisks:0 )
		udisks2? ( sys-fs/udisks:2 )
		"

REQUIRED_USE="^^ ( udisks udisks2 )"

src_configure() {
	local mycmakeargs=(
		$(cmake-utils_use_enable udisks VROOBY_UDISKS)
		$(cmake-utils_use_enable udisks2 VROOBY_UDISKS2)
	)

	cmake-utils_src_configure
}

pkg_postinst() {
	if use udisks2; then
		elog "You have enabled the experimental UDisks2 backend. "
		elog "Please try the old udisks:0-based one before "
		elog "reporting issues."
	fi
}
