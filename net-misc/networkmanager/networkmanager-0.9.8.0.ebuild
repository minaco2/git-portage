# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/net-misc/networkmanager/networkmanager-0.9.8.0.ebuild,v 1.2 2013/05/18 15:56:47 pacho Exp $

EAPI="5"
GNOME_ORG_MODULE="NetworkManager"
VALA_MIN_API_VERSION="0.18"
VALA_USE_DEPEND="vapigen"

inherit eutils gnome.org linux-info systemd user toolchain-funcs vala virtualx udev

DESCRIPTION="Universal network configuration daemon for laptops, desktops, servers and virtualization hosts"
HOMEPAGE="http://projects.gnome.org/NetworkManager/"

LICENSE="GPL-2+"
SLOT="0" # add subslot if libnm-util.so.2 or libnm-glib.so.4 bumps soname version
IUSE="avahi bluetooth connection-sharing +consolekit dhclient +dhcpcd doc gnutls
+introspection kernel_linux +nss modemmanager +ppp resolvconf systemd test vala
+wext" # wimax
KEYWORDS="~alpha ~amd64 ~arm ~ia64 ~ppc ~ppc64 ~sparc ~x86"

REQUIRED_USE="
	modemmanager? ( ppp )
	^^ ( nss gnutls )
	^^ ( dhclient dhcpcd )
	?? ( consolekit systemd )
"

# gobject-introspection-0.10.3 is needed due to gnome bug 642300
# wpa_supplicant-0.7.3-r3 is needed due to bug 359271
# TODO: Qt support?
COMMON_DEPEND="
	>=sys-apps/dbus-1.2
	>=dev-libs/dbus-glib-0.94
	>=dev-libs/glib-2.30
	>=dev-libs/libnl-3.2.7:3=
	>=sys-auth/polkit-0.106
	>=net-libs/libsoup-2.26:2.4=
	>=net-wireless/wpa_supplicant-0.7.3-r3[dbus]
	>=virtual/udev-165[gudev]
	bluetooth? ( >=net-wireless/bluez-4.82 )
	avahi? ( net-dns/avahi:=[autoipd] )
	connection-sharing? (
		net-dns/dnsmasq
		net-firewall/iptables )
	gnutls? (
		dev-libs/libgcrypt:=
		net-libs/gnutls:= )
	modemmanager? ( >=net-misc/modemmanager-0.7.990 )
	nss? ( >=dev-libs/nss-3.11:= )
	dhclient? ( =net-misc/dhcp-4*[client] )
	dhcpcd? ( >=net-misc/dhcpcd-4.0.0_rc3 )
	introspection? ( >=dev-libs/gobject-introspection-0.10.3 )
	ppp? ( >=net-dialup/ppp-2.4.5[ipv6] )
	resolvconf? ( net-dns/openresolv )
	systemd? ( >=sys-apps/systemd-183 )
	!systemd? ( sys-power/upower )
"
RDEPEND="${COMMON_DEPEND}
	consolekit? ( sys-auth/consolekit )
"
DEPEND="${COMMON_DEPEND}
	>=dev-util/intltool-0.40
	>=sys-devel/gettext-0.17
	>=sys-kernel/linux-headers-2.6.29
	virtual/pkgconfig
	doc? ( >=dev-util/gtk-doc-1.8 )
	vala? ( $(vala_depend) )
	test? (
		dev-lang/python:2.7
		dev-python/dbus-python[python_targets_python2_7]
		dev-python/pygobject:2[python_targets_python2_7] )
"

sysfs_deprecated_check() {
	ebegin "Checking for SYSFS_DEPRECATED support"

	if { linux_chkconfig_present SYSFS_DEPRECATED_V2; }; then
		eerror "Please disable SYSFS_DEPRECATED_V2 support in your kernel config and recompile your kernel"
		eerror "or NetworkManager will not work correctly."
		eerror "See http://bugs.gentoo.org/333639 for more info."
		die "CONFIG_SYSFS_DEPRECATED_V2 support detected!"
	fi
	eend $?
}

pkg_pretend() {
	if use kernel_linux; then
		get_version
		if linux_config_exists; then
			sysfs_deprecated_check
		else
			ewarn "Was unable to determine your kernel .config"
			ewarn "Please note that if CONFIG_SYSFS_DEPRECATED_V2 is set in your kernel .config, NetworkManager will not work correctly."
			ewarn "See http://bugs.gentoo.org/333639 for more info."
		fi

	fi
}

pkg_setup() {
	enewgroup plugdev
}

src_prepare() {
	# Bug #402085, https://bugzilla.gnome.org/show_bug.cgi?id=387832
	epatch "${FILESDIR}/${PN}-0.9.7.995-pre-sleep.patch"

	# Use python2.7 shebangs for test scripts
	sed -e 's@\(^#!.*python\)@\12.7@' \
		-i */tests/*.py || die

	# Fix completiondir, avoid eautoreconf, bug #465100
	sed -i 's|^completiondir =.*|completiondir = $(datadir)/bash-completion|' \
		cli/completion/Makefile.in || die "sed completiondir failed"

	epatch_user

	use vala && vala_src_prepare

	# Force use of /run, avoid eautoreconf
	sed -e 's:$localstatedir/run/:/run/:' -i configure || die

	default
}

src_configure() {
	# TODO: enable wimax when we have a libnl:3 compatible revision of it
	econf \
		--disable-more-warnings \
		--disable-static \
		--localstatedir=/var \
		--enable-ifnet \
		--without-netconfig \
		--with-dbus-sys-dir=/etc/dbus-1/system.d \
		--with-udev-dir="$(udev_get_udevdir)" \
		--with-iptables=/sbin/iptables \
		--enable-concheck \
		--with-crypto=$(usex nss nss gnutls) \
		--with-session-tracking=$(usex consolekit consolekit $(usex systemd systemd no)) \
		--with-suspend-resume=$(usex systemd systemd upower) \
		$(use_enable doc) \
		$(use_enable introspection) \
		$(use_enable ppp) \
		--disable-wimax \
		$(use_with dhclient) \
		$(use_with dhcpcd) \
		$(use_with doc docs) \
		$(use_with modemmanager modem-manager-1) \
		$(use_with resolvconf) \
		$(use_enable test tests) \
		$(use_enable vala) \
		$(use_with wext) \
		"$(systemd_with_unitdir)"
}

src_test() {
	cp libnm-util/tests/certs/test_ca_cert.pem src/settings/plugins/ifnet/tests/ || die
	Xemake check
}

src_install() {
	default

	# Gentoo init script
	newinitd "${FILESDIR}/init.d.NetworkManager" NetworkManager

	# /var/run/NetworkManager is used by some distros, but not by Gentoo
	rmdir -v "${ED}/var/run/NetworkManager" || die "rmdir failed"

	# Need to keep the /etc/NetworkManager/dispatched.d for dispatcher scripts
	keepdir /etc/NetworkManager/dispatcher.d

	if use systemd; then
		# Our init.d script requires running a dispatcher script that annoys
		# systemd users; bug #434692
		rm -rv "${ED}/etc/init.d" || die "rm failed"
	else
		# Provide openrc net dependency only when nm is connected
		exeinto /etc/NetworkManager/dispatcher.d
		newexe "${FILESDIR}/10-openrc-status-r3" 10-openrc-status
		sed -e "s:@EPREFIX@:${EPREFIX}:g" \
			-i "${ED}/etc/NetworkManager/dispatcher.d/10-openrc-status" || die

		# Default conf.d file
		newconfd "${FILESDIR}/conf.d.NetworkManager" NetworkManager
	fi

	# Add keyfile plugin support
	keepdir /etc/NetworkManager/system-connections
	chmod 0600 "${ED}"/etc/NetworkManager/system-connections/.keep* # bug #383765
	insinto /etc/NetworkManager
	newins "${FILESDIR}/nm-system-settings.conf-ifnet" NetworkManager.conf

	# Allow users in plugdev group to modify system connections
	insinto /usr/share/polkit-1/rules.d/
	doins "${FILESDIR}/01-org.freedesktop.NetworkManager.settings.modify.system.rules"

	# Remove useless .la files
	prune_libtool_files --modules
}

pkg_postinst() {
	elog "To modify system network connections without needing to enter the"
	elog "root password, add your user account to the 'plugdev' group."

	if [[ -e "${EROOT}etc/NetworkManager/nm-system-settings.conf" ]]; then
		ewarn "The ${PN} system configuration file has moved to a new location."
		ewarn "You must migrate your settings from ${EROOT}/etc/NetworkManager/nm-system-settings.conf"
		ewarn "to ${EROOT}etc/NetworkManager/NetworkManager.conf"
		ewarn
		ewarn "After doing so, you can remove ${EROOT}etc/NetworkManager/nm-system-settings.conf"
	fi

	# The polkit rules file moved to /usr/share
	old_rules="${EROOT}etc/polkit-1/rules.d/01-org.freedesktop.NetworkManager.settings.modify.system.rules"
	if [[ -f "${old_rules}" ]]; then
		case "$(md5sum ${old_rules})" in
		  574d0cfa7e911b1f7792077003060240* )
			# Automatically delete the old rules.d file if the user did not change it
			elog
			elog "Removing old ${old_rules} ..."
			rm -f "${old_rules}" || eerror "Failed, please remove ${old_rules} manually"
			;;
		  * )
			elog "The ${old_rules}"
			elog "file moved to /usr/share/polkit-1/rules.d/ in >=networkmanager-0.9.4.0-r4"
			elog "If you edited ${old_rules}"
			elog "without changing its behavior, you may want to remove it."
			;;
		esac
	fi
}
