# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/mail-mta/opensmtpd/opensmtpd-5.3.3_p1.ebuild,v 1.1 2013/06/05 16:59:27 zx2c4 Exp $

EAPI=5

inherit multilib user flag-o-matic eutils pam toolchain-funcs autotools versionator

DESCRIPTION="Lightweight but featured SMTP daemon from OpenBSD"
HOMEPAGE="http://www.opensmtpd.org/"
MY_DP="${P}"
MY_P="${P}"
if [ $(get_last_version_component_index) -eq 4 ]; then
	MY_DP="${PN}-$(get_version_component_range 4-)"
	MY_P="${PN}-${PV/.$(get_version_component_range 4)}"
fi
SRC_URI="http://www.opensmtpd.org/archives/${MY_DP/_}.tar.gz"

LICENSE="ISC BSD BSD-1 BSD-2 BSD-4"
SLOT="0"
KEYWORDS="amd64 x86"
IUSE="pam sqlite +mta"

DEPEND="dev-libs/openssl
		sys-libs/zlib
		pam? ( virtual/pam )
		sys-libs/db
		sqlite? ( dev-db/sqlite:3 )
		dev-libs/libevent
		!mail-mta/courier
		!mail-mta/esmtp
		!mail-mta/exim
		!mail-mta/mini-qmail
		!mail-mta/msmtp[mta]
		!mail-mta/netqmail
		!mail-mta/nullmailer
		!mail-mta/postfix
		!mail-mta/qmail-ldap
		!mail-mta/sendmail
		!mail-mta/ssmtp[mta]
"
RDEPEND="${DEPEND}"

S=${WORKDIR}/${MY_P/_}

src_prepare() {
	epatch "${FILESDIR}"/build-warnings.patch
	epatch_user
	eautoreconf
}

src_configure() {
	tc-export AR
	AR="$(which "$AR")" econf \
		--with-privsep-user=smtpd \
		--with-filter-user=smtpf \
		--with-queue-user=smtpq \
		--with-privsep-path=/var/empty \
		--with-sock-dir=/var/run \
		--sysconfdir=/etc/opensmtpd \
		$(use_with sqlite experimental-sqlite) \
		$(use_with pam)
		#--with-lookup-user=smtpl  will be available in the release after some point
}

src_install() {
	default
	newinitd "${FILESDIR}"/smtpd.initd smtpd
	use pam && newpamd "${FILESDIR}"/smtpd.pam smtpd
	if use mta ; then
		dodir /usr/sbin
		dosym /usr/sbin/smtpctl /usr/sbin/sendmail
		dosym /usr/sbin/smtpctl /usr/bin/sendmail
		dosym /usr/sbin/smtpctl /usr/$(get_libdir)/sendmail
	fi
}

pkg_preinst() {
	enewgroup smtpd 25
	enewuser smtpd 25 -1 /var/empty smtpd
	enewgroup smtpf 251
	enewuser smtpf 251 -1 /var/empty smtpf
	enewgroup smtpq 252
	enewuser smtpq 252 -1 /var/empty smtpq

	# For release after some point:
	#enewgroup smtpl 253
	#enewuser smtpl 253 -1 /var/empty smtpl
}
