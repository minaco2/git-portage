# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-haskell/gio/gio-0.12.4.ebuild,v 1.6 2013/01/06 09:18:30 ago Exp $

EAPI=5

# ebuild generated by hackport 0.3.9999

#nocabaldep is for the fancy cabal-detection feature at build-time
CABAL_FEATURES="lib profile haddock hoogle hscolour nocabaldep"
inherit haskell-cabal

DESCRIPTION="Binding to the GIO."
HOMEPAGE="http://projects.haskell.org/gtk2hs/"
SRC_URI="mirror://hackage/packages/archive/${PN}/${PV}/${P}.tar.gz"

LICENSE="LGPL-2.1"
SLOT="0/${PV}"
KEYWORDS="~alpha ~amd64 ~ia64 ~ppc ~ppc64 ~sparc ~x86"
IUSE=""

RDEPEND=">=dev-haskell/glib-0.12.0:=[profile?]
		<dev-haskell/glib-0.13:=[profile?]
		dev-haskell/mtl:=[profile?]
		>=dev-lang/ghc-6.10.4:=
		dev-libs/glib:2"
DEPEND="${RDEPEND}
		>=dev-haskell/cabal-1.8
		>=dev-haskell/gtk2hs-buildtools-0.12.4"
