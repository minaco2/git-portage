# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/mail-filter/opendmarc/opendmarc-1.1.3.ebuild,v 1.3 2013/10/30 00:58:41 jer Exp $

EAPI=5

DESCRIPTION="Open source DMARC implementation "
HOMEPAGE="http://www.trusteddomain.org/opendmarc/"
SRC_URI="mirror://sourceforge/opendmarc/${P}.tar.gz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~amd64 ~hppa"
IUSE=""

DEPEND="dev-perl/DBI
	mail-filter/libmilter"
RDEPEND="${DEPEND}
	virtual/perl-Switch"

src_configure() {
	econf \
		--docdir="${EPREFIX}"/usr/share/doc/${PF} \
		--htmldir="${EPREFIX}"/usr/share/doc/${PF}/html
}
