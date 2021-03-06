# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-python/cffi/cffi-0.5-r1.ebuild,v 1.2 2013/05/08 16:02:21 idella4 Exp $

EAPI="5"
PYTHON_COMPAT=( python{2_6,2_7} pypy1_9 )

inherit distutils-r1

DESCRIPTION="Foreign Function Interface for Python calling C code."
HOMEPAGE="http://cffi.readthedocs.org/"
SRC_URI="mirror://pypi/${PN:0:1}/${PN}/${P}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="doc test"

RDEPEND="virtual/libffi
	dev-python/pycparser[${PYTHON_USEDEP}]
	dev-python/pytest[${PYTHON_USEDEP}]
	dev-python/hgdistver"
DEPEND="$REDEPEND
	test? ( dev-python/virtualenv )"

python_compile_all() {
	use doc && emake -C doc html
}

python_test() {
	py.test c/ testing/ -x -v
}

python_install_all() {
	use doc && dohtml -r doc/build/
}
