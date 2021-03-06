# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/net-analyzer/ostinato/ostinato-0.5.ebuild,v 1.4 2013/03/02 22:46:36 hwoarang Exp $

EAPI=2
inherit qt4-r2

DESCRIPTION="A packet generator and analyzer"
HOMEPAGE="http://code.google.com/p/ostinato/"
SRC_URI="http://ostinato.googlecode.com/files/${PN}-src-${PV}.tar.gz"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="amd64 x86"
IUSE=""

DEPEND="dev-libs/protobuf
	net-libs/libpcap
	dev-qt/qtcore:4
	dev-qt/qtgui:4
	dev-qt/qtscript:4"
RDEPEND="${DEPEND}"

src_configure(){
	eqmake4 PREFIX=/usr ost.pro
}
