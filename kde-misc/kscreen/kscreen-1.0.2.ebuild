# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/kde-misc/kscreen/kscreen-1.0.2.ebuild,v 1.1 2013/11/21 13:13:13 mrueg Exp $

EAPI=5

VIRTUALX_REQUIRED="test"
DECLARATIVE_REQUIRED="always"
KDE_LINGUAS="bs ca cs da de el es et fi fr ga gl hu it lt mr nl pt pt_BR ro ru
sk sl sv tr ug uk zh_CN zh_TW"
inherit kde4-base

DESCRIPTION="Alternative KDE screen management"
HOMEPAGE="https://projects.kde.org/projects/kdereview/kscreen"
SRC_URI="mirror://kde/stable/${PN}/${PV}/src/${P}.tar.xz"

LICENSE="GPL-2 LGPL-2.1"
SLOT="4"
KEYWORDS="~amd64 ~x86"
IUSE="debug"

DEPEND="
	>=x11-libs/libkscreen-${PV}
	>=dev-libs/qjson-0.8
"
RDEPEND="${DEPEND}"

DISTPLAY_MESSAGE=false
pkg_preinst() {
	if ! has_version ${CATEGORY}/${PN} ; then
		DISPLAY_MESSAGE=true
	fi

	kde4-base_pkg_preinst
}

pkg_postinst() {
	if [[ "${DISPLAY_MESSAGE}" = true ]]; then
		echo
		elog "Disable the old screen management:"
		elog "# qdbus org.kde.kded /kded org.kde.kded.unloadModule randrmonitor"
		elog "# qdbus org.kde.kded /kded org.kde.kded.setModuleAutoloading randrmonitor false"
		elog
		elog "Enable the kded module for the kscreen based screen management:"
		elog "# qdbus org.kde.kded /kded org.kde.kded.loadModule kscreen"
		elog
		elog "Now simply (un-)plugging displays should enable/disable them, while"
		elog "the last state is remembered."
		echo
	fi

	unset DISPLAY_MESSAGE

	kde4-base_pkg_postinst
}
