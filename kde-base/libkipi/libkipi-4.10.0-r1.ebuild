# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/kde-base/libkipi/libkipi-4.10.0-r1.ebuild,v 1.1 2013/02/17 20:20:10 dilfridge Exp $

EAPI=5

inherit kde4-base

DESCRIPTION="A library for image plugins accross KDE applications."
KEYWORDS="~amd64 ~arm ~ppc ~x86 ~amd64-linux ~x86-linux"
IUSE="debug"

PATCHES=( "${FILESDIR}/${PN}-4.10.0-uname.patch" )
