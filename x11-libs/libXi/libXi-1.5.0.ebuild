# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/x11-libs/libXi/libXi-1.5.0.ebuild,v 1.2 2012/05/04 15:07:26 aballier Exp $

EAPI=4

XORG_DOC=doc
inherit xorg-2

DESCRIPTION="X.Org Xi library"
KEYWORDS="~alpha ~amd64 ~arm ~hppa ~ia64 ~mips ~ppc ~ppc64 ~s390 ~sh ~sparc ~x86 ~amd64-fbsd ~x86-fbsd ~x64-freebsd ~x86-freebsd ~x86-interix ~amd64-linux ~x86-linux ~ppc-macos ~x86-macos ~sparc-solaris ~sparc64-solaris ~x64-solaris ~x86-solaris ~x86-winnt"
IUSE=""

RDEPEND=">=x11-libs/libX11-1.3
	>=x11-libs/libXext-1.1
	>=x11-proto/inputproto-2.0.99.1
	>=x11-proto/xproto-7.0.13
	>=x11-proto/xextproto-7.0.3"
DEPEND="${RDEPEND}"

pkg_setup() {
	xorg-2_pkg_setup
	XORG_CONFIGURE_OPTIONS=(
		$(use_enable doc specs)
		$(use_with doc xmlto)
		$(use_with doc asciidoc)
		--without-fop
	)
}

pkg_postinst() {
	xorg-2_pkg_postinst

	ewarn "Some special keys and keyboard layouts may stop working."
	ewarn "To fix them, recompile xorg-server."
}
