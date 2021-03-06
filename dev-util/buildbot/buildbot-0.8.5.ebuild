# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-util/buildbot/buildbot-0.8.5.ebuild,v 1.6 2012/09/24 03:46:37 blueness Exp $

EAPI="3"
PYTHON_DEPEND="2"
SUPPORT_PYTHON_ABIS="1"
RESTRICT_PYTHON_ABIS="3.* *-jython"
DISTUTILS_SRC_TEST="trial"
DISTUTILS_DISABLE_TEST_DEPENDENCY="1"

inherit distutils user

MY_PV="${PV/_p/p}"
MY_P="${PN}-${MY_PV}"

DESCRIPTION="BuildBot build automation system"
HOMEPAGE="http://trac.buildbot.net/ http://code.google.com/p/buildbot/ http://pypi.python.org/pypi/buildbot"
SRC_URI="mirror://pypi/${PN:0:1}/${PN}/${MY_P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~arm ~hppa ~ppc ~ppc64 ~x86"
IUSE="doc examples irc mail manhole test"

# sqlite3 module of Python 2.5 is not supported.
RDEPEND=">=dev-python/jinja-2.1
	|| ( dev-lang/python:2.7 dev-lang/python:2.6 dev-python/simplejson )
	|| ( dev-lang/python:2.7[sqlite] dev-lang/python:2.6[sqlite] dev-python/pysqlite:2 )
	>=dev-python/twisted-8.0.0
	dev-python/twisted-web
	dev-python/sqlalchemy
	dev-python/sqlalchemy-migrate
	irc? ( dev-python/twisted-words )
	mail? ( dev-python/twisted-mail )
	manhole? ( dev-python/twisted-conch )"
DEPEND="${DEPEND}
	dev-python/setuptools
	doc? ( sys-apps/texinfo )
	test? (
		dev-python/mock
		dev-python/twisted-mail
		dev-python/twisted-web
		dev-python/twisted-words
	)"

S="${WORKDIR}/${MY_P}"

pkg_setup() {
	python_pkg_setup
	enewuser buildbot
}

src_prepare() {
	distutils_src_prepare
	# https://github.com/buildbot/buildbot/commit/a3abed70546b3742964994517bb27556e06f6e20
	sed -e "s/sqlalchemy-migrate == 0.6/sqlalchemy-migrate ==0.6, ==0.7/" -i setup.py || die "sed failed"
}

src_compile() {
	distutils_src_compile

	if use doc; then
		einfo "Generation of documentation"
		pushd docs > /dev/null
		emake buildbot.html buildbot.info
		popd > /dev/null
	fi
}

src_install() {
	distutils_src_install

	doman docs/buildbot.1

	if use doc; then
		dohtml -r docs/buildbot.html docs/images
		doinfo docs/buildbot.info
	fi

	if use examples; then
		insinto /usr/share/doc/${PF}
		doins -r contrib docs/examples
	fi

	newconfd "${FILESDIR}/buildmaster.confd" buildmaster
	newinitd "${FILESDIR}/buildmaster.initd" buildmaster
}

pkg_postinst() {
	distutils_pkg_postinst

	elog "The \"buildbot\" user and the \"buildmaster\" init script has been added"
	elog "to support starting buildbot through Gentoo's init system. To use this,"
	elog "set up your build master following the documentation, make sure the"
	elog "resulting directories are owned by the \"buildbot\" user and point"
	elog "\"${ROOT}etc/conf.d/buildmaster\" at the right location. The scripts can"
	elog "run as a different user if desired. If you need to run more than one"
	elog "build master, just copy the scripts."
	elog
	elog "Upstream recommends the following when upgrading:"
	elog "Each time you install a new version of Buildbot, you should run the"
	elog "\"buildbot upgrade-master\" command on each of your pre-existing build masters."
	elog "This will add files and fix (or at least detect) incompatibilities between"
	elog "your old config and the new code."
}
