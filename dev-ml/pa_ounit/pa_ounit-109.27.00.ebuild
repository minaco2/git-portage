# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-ml/pa_ounit/pa_ounit-109.27.00.ebuild,v 1.1 2013/06/10 12:32:46 aballier Exp $

EAPI="5"

inherit oasis

DESCRIPTION="Syntax extension that helps writing in-line test in ocaml"
HOMEPAGE="http://bitbucket.org/yminsky/ocaml-core/wiki/Home"
SRC_URI="http://ocaml.janestreet.com/ocaml-core/${PV}/individual/${P}.tar.gz
	http://dev.gentoo.org/~aballier/distfiles/${P}.tar.gz"

LICENSE="Apache-2.0"
SLOT="0/${PV}"
KEYWORDS="~amd64"
IUSE=""

DEPEND=">=dev-ml/ounit-1.1.1:="
RDEPEND="${DEPEND}"

DOCS=( "readme.md" )
