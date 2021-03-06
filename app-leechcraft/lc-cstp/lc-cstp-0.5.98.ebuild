# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-leechcraft/lc-cstp/lc-cstp-0.5.98.ebuild,v 1.1 2013/07/03 15:57:13 maksbotan Exp $

EAPI="4"

inherit leechcraft

DESCRIPTION="CSTP, the clean & stupid HTTP implementation for LeechCraft."

SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="debug"

DEPEND="~app-leechcraft/lc-core-${PV}"
RDEPEND="${DEPEND}
		virtual/leechcraft-task-show"
