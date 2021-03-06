# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-python/netaddr/netaddr-0.7.10-r1.ebuild,v 1.2 2013/07/30 05:28:16 idella4 Exp $

EAPI=5
PYTHON_COMPAT=( python{2_6,2_7} )

inherit distutils-r1

DESCRIPTION="Network address representation and manipulation library"
HOMEPAGE="https://github.com/drkjam/netaddr http://pypi.python.org/pypi/netaddr"
SRC_URI="mirror://github/drkjam/${PN}/${P}.tar.gz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="cli"

DEPEND=""
RDEPEND="cli? ( >=dev-python/ipython-0.13.1-r1[${PYTHON_USEDEP}] )"

python_test() {
	"${PYTHON}" netaddr/tests/__init__.py
}
