# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/media-sound/beets/beets-1.1.0.ebuild,v 1.2 2013/08/11 21:48:08 aballier Exp $

EAPI="5"

PYTHON_COMPAT=( python2_7 )
PYTHON_REQ_USE="sqlite"

inherit distutils-r1 eutils

MY_PV=${PV/_beta/-beta.}
MY_P=${PN}-${MY_PV}

DESCRIPTION="A media library management system for obsessive-compulsive music geeks"
SRC_URI="http://beets.googlecode.com/files/${MY_P}.tar.gz"
HOMEPAGE="http://beets.radbox.org/"

KEYWORDS="~amd64 ~x86"
SLOT="0"
LICENSE="MIT"
IUSE="bpd chroma convert doc echonest_tempo lastgenre replaygain test web"

RDEPEND="
	dev-python/munkres[${PYTHON_USEDEP}]
	>=dev-python/python-musicbrainz-ngs-0.3[${PYTHON_USEDEP}]
	dev-python/unidecode[${PYTHON_USEDEP}]
	>=media-libs/mutagen-0.21[${PYTHON_USEDEP}]
	dev-python/pyyaml[${PYTHON_USEDEP}]
	bpd? ( dev-python/bluelet[${PYTHON_USEDEP}] )
	chroma? ( dev-python/pyacoustid[${PYTHON_USEDEP}] )
	convert? ( media-video/ffmpeg:0[encode] )
	doc? ( dev-python/sphinx )
	echonest_tempo? ( dev-python/pyechonest[${PYTHON_USEDEP}] )
	lastgenre? ( dev-python/pylast[${PYTHON_USEDEP}] )
	replaygain? ( || ( media-sound/mp3gain media-sound/aacgain ) )
	web? ( dev-python/flask[${PYTHON_USEDEP}] )
"

DEPEND="${RDEPEND}
	dev-python/setuptools[${PYTHON_USEDEP}]"

S=${WORKDIR}/${MY_P}

src_prepare() {
	# remove plugins that do not have appropriate dependencies installed
	for flag in bpd chroma convert echonest_tempo lastgenre replaygain web;do
		if ! use $flag ; then
			rm -r beetsplug/$flag* || \
				die "Unable to remove $flag plugin"
		fi
	done

	for flag in bpd lastgenre web;do
		if ! use $flag ; then
			sed -i "s:'beetsplug.$flag',::" setup.py || \
				die "Unable to disable $flag plugin "
		fi
	done

	use bpd || rm -f test/test_player.py

}

python_compile_all() {
	use doc && emake -C docs html
}

python_test() {
	cd test
	"${PYTHON}" testall.py || die "Testsuite failed"
}

python_install_all() {
	doman man/beet.1 man/beetsconfig.5

	use doc && dohtml -r docs/_build/html/
}
