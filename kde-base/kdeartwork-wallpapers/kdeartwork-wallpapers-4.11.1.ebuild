# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/kde-base/kdeartwork-wallpapers/kdeartwork-wallpapers-4.11.1.ebuild,v 1.1 2013/09/03 19:04:41 creffett Exp $

EAPI=5

RESTRICT="binchecks strip"

KMMODULE="wallpapers"
KMNAME="kdeartwork"
KDE_SCM="svn"
inherit kde4-meta

DESCRIPTION="Wallpapers from kde"
KEYWORDS=" ~amd64 ~arm ~ppc ~ppc64 ~x86 ~amd64-linux ~x86-linux"
IUSE=""

KMEXTRA="
	HighResolutionWallpapers/
"

RDEPEND="!<kde-base/kde-wallpapers-4.9.50:4"
