# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/sys-apps/gentoo-systemd-integration/gentoo-systemd-integration-9999.ebuild,v 1.5 2013/09/22 08:36:24 mgorny Exp $

EAPI=5

#if LIVE
AUTOTOOLS_AUTORECONF=1
EGIT_REPO_URI="http://bitbucket.org/mgorny/${PN}.git"
inherit git-2
#endif

inherit autotools-utils systemd

DESCRIPTION="systemd integration files for Gentoo"
HOMEPAGE="https://bitbucket.org/mgorny/gentoo-systemd-integration"
SRC_URI="mirror://bitbucket/mgorny/${PN}/downloads/${P}.tar.bz2"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~amd64 ~arm ~ppc ~ppc64 ~x86"
IUSE=""

RDEPEND=">=sys-apps/systemd-207"

#if LIVE
SRC_URI=
KEYWORDS=

DEPEND="${DEPEND}
	sys-devel/systemd-m4"
#endif

src_configure() {
	local myeconfargs=(
		"$(systemd_with_unitdir)"
		# TODO: solve it better in the eclass
		--with-systemdsystemgeneratordir="$(systemd_get_utildir)"/system-generators
	)

	autotools-utils_src_configure
}
