# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/kde-base/lokalize/lokalize-4.11.0.ebuild,v 1.1 2013/08/14 20:23:27 dilfridge Exp $

EAPI=5

KDE_HANDBOOK="optional"
PYTHON_COMPAT=( python{2_6,2_7} )
inherit python-single-r1 kde4-base

DESCRIPTION="KDE4 translation tool"
HOMEPAGE="http://kde.org/applications/development/lokalize
http://l10n.kde.org/tools"
KEYWORDS="~amd64 ~arm ~ppc ~ppc64 ~x86 ~amd64-linux ~x86-linux"
IUSE="debug"

REQUIRED_USE="${PYTHON_REQUIRED_USE}"

DEPEND="
	${PYTHON_DEPS}
	>=app-text/hunspell-1.2.8
	>=dev-libs/soprano-2.9.0
	>=dev-qt/qtsql-4.5.0:4[sqlite]
"
RDEPEND="${DEPEND}
	$(add_kdebase_dep krosspython "${PYTHON_USEDEP}")
	$(add_kdebase_dep pykde4 "${PYTHON_USEDEP}")
"

pkg_setup() {
	python-single-r1_pkg_setup
	kde4-base_pkg_setup
}

src_install() {
	kde4-base_src_install
	python_fix_shebang "${ED}/usr/share/apps/${PN}"
}

pkg_postinst() {
	kde4-base_pkg_postinst

	if ! has_version dev-vcs/subversion ; then
		elog "To be able to autofetch KDE translations in new project wizard, install dev-vcs/subversion."
	fi
}
