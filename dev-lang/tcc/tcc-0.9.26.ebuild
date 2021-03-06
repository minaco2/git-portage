# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-lang/tcc/tcc-0.9.26.ebuild,v 1.2 2013/07/18 03:44:24 patrick Exp $

EAPI="5"

inherit eutils toolchain-funcs

DESCRIPTION="A very small C compiler for ix86/amd64"
HOMEPAGE="http://bellard.org/tcc/"
SRC_URI="http://download.savannah.gnu.org/releases/tinycc/${P}.tar.bz2"

LICENSE="LGPL-2.1"
SLOT="0"
KEYWORDS="~amd64 ~x86"

DEPEND="dev-lang/perl" # doc generation
# Both tendra and tinycc install /usr/bin/tcc
RDEPEND="!dev-lang/tendra"

src_prepare() {
	# Don't strip
	sed -i -e 's|$(INSTALL) -s|$(INSTALL)|' Makefile || die

	# Fix examples
	sed -i -e '1{
		i#! /usr/bin/tcc -run
		/^#!/d
	}' examples/ex*.c || die
	sed -i -e '1s/$/ -lX11/' examples/ex4.c || die

	# fix texi2html invocation
	sed -i -e 's/-number//' Makefile || die
}

src_configure() {
	local myopts
	use x86 && myopts="--cpu=x86"
	use amd64 && myopts="--cpu=x86-64"
	econf ${myopts} --cc="$(tc-getCC)"
}

src_compile() {
	emake AR="$(tc-getAR)"
}

src_install() {
	emake \
		DESTDIR="${D}" \
		bindir="${D}"/usr/bin \
		libdir="${D}"/usr/lib \
		tccdir="${D}"/usr/lib/tcc \
		includedir="${D}"/usr/include \
		docdir="${D}"/usr/share/doc/${PF} \
		mandir="${D}"/usr/share/man install

	dodoc Changelog README TODO VERSION
	dohtml tcc-doc.html
	exeinto /usr/share/doc/${PF}/examples
	doexe examples/ex*.c
}
