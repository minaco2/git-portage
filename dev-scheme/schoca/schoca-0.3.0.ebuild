# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-scheme/schoca/schoca-0.3.0.ebuild,v 1.4 2010/10/06 02:28:00 chiiph Exp $

EAPI="3"

inherit eutils

DESCRIPTION="Schoca is a Scheme implementation in OCaml."
HOMEPAGE="http://sourceforge.net/projects/chesslib/"
SRC_URI="mirror://sourceforge/chesslib/${P}.tar.bz2"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="+ocamlopt"

DEPEND="dev-ml/findlib
	dev-lang/ocaml[ocamlopt?]"
RDEPEND="${DEPEND}"

RESTRICT="installsources"

src_configure() {
	sed "s:\$(CFLAGS):\$(CCFLAGS):g" -i OCaml.mk || die "sed failed"
	sed "s:CCFLAGS= -ccopt -O2:CCFLAGS= -ccopt \"${CFLAGS}\":" -i OCaml.mk || die "sed failed"
	sed -i -e "s:\$(LDFLAGS):-cclib \"${LDFLAGS}\":" OCaml.mk || die "sed failed"
	sed -i -e "s:DESTDURFLAG:DESTDIRFLAG:" OCaml.mk || die "sed failed"
	if ! use ocamlopt; then
		sed -i -e 's/ \$(PROGRAM)\.opt/ \$(PROGRAM)/' OCaml.mk || die "sed failed"
		sed -i -e 's/ \$(LIBRARY)\.cmxa//' OCaml.mk || die "sed failed"
		sed -i -e 's/ \$(LIBRARY)\.a//' OCaml.mk || die "sed failed"
		sed -i -e 's/) \$(NCOBJECTS)/)/' OCaml.mk || die "sed failed"
	fi
}

src_compile() {
	#parallel fails
	emake -j1 || die "emake failed"
}

src_install() {
	use ocamlopt || export STRIP_MASK="*bin/schoca"
	dodir "$(ocamlfind printconf destdir)" || die "dodir failed"
	emake PREFIX="/usr" DESTDIR="${D}" DESTDIRFLAG="-destdir ${D}$(ocamlfind printconf destdir)" install || die "emake install failed"
}
