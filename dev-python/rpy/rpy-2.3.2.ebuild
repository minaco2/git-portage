# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-python/rpy/rpy-2.3.2.ebuild,v 1.2 2013/03/07 07:26:55 jlec Exp $

EAPI=5

PYTHON_COMPAT=( python2_7 )

inherit distutils-r1

MYSLOT=2
MY_PN=${PN}${MYSLOT}
MY_P=${MY_PN}-${PV}

DESCRIPTION="Python interface to the R Programming Language"
HOMEPAGE="http://rpy.sourceforge.net/"
SRC_URI="mirror://pypi/${MY_PN:0:1}/${MY_PN}/${MY_P}.tar.gz"

LICENSE="GPL-2 LGPL-2.1 MPL-1.1"
SLOT="0"
KEYWORDS="~amd64 ~x86 ~amd64-linux ~x86-linux"
IUSE=""

RDEPEND="
	>=dev-lang/R-2.8
	dev-python/numpy[${PYTHON_USEDEP}]
	!<=dev-python/rpy-1.0.2-r2"
DEPEND="${RDEPEND}"

S="${WORKDIR}/${MY_P}"

python_test() {
	${PYTHON} -m 'rpy2.tests' -v || die
}
