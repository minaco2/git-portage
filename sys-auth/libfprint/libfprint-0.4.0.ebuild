# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/sys-auth/libfprint/libfprint-0.4.0.ebuild,v 1.14 2013/11/16 12:27:59 pacho Exp $

EAPI=4

inherit autotools eutils udev

MY_PV="v_${PV//./_}"
DESCRIPTION="library to add support for consumer fingerprint readers"
HOMEPAGE="http://cgit.freedesktop.org/libfprint/libfprint/"
SRC_URI="http://cgit.freedesktop.org/${PN}/${PN}/snapshot/${MY_PV}.tar.bz2 -> ${P}.tar.bz2"

LICENSE="LGPL-2.1"
SLOT="0"
KEYWORDS="~alpha amd64 ~arm ~ia64 ~ppc ~ppc64 ~sparc ~x86"
IUSE="debug static-libs"

RDEPEND="virtual/libusb:1
	dev-libs/nss
	|| ( media-gfx/imagemagick media-gfx/graphicsmagick[imagemagick] x11-libs/gdk-pixbuf )"
DEPEND="${RDEPEND}
	virtual/pkgconfig"

S=${WORKDIR}/${MY_PV}

src_prepare() {
	mkdir m4 || die
	eautoreconf
}

pkg_setup() {
	einfo
	elog "This version does not support fdu2000 and upektc (yet)."
	einfo
}

src_configure() {
	econf \
		$(use_enable debug debug-log) \
		$(use_enable static-libs static)
}

src_install() {
	emake \
		DESTDIR="${D}" \
		udev_rulesdir="$(udev_get_udevdir)/rules.d" \
		install

	prune_libtool_files
	dodoc AUTHORS HACKING NEWS README THANKS TODO
}
