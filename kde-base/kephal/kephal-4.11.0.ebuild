# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/kde-base/kephal/kephal-4.11.0.ebuild,v 1.1 2013/08/14 20:24:15 dilfridge Exp $

EAPI=5

KMNAME="kde-workspace"
KMMODULE="libs/kephal"
inherit kde4-meta

DESCRIPTION="Allows handling of multihead systems via the XRandR extension"
KEYWORDS="~amd64 ~arm ~ppc ~ppc64 ~x86 ~amd64-linux ~x86-linux"
IUSE="debug"

RDEPEND="
	x11-libs/libX11
	x11-libs/libXrandr
"
DEPEND="${RDEPEND}
	x11-proto/randrproto
"

KMEXTRACTONLY+="
	kephal/kephal/screens.h
"
