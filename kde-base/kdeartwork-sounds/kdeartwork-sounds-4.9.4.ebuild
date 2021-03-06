# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/kde-base/kdeartwork-sounds/kdeartwork-sounds-4.9.4.ebuild,v 1.2 2012/12/23 12:11:51 maekke Exp $

EAPI=4

RESTRICT="binchecks strip"

KMMODULE="sounds"
KMNAME="kdeartwork"
KDE_SCM="svn"
inherit kde4-meta

DESCRIPTION="Extra sound themes for kde"
KEYWORDS="~amd64 ~arm ~ppc ~x86 ~amd64-linux ~x86-linux"
IUSE=""
