# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/net-misc/dhcpcd/dhcpcd-6.0.2.ebuild,v 1.1 2013/07/07 01:12:52 williamh Exp $

EAPI=5

if [[ ${PV} == "9999" ]]; then
	EGIT_REPO_URI="git://roy.marples.name/${PN}.git"
	inherit git-2
else
	MY_P="${P/_alpha/-alpha}"
	MY_P="${MY_P/_beta/-beta}"
	MY_P="${MY_P/_rc/-rc}"
	SRC_URI="http://roy.marples.name/downloads/${PN}/${MY_P}.tar.bz2"
	KEYWORDS="~alpha ~amd64 ~arm ~hppa ~ia64 ~mips ~ppc ~ppc64 ~s390 ~sh ~sparc ~x86 ~amd64-fbsd ~sparc-fbsd ~x86-fbsd ~amd64-linux ~arm-linux ~x86-linux"
	S="${WORKDIR}/${MY_P}"
fi

inherit eutils systemd

DESCRIPTION="A fully featured, yet light weight RFC2131 compliant DHCP client"
HOMEPAGE="http://roy.marples.name/projects/dhcpcd/"
LICENSE="BSD-2"
SLOT="0"
IUSE="elibc_glibc"

DEPEND=""
RDEPEND=""

src_prepare()
{
	epatch_user
}

src_configure()
{
	local hooks="--with-hook=ntp.conf"
	use elibc_glibc && hooks="${hooks} --with-hook=yp.conf"
	econf \
			--prefix="${EPREFIX}" \
			--libexecdir="${EPREFIX}/lib/dhcpcd" \
			--dbdir="${EPREFIX}/var/lib/dhcpcd" \
		--localstatedir="${EPREFIX}/var" \
		${hooks}
}

src_install()
{
	default
	newinitd "${FILESDIR}"/${PN}.initd ${PN}
	systemd_dounit "${FILESDIR}"/${PN}.service
}

pkg_postinst()
{
	# Upgrade the duid file to the new format if needed
	local old_duid="${ROOT}"/var/lib/dhcpcd/dhcpcd.duid
	local new_duid="${ROOT}"/etc/dhcpcd.duid
	if [ -e "${old_duid}" ] && ! grep -q '..:..:..:..:..:..' "${old_duid}"; then
		sed -i -e 's/\(..\)/\1:/g; s/:$//g' "${old_duid}"
	fi

	# Move the duid to /etc, a more sensible location
	if [ -e "${old_duid}" -a ! -e "${new_duid}" ]; then
		cp -p "${old_duid}" "${new_duid}"
	fi

	elog
	elog "dhcpcd has zeroconf support active by default."
	elog "This means it will always obtain an IP address even if no"
	elog "DHCP server can be contacted, which will break any existing"
	elog "failover support you may have configured in your net configuration."
	elog "This behaviour can be controlled with the noipv4ll configuration"
	elog "file option or the -L command line switch."
	elog "See the dhcpcd and dhcpcd.conf man pages for more details."

	if ! has_version net-dns/bind-tools; then
		elog
		elog "If you activate the lookup-hostname hook to look up your hostname"
		elog "using the dns, you need to install net-dns/bind-tools."
	fi
}
