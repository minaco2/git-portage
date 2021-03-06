# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-python/ecdsa/ecdsa-0.9.ebuild,v 1.2 2013/10/24 13:35:38 blueness Exp $

EAPI=5

# pypy has test failures with some BadSignatureErrors
PYTHON_COMPAT=( python{2_6,2_7,3_2,3_3} )

inherit distutils-r1 vcs-snapshot

DESCRIPTION="ECDSA cryptographic signature library in pure Python"
HOMEPAGE="http://github.com/warner/python-ecdsa"
SRC_URI="https://github.com/warner/python-${PN}/tarball/python-${P} -> ${P}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""
