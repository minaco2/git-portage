# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/kde-base/nepomuk-core/nepomuk-core-4.9.5.ebuild,v 1.5 2013/02/06 23:22:54 naota Exp $

EAPI=4

inherit kde4-base

DESCRIPTION="Nepomuk core libraries"
KEYWORDS="amd64 ~arm ppc x86 ~amd64-fbsd ~x86-fbsd ~amd64-linux ~x86-linux"
IUSE="debug"

DEPEND="
	>=app-misc/strigi-0.7.7[dbus,qt4]
	>=dev-libs/soprano-2.8.0[dbus,raptor,redland,virtuoso]
"
RDEPEND="${DEPEND}"

add_blocker nepomuk '<4.8.80'

RESTRICT="test"
# bug 392989
