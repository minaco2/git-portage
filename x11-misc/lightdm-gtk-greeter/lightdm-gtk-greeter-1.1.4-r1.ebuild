# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/x11-misc/lightdm-gtk-greeter/lightdm-gtk-greeter-1.1.4-r1.ebuild,v 1.2 2012/02/27 20:00:10 hwoarang Exp $

EAPI=4

DESCRIPTION="LightDM GTK+ Greeter"
HOMEPAGE="http://launchpad.net/lightdm-gtk-greeter"
SRC_URI="http://launchpad.net/lightdm-gtk-greeter/trunk/${PV}/+download/${P}.tar.gz branding? (
http://dev.gentoo.org/~hwoarang/distfiles/lightdm-gentoo-patch.tar.gz )"

LICENSE="GPL-3 LGPL-3"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="branding"

DEPEND="x11-libs/gtk+:3
	>=x11-misc/lightdm-1.1.3"
RDEPEND="!!<x11-misc/lightdm-1.1.1
	x11-libs/gtk+:3
	>=x11-misc/lightdm-1.1.3
	x11-themes/gnome-themes-standard
	x11-themes/gnome-icon-theme"

src_prepare() {
	# Ok, this has to be fixed in the tarball but I am too lazy to do it.
	# I will fix this once I decide to update the tarball with a new gentoo
	# background
	# Bug #404467
	if use branding; then
		sed -i -e "/xft-hintstyle/s:slight:hintslight:" ${WORKDIR}/${PN}.conf || die
	fi
}

src_install() {
	default

	if use branding; then
		insinto /etc/lightdm/
		doins "${WORKDIR}"/${PN}.conf
		insinto /usr/share/lightdm/backgrounds/
		doins "${WORKDIR}"/gentoo1024x768.png
		sed -i -e "/background/s:=.*:=/usr/share/lightdm/backgrounds/gentoo1024x768.png:" \
			"${D}"/etc/lightdm/${PN}.conf || die
	fi
}
