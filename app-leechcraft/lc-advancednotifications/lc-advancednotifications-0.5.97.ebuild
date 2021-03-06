# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-leechcraft/lc-advancednotifications/lc-advancednotifications-0.5.97.ebuild,v 1.1 2013/06/11 17:11:25 maksbotan Exp $

EAPI="4"

inherit leechcraft

DESCRIPTION="Flexible and customizable notifications framework for LeechCraft."

SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="debug"

DEPEND="~app-leechcraft/lc-core-${PV}
	dev-qt/qtdeclarative:4"
RDEPEND="${DEPEND}"

pkg_postinst() {
	einfo "Advanced Notifications supports playing sounds on various"
	einfo "events. Install some media playback plugin to enjoy this"
	einfo "feature (app-leechcraft/lc-lmp will do, for example)."
}
