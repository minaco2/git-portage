# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/media-sound/a2jmidid/a2jmidid-6.ebuild,v 1.3 2013/05/20 16:17:35 aballier Exp $

EAPI="4"
PYTHON_DEPEND="2"
NO_WAF_LIBDIR=1

inherit python toolchain-funcs waf-utils

DESCRIPTION="Daemon for exposing legacy ALSA sequencer applications in JACK MIDI system."
HOMEPAGE="http://home.gna.org/a2jmidid/"
SRC_URI="http://download.gna.org/a2jmidid/${P}.tar.bz2"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

RDEPEND="media-libs/alsa-lib
	media-sound/jack-audio-connection-kit
	sys-apps/dbus"
DEPEND="${RDEPEND}
	virtual/pkgconfig"

DOCS=(AUTHORS README NEWS internals.txt)

pkg_setup() {
	python_set_active_version 2
	python_pkg_setup
}

src_install() {
	waf-utils_src_install
	python_convert_shebangs -r 2 "${ED}"
}
