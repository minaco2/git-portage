# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-misc/bijiben/bijiben-3.8.1.ebuild,v 1.2 2013/05/10 07:33:27 patrick Exp $

EAPI="5"
GCONF_DEBUG="no"

inherit gnome2

DESCRIPTION="Note editor designed to remain simple to use"
HOMEPAGE="http://live.gnome.org/Bijiben"

LICENSE="GPL-3+"
SLOT="0"
KEYWORDS="~amd64"
IUSE=""

RDEPEND="
	>=app-misc/tracker-0.16
	>=dev-libs/glib-2.28:2
	dev-libs/libxml2
	gnome-extra/zeitgeist
	media-libs/clutter-gtk:1.0
	net-libs/webkit-gtk:3
	>=x11-libs/gtk+-3.7.7:3
"
DEPEND="${RDEPEND}
	app-text/yelp-tools
	>=dev-util/intltool-0.35.0
	sys-devel/gettext
"
