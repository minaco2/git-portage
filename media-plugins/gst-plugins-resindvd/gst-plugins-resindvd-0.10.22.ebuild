# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/media-plugins/gst-plugins-resindvd/gst-plugins-resindvd-0.10.22.ebuild,v 1.8 2012/12/02 16:32:16 eva Exp $

EAPI="1"

inherit gst-plugins-bad

KEYWORDS="alpha amd64 hppa ppc ppc64 sparc x86 ~amd64-fbsd"
IUSE=""

RDEPEND=">=media-libs/libdvdnav-4.1.2
	>=media-libs/libdvdread-4.1.2
	>=media-libs/gst-plugins-base-0.10.33:0.10"
DEPEND="${RDEPEND}"
