# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/kde-base/kcalc/kcalc-4.11.0.ebuild,v 1.1 2013/08/14 20:23:37 dilfridge Exp $

EAPI=5

KDE_HANDBOOK="optional"
CPPUNIT_REQUIRED="optional"
inherit kde4-base

DESCRIPTION="KDE calculator"
HOMEPAGE="http://kde.org/applications/utilities/kcalc
http://utils.kde.org/projects/kcalc"
KEYWORDS="~amd64 ~arm ~ppc ~ppc64 ~x86 ~amd64-linux ~x86-linux"
IUSE="debug"

DEPEND="
	dev-libs/gmp
"
RDEPEND="${DEPEND}"

RESTRICT=test
# Testing result of: KNumber("nan") ^ KNumber("inf") should give nan and gives inf ...

src_test() {
	LANG=C kde4-base_src_test
}
