# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-python/pyro/pyro-4.20.ebuild,v 1.4 2013/10/06 19:17:10 aidecoe Exp $

EAPI=5

PYTHON_COMPAT=( python{2_6,2_7,3_2,3_3} pypy2_0 )

inherit distutils-r1

MY_PN="Pyro4"
MY_P="${MY_PN}-${PV}"

DESCRIPTION="Advanced and powerful Distributed Object Technology system written entirely in Python"
HOMEPAGE="http://www.xs4all.nl/~irmen/pyro/ http://pypi.python.org/pypi/Pyro4"
SRC_URI="mirror://pypi/${MY_PN:0:1}/${MY_PN}/${MY_P}.tar.gz"

LICENSE="MIT"
SLOT="4"
KEYWORDS="~amd64 ~ppc ~x86 ~amd64-linux ~x86-linux"
IUSE="doc examples test"

RDEPEND="!dev-python/pyro:0
	dev-python/serpent[${PYTHON_USEDEP}]"
DEPEND="${RDEPEND}
	dev-python/setuptools[${PYTHON_USEDEP}]
	test? (
		dev-python/coverage[${PYTHON_USEDEP}]
		dev-python/nose[${PYTHON_USEDEP}]
		virtual/python-unittest2[${PYTHON_USEDEP}]
	)"

S="${WORKDIR}/${MY_P}"
DISTUTILS_IN_SOURCE_BUILD=1

python_prepare_all() {
	epatch "${FILESDIR}/${PV}-0001-Use-unittest2-for-older-Python-version.patch"

	sed \
		-e '/sys.path.insert/a sys.path.insert(1,"PyroTests")' \
		-i tests/run_suite.py || die

	# Disable tests requiring network connection.
	sed \
		-e "s/testBCstart/_&/" \
		-e "s/testDaemonPyroObj/_&/" \
		-e "s/testLookupAndRegister/_&/" \
		-e "s/testMulti/_&/" \
		-e "s/testRefuseDottedNames/_&/" \
		-e "s/testResolve/_&/" \
		-e "s/testBCLookup/_&/" \
		-i tests/PyroTests/test_naming.py || die
	sed \
		-e "s/testOwnloopBasics/_&/" \
		-e "s/testStartNSfunc/_&/" \
		-i tests/PyroTests/test_naming2.py || die

	sed \
		-e "s/testServerConnections/_&/" \
	    -e "s/testServerParallelism/_&/" \
		-i tests/PyroTests/test_server.py || die

	sed \
		-e "s/testBroadcast/_&/" \
		-e "s/testGetIP/_&/" \
		-e "s/testGetIpVersion/_&/" \
		-i tests/PyroTests/test_socket.py || die
	distutils-r1_python_prepare_all
}

python_test() {
	cd "${S}"/tests || die
	${PYTHON} run_suite.py || die
}

python_install_all() {
	use doc && HTML_DOCS=( docs/. )
	use examples && local EXAMPLES=( examples/. )
	distutils-r1_python_install_all
}
