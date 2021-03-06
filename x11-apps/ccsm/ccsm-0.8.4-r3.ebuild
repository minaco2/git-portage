# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/x11-apps/ccsm/ccsm-0.8.4-r3.ebuild,v 1.1 2013/05/07 15:13:32 pinkbyte Exp $

EAPI="5"

PYTHON_COMPAT=( python2_{6,7} )
DISTUTILS_IN_SOURCE_BUILD=1
inherit distutils-r1

DESCRIPTION="Compizconfig Settings Manager"
HOMEPAGE="http://www.compiz.org/"
SRC_URI="http://releases.compiz.org/${PV}/${P}.tar.bz2"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~ppc ~ppc64 ~x86"

RDEPEND="
	>=dev-python/compizconfig-python-${PV}[${PYTHON_USEDEP}]
	>=dev-python/pygtk-2.12:2[${PYTHON_USEDEP}]
	gnome-base/librsvg
"

DOCS=( AUTHORS )

python_prepare_all() {
	# return error if wrong arguments passed to setup.py
	sed -i -e 's/raise SystemExit/\0(1)/' setup.py || die 'sed on setup.py failed'
	# fix desktop file
	sed -i \
		-e '/Categories/s/Compiz/X-\0/' \
		-e '/Encoding/d' \
		ccsm.desktop.in || die 'sed on ccsm.desktop.in failed'

	distutils-r1_python_prepare_all
}
