# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/games-action/supertuxkart/supertuxkart-0.7.ebuild,v 1.7 2012/12/07 23:36:34 hasufell Exp $

EAPI=2
inherit autotools flag-o-matic eutils games

DESCRIPTION="A kart racing game starring Tux, the linux penguin (TuxKart fork)"
HOMEPAGE="http://supertuxkart.sourceforge.net/"
SRC_URI="mirror://sourceforge/supertuxkart/SuperTuxKart/${PV}/${P}-src.tar.bz2
	mirror://gentoo/${PN}.png"

LICENSE="GPL-3 CCPL-Attribution-ShareAlike-3.0 CCPL-Attribution-2.0 CCPL-Sampling-Plus-1.0 public-domain ZLIB"
SLOT="0"
KEYWORDS="amd64 ~ppc x86"
IUSE="debug nls unicode"

RDEPEND="<dev-games/irrlicht-1.8
	virtual/opengl
	media-libs/freeglut
	virtual/glu
	net-libs/enet:0
	media-libs/libvorbis
	media-libs/openal
	nls? ( dev-libs/fribidi )
	virtual/libintl"
DEPEND="${RDEPEND}
	nls? ( sys-devel/gettext )
	unicode? ( dev-libs/fribidi )"

src_prepare() {
	epatch "${FILESDIR}"/${P}-build.patch \
		"${FILESDIR}"/${P}-underlink.patch
	rm -rf src/enet
	eautoreconf
}

src_configure() {
	append-libs -lpng -ljpeg -lbz2

	egamesconf \
		--disable-dependency-tracking \
		--disable-optimization \
		$(use_enable nls) \
		$(use_enable debug)
}

src_install() {
	emake DESTDIR="${D}" install || die
	doicon "${DISTDIR}"/${PN}.png
	make_desktop_entry ${PN} SuperTuxKart
	dodoc AUTHORS ChangeLog README TODO
	prepgamesdirs
}
