# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/sci-libs/votca-tools/votca-tools-1.2.3-r1.ebuild,v 1.1 2013/01/27 04:03:19 ottxor Exp $

EAPI="3"

inherit cmake-utils eutils multilib

if [ "${PV}" != "9999" ]; then
	SRC_URI="system-boost? ( http://votca.googlecode.com/files/${P}_pristine.tar.gz )
		!system-boost? ( http://votca.googlecode.com/files/${P}.tar.gz )"
	RESTRICT="primaryuri"
else
	SRC_URI=""
	inherit mercurial
	EHG_REPO_URI="https://tools.votca.googlecode.com/hg"
fi

DESCRIPTION="Votca tools library"
HOMEPAGE="http://www.votca.org"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="~amd64 ~x86 ~amd64-linux ~x86-macos"
IUSE="doc +fftw +gsl sqlite +system-boost"

RDEPEND="fftw? ( sci-libs/fftw:3.0 )
	dev-libs/expat
	gsl? ( sci-libs/gsl )
	system-boost? ( dev-libs/boost )
	sqlite? ( dev-db/sqlite:3 )"

DEPEND="${RDEPEND}
	doc? ( || ( <app-doc/doxygen-1.7.6.1[-nodot] >=app-doc/doxygen-1.7.6.1[dot] ) )
	>=app-text/txt2tags-2.5
	virtual/pkgconfig"

DOCS=( NOTICE )

PATCHES=( "${FILESDIR}/${P}-boost-1.53.patch" )

src_prepare() {
	use gsl || ewarn "Disabling gsl will lead to reduced functionality"
	use fftw || ewarn "Disabling fftw will lead to reduced functionality"

	#remove bundled libs
	if use system-boost; then
		rm -rf src/libboost
	fi
}

src_configure() {
	mycmakeargs=(
		$(cmake-utils_use system-boost EXTERNAL_BOOST)
		$(cmake-utils_use_with gsl GSL)
		$(cmake-utils_use_with fftw FFTW)
		$(cmake-utils_use_with sqlite SQLITE3)
		-DWITH_RC_FILES=OFF
		-DLIB=$(get_libdir)
	)
	cmake-utils_src_configure || die
}

src_install() {
	cmake-utils_src_install || die
	if use doc; then
		cd "${CMAKE_BUILD_DIR}" || die
		cd share/doc || die
		doxygen || die
		dohtml -r html/* || die
	fi
}
