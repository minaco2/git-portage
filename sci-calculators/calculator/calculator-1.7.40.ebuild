# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/sci-calculators/calculator/calculator-1.7.40.ebuild,v 1.1 2013/08/26 10:52:26 patrick Exp $

EAPI=4

inherit fox

DESCRIPTION="Scientific calculator based on the FOX Toolkit"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~hppa ~ppc ~ppc64 ~sparc ~x86"
IUSE=""

RDEPEND="~x11-libs/fox-${PV}"
DEPEND="${RDEPEND}"
