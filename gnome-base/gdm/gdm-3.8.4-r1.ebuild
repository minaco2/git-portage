# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/gnome-base/gdm/gdm-3.8.4-r1.ebuild,v 1.1 2013/09/28 08:36:50 pacho Exp $

EAPI="5"
GNOME2_LA_PUNT="yes"

inherit autotools eutils gnome2 pam readme.gentoo systemd user

DESCRIPTION="GNOME Display Manager"
HOMEPAGE="https://live.gnome.org/GDM"

LICENSE="GPL-2+"
SLOT="0"
IUSE="accessibility audit fallback fprint +gnome-shell +introspection ipv6 plymouth selinux smartcard +systemd tcpd test xinerama"
KEYWORDS="~alpha ~amd64 ~arm ~ia64 ~ppc ~ppc64 ~sh ~sparc ~x86"

# NOTE: x11-base/xorg-server dep is for X_SERVER_PATH etc, bug #295686
# nspr used by smartcard extension
# dconf, dbus and g-s-d are needed at install time for dconf update
# We need either systemd or >=openrc-0.12 to restart gdm properly, bug #463784
COMMON_DEPEND="
	app-text/iso-codes
	>=dev-libs/glib-2.35:2
	>=x11-libs/gtk+-2.91.1:3
	>=x11-libs/pango-1.3
	dev-libs/nspr
	>=dev-libs/nss-3.11.1
	>=gnome-base/dconf-0.11.6
	>=gnome-base/gnome-settings-daemon-3.1.4
	gnome-base/gsettings-desktop-schemas
	>=media-libs/fontconfig-2.5.0
	>=media-libs/libcanberra-0.4[gtk3]
	sys-apps/dbus
	>=sys-apps/accountsservice-0.6.12
	>=sys-power/upower-0.9

	x11-apps/sessreg
	x11-base/xorg-server
	x11-libs/libXi
	x11-libs/libXau
	x11-libs/libX11
	x11-libs/libXdmcp
	x11-libs/libXext
	x11-libs/libXft
	x11-libs/libXrandr
	>=x11-misc/xdg-utils-1.0.2-r3

	virtual/pam
	systemd? ( >=sys-apps/systemd-186[pam] )
	!systemd? (
		>=x11-base/xorg-server-1.14.3-r1
		!<sys-apps/openrc-0.12 )
	sys-auth/pambase[systemd?]

	audit? ( sys-process/audit )
	introspection? ( >=dev-libs/gobject-introspection-0.9.12 )
	plymouth? ( sys-boot/plymouth )
	selinux? ( sys-libs/libselinux )
	tcpd? ( >=sys-apps/tcp-wrappers-7.6 )
	xinerama? ( x11-libs/libXinerama )
"
# XXX: These deps are from session and desktop files in data/ directory
# at-spi:1 is needed for at-spi-registryd (spawned by simple-chooser)
# fprintd is used via dbus by gdm-fingerprint-extension
# gnome-session-3.6 needed to avoid freezing with orca
RDEPEND="${COMMON_DEPEND}
	>=gnome-base/gnome-session-3.6
	x11-apps/xhost
	x11-themes/gnome-icon-theme-symbolic

	fallback? ( x11-wm/metacity
		accessibility? (
			app-accessibility/orca
			gnome-extra/at-spi:1 ) )
	fprint? (
		sys-auth/fprintd
		sys-auth/pam_fprint )
	gnome-shell? ( >=gnome-base/gnome-shell-3.1.90 )
	!gnome-shell? ( x11-wm/metacity )
	smartcard? (
		app-crypt/coolkey
		sys-auth/pam_pkcs11 )

	!gnome-extra/fast-user-switch-applet
"
DEPEND="${COMMON_DEPEND}
	app-text/docbook-xml-dtd:4.1.2
	>=dev-util/intltool-0.40.0
	>=sys-devel/gettext-0.17
	virtual/pkgconfig
	x11-proto/inputproto
	x11-proto/randrproto
	test? ( >=dev-libs/check-0.9.4 )
	xinerama? ( x11-proto/xineramaproto )
"

DOC_CONTENTS="
	To make GDM start at boot, run:\n
	# systemctl enable gdm.service\n
	\n
	For passwordless login to unlock your keyring, you need to install
	sys-auth/pambase with USE=gnome-keyring and set an empty password
	on your keyring. Use app-crypt/seahorse for that.
"

pkg_setup() {
	enewgroup gdm
	enewgroup video # Just in case it hasn't been created yet
	enewuser gdm -1 -1 /var/lib/gdm gdm,video

	# For compatibility with certain versions of nvidia-drivers, etc., need to
	# ensure that gdm user is in the video group
	if ! egetent group video | grep -q gdm; then
		# FIXME XXX: is this at all portable, ldap-safe, etc.?
		# XXX: egetent does not have a 1-argument form, so we can't use it to
		# get the list of gdm's groups
		local g=$(groups gdm)
		elog "Adding user gdm to video group"
		usermod -G video,${g// /,} gdm || die "Adding user gdm to video group failed"
	fi
}

src_prepare() {
	# make custom session work, bug #216984
	epatch "${FILESDIR}/${PN}-3.2.1.1-custom-session.patch"

	# ssh-agent handling must be done at xinitrc.d, bug #220603
	epatch "${FILESDIR}/${PN}-2.32.0-xinitrc-ssh-agent.patch"

	# Fix automagic selinux, upstream bug #704188
	epatch "${FILESDIR}/${PN}-3.6.0-selinux-automagic.patch"

	# Gentoo does not have a fingerprint-auth pam stack
	epatch "${FILESDIR}/${PN}-3.8.4-fingerprint-auth.patch"

	# make gdm-fallback session the default if USE=-gnome-shell
	if ! use gnome-shell; then
		sed -e "s:'gdm-shell':'gdm-fallback':" \
			-i data/00-upstream-settings || die "sed failed"
	fi

	mkdir -p "${S}"/m4
	sed -i 's/AM_CONFIG_HEADER/AC_CONFIG_HEADERS/g' configure.ac || die
	eautoreconf

	gnome2_src_prepare
}

src_configure() {
	# PAM is the only auth scheme supported
	# even though configure lists shadow and crypt
	# they don't have any corresponding code.
	# --with-at-spi-registryd-directory= needs to be passed explicitly because
	# of https://bugzilla.gnome.org/show_bug.cgi?id=607643#c4
	# Xevie is obsolete, bug #482304
	gnome2_src_configure \
		--with-run-dir=/run/gdm \
		--localstatedir="${EPREFIX}"/var \
		--disable-static \
		--with-xdmcp=yes \
		--enable-authentication-scheme=pam \
		--with-default-pam-config=exherbo \
		--with-at-spi-registryd-directory="${EPREFIX}"/usr/libexec \
		--with-initial-vt=7 \
		--without-console-kit \
		--without-xevie \
		$(use_with audit libaudit) \
		$(use_enable fallback fallback-greeter) \
		$(use_enable ipv6) \
		$(use_with plymouth) \
		$(use_with selinux) \
		$(use_with systemd) \
		$(use_enable systemd systemd-journal) \
		$(systemd_with_unitdir) \
		$(use_with tcpd tcp-wrappers) \
		$(use_with xinerama) \
		ITSTOOL=$(type -P true)
}

src_install() {
	gnome2_src_install

	insinto /etc/X11/xinit/xinitrc.d
	newins "${FILESDIR}/49-keychain-r1" 49-keychain
	newins "${FILESDIR}/50-ssh-agent-r1" 50-ssh-agent

	# log, etc.
	keepdir /var/log/gdm

	# gdm user's home directory
	keepdir /var/lib/gdm
	fowners gdm:gdm /var/lib/gdm

	# install XDG_DATA_DIRS gdm changes
	echo 'XDG_DATA_DIRS="/usr/share/gdm"' > 99xdg-gdm
	doenvd 99xdg-gdm

	readme.gentoo_create_doc
}

pkg_postinst() {
	local d ret

	gnome2_pkg_postinst

	dbus-launch dconf update || die "'dconf update' failed"

	# bug #436456; gdm crashes if /var/lib/gdm subdirs are not owned by gdm:gdm
	ret=0
	ebegin "Fixing "${EROOT}"var/lib/gdm ownership"
	chown gdm:gdm "${EROOT}var/lib/gdm" || ret=1
	for d in "${EROOT}var/lib/gdm/"{.cache,.config,.local}; do
		[[ ! -e "${d}" ]] || chown -R gdm:gdm "${d}" || ret=1
	done
	eend ${ret}

	readme.gentoo_print_elog

	if [[ -f "/etc/X11/gdm/gdm.conf" ]]; then
		elog "You had /etc/X11/gdm/gdm.conf which is the old configuration"
		elog "file.  It has been moved to /etc/X11/gdm/gdm-pre-gnome-2.16"
		mv /etc/X11/gdm/gdm.conf /etc/X11/gdm/gdm-pre-gnome-2.16
	fi
}
