# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/sys-devel/gettext/gettext-0.18.3.1-r1.ebuild,v 1.2 2013/11/30 05:48:31 vapier Exp $

EAPI="4"

inherit flag-o-matic eutils multilib toolchain-funcs mono-env libtool java-pkg-opt-2

DESCRIPTION="GNU locale utilities"
HOMEPAGE="http://www.gnu.org/software/gettext/"
SRC_URI="mirror://gnu/${PN}/${P}.tar.gz"

LICENSE="GPL-3 LGPL-2"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~arm ~hppa ~ia64 ~m68k ~mips ~ppc ~ppc64 ~s390 ~sh ~sparc ~x86 ~amd64-fbsd ~sparc-fbsd ~x86-fbsd"
IUSE="acl -cvs doc emacs git java nls +cxx openmp static-libs elibc_glibc"

DEPEND="virtual/libiconv
	dev-libs/libxml2
	sys-libs/ncurses
	dev-libs/expat
	acl? ( virtual/acl )
	java? ( >=virtual/jdk-1.4 )"
RDEPEND="${DEPEND}
	!git? ( cvs? ( dev-vcs/cvs ) )
	git? ( dev-vcs/git )
	java? ( >=virtual/jre-1.4 )"
PDEPEND="emacs? ( app-emacs/po-mode )"

src_prepare() {
	epatch "${FILESDIR}"/${P}-use_m4_fallback_dir.patch #487794
	java-pkg-opt-2_src_prepare
	epunt_cxx
	elibtoolize
}

src_configure() {
	local myconf=""
	# Build with --without-included-gettext (on glibc systems)
	if use elibc_glibc ; then
		myconf="${myconf} --without-included-gettext $(use_enable nls)"
	else
		myconf="${myconf} --with-included-gettext --enable-nls"
	fi
	use cxx || export CXX=$(tc-getCC)

	# --without-emacs: Emacs support is now in a separate package
	# --with-included-glib: glib depends on us so avoid circular deps
	# --with-included-libcroco: libcroco depends on glib which ... ^^^
	#
	# --with-included-libunistring will _disable_ libunistring (since
	# --it's not bundled), see bug #326477
	econf \
		--cache-file="${S}"/config.cache \
		--docdir="/usr/share/doc/${PF}" \
		--without-emacs \
		--without-lispdir \
		$(use_enable java) \
		--with-included-glib \
		--with-included-libcroco \
		--with-included-libunistring \
		$(use_enable acl) \
		$(use_enable openmp) \
		$(use_enable static-libs static) \
		$(use_with git) \
		$(usex git --without-cvs $(use_with cvs))
}

src_install() {
	emake install DESTDIR="${D}"
	use nls || rm -r "${D}"/usr/share/locale
	use static-libs || rm -f "${D}"/usr/lib*/*.la
	dosym msgfmt /usr/bin/gmsgfmt #43435
	dobin gettext-tools/misc/gettextize

	# remove stuff that glibc handles
	if use elibc_glibc ; then
		rm -f "${D}"/usr/include/libintl.h
		rm -f "${D}"/usr/$(get_libdir)/libintl.*
	fi
	rm -f "${D}"/usr/share/locale/locale.alias "${D}"/usr/lib/charset.alias

	[[ ${USERLAND} == "BSD" ]] && gen_usr_ldscript -a intl

	if use java ; then
		java-pkg_dojar "${D}"/usr/share/${PN}/*.jar
		rm -f "${D}"/usr/share/${PN}/*.jar
		rm -f "${D}"/usr/share/${PN}/*.class
		if use doc ; then
			java-pkg_dojavadoc "${D}"/usr/share/doc/${PF}/javadoc2
			rm -rf "${D}"/usr/share/doc/${PF}/javadoc2
		fi
	fi

	if use doc ; then
		dohtml "${D}"/usr/share/doc/${PF}/*.html
	else
		rm -rf "${D}"/usr/share/doc/${PF}/{csharpdoc,examples,javadoc2,javadoc1}
	fi
	rm -f "${D}"/usr/share/doc/${PF}/*.html

	dodoc AUTHORS ChangeLog NEWS README THANKS
}

pkg_preinst() {
	# older gettext's sometimes installed libintl ...
	# need to keep the linked version or the system
	# could die (things like sed link against it :/)
	preserve_old_lib /{,usr/}$(get_libdir)/libintl$(get_libname 7)

	java-pkg-opt-2_pkg_preinst
}

pkg_postinst() {
	preserve_old_lib_notify /{,usr/}$(get_libdir)/libintl$(get_libname 7)
}
