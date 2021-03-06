# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/kde-base/smokegen/smokegen-4.10.0.ebuild,v 1.1 2013/02/07 04:56:59 alexxy Exp $

EAPI=5

KDE_REQUIRED="never"
inherit kde4-base

DESCRIPTION="Scripting Meta Object Kompiler Engine - generators"
KEYWORDS="~amd64 ~arm ~ppc ~x86 ~amd64-linux ~x86-linux"
IUSE="aqua debug"

DEPEND="
	x11-libs/qt-core:4[aqua=]
"
RDEPEND="${DEPEND}"

add_blocker smoke
