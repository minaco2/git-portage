# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/games-arcade/penguin-command/penguin-command-1.6.11.ebuild,v 1.4 2012/09/05 06:37:57 mr_bones_ Exp $

EAPI=2
inherit eutils games

DESCRIPTION="A clone of the classic Missile Command game"
HOMEPAGE="http://www.linux-games.com/penguin-command/"
SRC_URI="mirror://sourceforge/${PN}/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 ppc sparc x86"
IUSE=""

DEPEND="media-libs/libsdl[audio,joystick,video]
	media-libs/sdl-mixer[mod]
	media-libs/sdl-image[jpeg,png]"

src_install() {
	emake DESTDIR="${D}" install || die
	dodoc AUTHORS ChangeLog NEWS README
	newicon data/gfx/icon.xpm ${PN}.xpm
	make_desktop_entry ${PN} "Penguin Command" ${PN}
	prepgamesdirs
}
