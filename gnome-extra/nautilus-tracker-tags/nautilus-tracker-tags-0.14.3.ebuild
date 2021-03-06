# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/gnome-extra/nautilus-tracker-tags/nautilus-tracker-tags-0.14.3.ebuild,v 1.1 2012/10/25 07:56:44 tetromino Exp $

EAPI="4"
GNOME_ORG_MODULE="tracker"
GNOME_TARBALL_SUFFIX="xz"

inherit gnome.org toolchain-funcs

DESCRIPTION="Nautilus extension to tag files for Tracker"
HOMEPAGE="http://www.tracker-project.org/"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

COMMON_DEPEND=">=app-misc/tracker-${PV}
	>=dev-libs/glib-2.28:2
	>=gnome-base/nautilus-2.90
	x11-libs/gtk+:3"
RDEPEND="${COMMON_DEPEND}
	!<app-misc/tracker-0.12.5-r1[nautilus]"
# Before tracker-0.12.5-r1, nautilus-tracker-tags was part of tracker
DEPEND="${COMMON_DEPEND}"

S="${S}/src/plugins/nautilus"

pkg_setup() {
	tc-export CC
	export TRACKER_API=${GNOME_ORG_PVP}
}

src_prepare() {
	cp "${FILESDIR}/0.12.5-Makefile" Makefile || die "cp failed"
	# config.h is not used, but is included in every source file...
	sed -e 's:#include "config.h"::' -i *.c *.h || die "sed failed"
}

src_install() {
	emake DESTDIR="${D}" install
}
