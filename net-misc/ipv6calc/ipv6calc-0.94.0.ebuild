# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/net-misc/ipv6calc/ipv6calc-0.94.0.ebuild,v 1.1 2013/05/10 08:33:58 pva Exp $

EAPI="4"
inherit fixheadtails

DESCRIPTION="IPv6 address calculator"
HOMEPAGE="http://www.deepspace6.net/projects/ipv6calc.html"
SRC_URI="ftp://ftp.bieringer.de/pub/linux/IPv6/ipv6calc/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~hppa ~ppc ~sparc ~x86"
IUSE="geoip"

DEPEND="
	dev-perl/URI
	geoip? ( >=dev-libs/geoip-1.4.7 )
"

src_prepare() {
	# Disable broken test for now
	sed '/fe80--218-8bff-fe17-a226s4.ipv6-literal.net/d' \
		-i	ipv6calc/test_ipv6calc.sh || die
	sed -e '/^2001-db8-0-0-0-0-0-1.ipv6-literal.net/d' \
		-e '/^2001-db8--1.ipv6-literal.net/d' \
		-i ipv6calc/test_scenarios.sh || die
	ht_fix_file configure
}

src_configure() {
	if use geoip; then
		myconf=$(use_enable geoip)
		myconf+=" --with-geoip-ipv4-default-file=/usr/share/GeoIP/GeoIP.dat"
		myconf+=" --with-geoip-ipv6-default-file=/usr/share/GeoIP/GeoIPv6.dat"
	fi
	econf ${myconf}
}

src_compile() {
	# Disable default CFLAGS (-O2 and -g)
	emake DEFAULT_CFLAGS=""
}

src_test() {
	if [[ ${EUID} -eq 0 ]]; then
		# Disable tests that fail as root
		echo true > ipv6logstats/test_ipv6logstats.sh
	fi
	default
}

src_install() {
	emake DESTDIR="${D}" install
	dodoc ChangeLog CREDITS README TODO USAGE
}
