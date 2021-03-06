# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/gnome-base/libgnome-keyring/libgnome-keyring-3.8.0.ebuild,v 1.4 2013/11/30 19:12:48 pacho Exp $

EAPI="5"
GCONF_DEBUG="yes"
GNOME2_LA_PUNT="yes"
VALA_MIN_API_VERSION="0.16"
VALA_USE_DEPEND="vapigen"
PYTHON_COMPAT=( python{2_6,2_7} )

inherit gnome2 python-any-r1 vala

DESCRIPTION="Compatibility library for accessing secrets"
HOMEPAGE="http://live.gnome.org/GnomeKeyring"

LICENSE="LGPL-2+ GPL-2+" # tests are GPL-2
SLOT="0"
KEYWORDS="~alpha amd64 ~arm ~ia64 ~mips ~ppc ~ppc64 ~sh ~sparc ~x86 ~amd64-fbsd ~x86-fbsd ~amd64-linux ~arm-linux ~x86-linux ~sparc-solaris"
IUSE="debug +introspection test vala"
REQUIRED_USE="vala? ( introspection )"

RDEPEND="
	>=sys-apps/dbus-1
	>=gnome-base/gnome-keyring-3.1.92
	introspection? ( >=dev-libs/gobject-introspection-1.30.0 )
"
DEPEND="${RDEPEND}
	dev-util/gtk-doc-am
	>=dev-util/intltool-0.35
	sys-devel/gettext
	virtual/pkgconfig
	test? ( ${PYTHON_DEPS} )
	vala? ( $(vala_depend) )"

src_prepare() {
	use vala && vala_src_prepare
	gnome2_src_prepare

	# FIXME: Remove silly CFLAGS, report upstream
	sed -e 's:CFLAGS="$CFLAGS -g:CFLAGS="$CFLAGS:' \
		-e 's:CFLAGS="$CFLAGS -O0:CFLAGS="$CFLAGS:' \
		-i configure.ac configure || die "sed failed"
}

src_configure() {
	gnome2_src_configure $(use_enable vala)
}

src_test() {
	unset DBUS_SESSION_BUS_ADDRESS
	dbus-launch emake check || die "tests failed"
}
