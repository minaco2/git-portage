# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-emacs/csv-mode/csv-mode-1.50.ebuild,v 1.4 2008/12/01 19:16:59 tcunha Exp $

inherit elisp

DESCRIPTION="A major mode for editing comma-separated value files."
HOMEPAGE="http://centaur.maths.qmw.ac.uk/Emacs/"
SRC_URI="mirror://gentoo/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 ~ppc sparc x86"
IUSE=""

SITEFILE=50${PN}-gentoo.el
