# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/razorqt-base/razorqt-openssh-askpass/razorqt-openssh-askpass-0.5.0.ebuild,v 1.1 2012/10/15 09:54:40 yngwin Exp $

EAPI=4
inherit cmake-utils

DESCRIPTION="Razor-qt OpenSSH ask password interface"
HOMEPAGE="http://razor-qt.org/"

if [[ ${PV} = *9999* ]]; then
	inherit git-2
	EGIT_REPO_URI="git://github.com/Razor-qt/razor-qt.git"
	EGIT_BRANCH="master"
	KEYWORDS=""
else
	SRC_URI="https://github.com/downloads/Razor-qt/razor-qt/razorqt-${PV}.tar.bz2"
	KEYWORDS="~amd64 ~x86"
	S="${WORKDIR}/razorqt-${PV}"
fi

LICENSE="LGPL-2.1+"
SLOT="0"
IUSE=""

DEPEND="razorqt-base/razorqt-libs"
RDEPEND="${DEPEND}
	razorqt-base/razorqt-data"

DOCS=( "${PN}/README" )

src_configure() {
	local mycmakeargs=(
		-DSPLIT_BUILD=On
		-DMODULE_ASKPASS=On
	)
	cmake-utils_src_configure
}
