# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/net-libs/libzrtpcpp/libzrtpcpp-2.3.2.ebuild,v 1.1 2013/02/13 11:09:23 chithanh Exp $

EAPI=5

inherit cmake-utils

DESCRIPTION="GNU RTP stack for the zrtp protocol developed by Phil Zimmermann"
HOMEPAGE="http://www.gnutelephony.org/index.php/GNU_ZRTP"
SRC_URI="mirror://gnu/ccrtp/${P}.tar.gz"
KEYWORDS="~amd64 ~ppc ~ppc64 ~x86"
LICENSE="GPL-3"
IUSE=""
SLOT="0"

RDEPEND=">=net-libs/ccrtp-2
	>=dev-cpp/commoncpp2-1.5.1
	|| ( dev-libs/libgcrypt
		>=dev-libs/openssl-0.9.8 )"
DEPEND="${RDEPEND}
	virtual/pkgconfig"

DOCS=( AUTHORS README.md )
