# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-emacs/evil/evil-1.0.8.ebuild,v 1.1 2013/11/28 19:35:03 ulm Exp $

EAPI=5

inherit elisp

DESCRIPTION="Extensible vi layer for Emacs"
HOMEPAGE="http://gitorious.org/evil"
SRC_URI="http://dev.gentoo.org/~ulm/distfiles/${P}.tar.xz"

LICENSE="GPL-3+ FDL-1.3+"
SLOT="0"
KEYWORDS="~amd64 ~x86"

DEPEND=">=app-emacs/undo-tree-0.6.3"
RDEPEND="${DEPEND}"

S="${WORKDIR}/${PN}"
ELISP_REMOVE="evil-pkg.el evil-tests.el"
ELISP_TEXINFO="doc/evil.texi"
SITEFILE="50${PN}-gentoo.el"
DOCS="CHANGES.org"
