# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/kde-base/kmag/kmag-4.10.2.ebuild,v 1.5 2013/05/05 10:13:49 ago Exp $

EAPI=5

KDE_HANDBOOK="optional"
inherit kde4-base

DESCRIPTION="KDE screen magnifier"
KEYWORDS="amd64 ~arm ppc ppc64 x86 ~amd64-linux ~x86-linux"
IUSE="debug"

RDEPEND="
	$(add_kdebase_dep kaccessible)
"
