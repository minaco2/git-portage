# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/kde-base/kanagram/kanagram-4.9.5.ebuild,v 1.5 2013/02/23 16:04:03 ago Exp $

EAPI=4

KDE_HANDBOOK="optional"
inherit kde4-base

DESCRIPTION="KDE: letter order game."
KEYWORDS="amd64 ~arm ppc ~ppc64 x86 ~amd64-linux ~x86-linux"
IUSE="debug"

DEPEND="
	$(add_kdebase_dep libkdeedu)
"
RDEPEND=${DEPEND}
