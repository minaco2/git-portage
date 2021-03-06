# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/mail-client/evolution/evolution-3.6.2-r1.ebuild,v 1.9 2013/02/10 20:49:08 tetromino Exp $

EAPI="5"
GCONF_DEBUG="no"
GNOME2_LA_PUNT="yes"

inherit autotools eutils flag-o-matic gnome2 versionator

MY_MAJORV=$(get_version_component_range 1-2)

DESCRIPTION="Integrated mail, addressbook and calendaring functionality"
HOMEPAGE="http://projects.gnome.org/evolution/"
SRC_URI="${SRC_URI}
	http://dev.gentoo.org/~tetromino/distfiles/${PN}/${P}-gentoo-patches.tar.xz"

# Note: explicitly "|| ( LGPL-2 LGPL-3 )", not "LGPL-2+".
LICENSE="|| ( LGPL-2 LGPL-3 ) CC-BY-SA-3.0 FDL-1.3+ OPENLDAP"
SLOT="2.0"
IUSE="crypt +gnome-online-accounts gstreamer kerberos ldap map ssl +weather"
KEYWORDS="~alpha ~amd64 ~arm ~ia64 ~ppc ~ppc64 ~sparc ~x86 ~x86-fbsd"

# We need a graphical pinentry frontend to be able to ask for the GPG
# password from inside evolution, bug 160302
PINENTRY_DEPEND="|| ( app-crypt/pinentry[gtk] app-crypt/pinentry-qt app-crypt/pinentry[qt4] )"

# glade-3 support is for maintainers only per configure.ac
# pst is not mature enough and changes API/ABI frequently
# also supports gstreamer 1.0
COMMON_DEPEND=">=dev-libs/glib-2.32:2
	>=x11-libs/cairo-1.9.15:=[glib]
	>=x11-libs/gtk+-3.4.0:3
	>=gnome-base/gnome-desktop-2.91.3:3=
	>=gnome-base/gsettings-desktop-schemas-2.91.92
	>=media-libs/libcanberra-0.25[gtk3]
	>=x11-libs/libnotify-0.7:=
	>=gnome-extra/evolution-data-server-${PV}:=[gnome-online-accounts?,weather?]
	=gnome-extra/evolution-data-server-${MY_MAJORV}*
	>=gnome-extra/gtkhtml-4.5.2:4.0
	dev-libs/atk
	>=dev-libs/dbus-glib-0.6
	>=dev-libs/libxml2-2.7.3:2
	>=net-libs/libsoup-gnome-2.38.1:2.4
	>=x11-misc/shared-mime-info-0.22
	>=x11-themes/gnome-icon-theme-2.30.2.1
	>=dev-libs/libgdata-0.10:=
	>=net-libs/webkit-gtk-1.8.0
	!=net-libs/webkit-gtk-1.9.90

	x11-libs/libSM
	x11-libs/libICE

	map? (
		>=media-libs/clutter-1.0.0:1.0
		>=media-libs/clutter-gtk-0.90:1.0
		x11-libs/mx:1.0 )
	crypt? ( || (
		( >=app-crypt/gnupg-2.0.1-r2 ${PINENTRY_DEPEND} )
		=app-crypt/gnupg-1.4* ) )
	gnome-online-accounts? ( >=net-libs/gnome-online-accounts-3.2 )
	gstreamer? (
		>=media-libs/gstreamer-0.10:0.10
		>=media-libs/gst-plugins-base-0.10:0.10 )
	kerberos? ( virtual/krb5:= )
	ldap? ( >=net-nds/openldap-2:= )
	map? (
		>=app-misc/geoclue-0.12.0
		>=media-libs/libchamplain-0.12:0.12 )
	ssl? (
		>=dev-libs/nspr-4.6.1:=
		>=dev-libs/nss-3.11:= )
	weather? ( >=dev-libs/libgweather-3.5.0:2= )"
DEPEND="${COMMON_DEPEND}
	app-text/docbook-xml-dtd:4.1.2
	dev-util/gtk-doc-am
	>=dev-util/intltool-0.40.0
	virtual/pkgconfig

	app-text/yelp-tools
	>=gnome-base/gnome-common-2.12"
# eautoreconf needs:
#	app-text/yelp-tools
#	>=gnome-base/gnome-common-2.12
RDEPEND="${COMMON_DEPEND}
	app-text/highlight
	!<gnome-extra/evolution-exchange-2.32"

src_prepare() {
	ELTCONF="--reverse-deps"
	DOCS="AUTHORS ChangeLog* HACKING MAINTAINERS NEWS* README"
	# image-inline plugin needs a gtk+:3 gtkimageview, which does not exist yet
	G2CONF="${G2CONF}
		--disable-schemas-compile
		--without-glade-catalog
		--without-kde-applnk-path
		--disable-image-inline
		--disable-pst-import
		--enable-canberra
		$(use_enable ssl nss)
		$(use_enable ssl smime)
		$(use_enable gnome-online-accounts goa)
		$(use_enable gstreamer audio-inline)
		$(use_enable map contact-maps)
		$(use_with ldap openldap)
		$(use_with kerberos krb5 ${EPREFIX}/usr)
		$(use_enable weather)"

	# Use NSS/NSPR only if 'ssl' is enabled.
	if use ssl ; then
		G2CONF="${G2CONF} --enable-nss=yes"
	else
		G2CONF="${G2CONF}
			--without-nspr-libs
			--without-nspr-includes
			--without-nss-libs
			--without-nss-includes"
	fi
	G2CONF="${G2CONF} ITSTOOL=$(type -P true)"

	# Fix paths for Gentoo spamassassin executables
	epatch "${FILESDIR}/${PN}-3.3.91-spamassassin-paths.patch"

	sed -e "s:@EPREFIX@:${EPREFIX}:g" \
		-i data/org.gnome.evolution.spamassassin.gschema.xml.in \
		-i modules/spamassassin/evolution-spamassassin.c || die "sed failed"

	# Lots of crash and UI fixes, will be in 3.6.3
	epatch ../patches/*.patch
	eautoreconf

	gnome2_src_prepare

	# Fix compilation flags crazyness
	sed -e 's/\(AM_CPPFLAGS="\)$WARNING_FLAGS/\1/' \
		-i configure || die "CPPFLAGS sed failed"
}

pkg_postinst() {
	gnome2_pkg_postinst

	elog "To change the default browser if you are not using GNOME, edit"
	elog "~/.local/share/applications/mimeapps.list so it includes the"
	elog "following content:"
	elog ""
	elog "[Default Applications]"
	elog "x-scheme-handler/http=firefox.desktop"
	elog "x-scheme-handler/https=firefox.desktop"
	elog ""
	elog "(replace firefox.desktop with the name of the appropriate .desktop"
	elog "file from /usr/share/applications if you use a different browser)."
	elog ""
	elog "Junk filters are now a run-time choice. You will get a choice of"
	elog "bogofilter or spamassassin based on which you have installed"
	elog ""
	elog "You have to install one of these for the spam filtering to actually work"
}
