# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-emulation/qemu-user/qemu-user-1.0.ebuild,v 1.9 2013/08/12 14:45:44 pinkbyte Exp $

EAPI=4

inherit eutils base flag-o-matic pax-utils toolchain-funcs

MY_P=${P/-user/}

SRC_URI="http://wiki.qemu.org/download/${MY_P}.tar.gz
		 http://dev.gentoo.org/~lu_zero/distfiles/${MY_P}-patches.tar.xz"

DESCRIPTION="Open source dynamic CPU translator"
HOMEPAGE="http://www.qemu.org"

LICENSE="GPL-2 LGPL-2.1"
SLOT="0"
KEYWORDS="amd64 ppc ppc64 x86"
IUSE=""
RESTRICT="test"

COMMON_TARGETS="i386 x86_64 alpha arm cris m68k microblaze microblazeel mips mipsel ppc ppc64 sh4 sh4eb sparc sparc64 s390x"
IUSE_USER_TARGETS="${COMMON_TARGETS} armeb ppc64abi32 sparc32plus unicore32"

for target in ${IUSE_USER_TARGETS}; do
	IUSE="${IUSE} +qemu_user_targets_${target}"
done

DEPEND="app-text/texi2html
	virtual/pkgconfig
	sys-libs/zlib[static-libs]
	dev-libs/glib[static-libs]"
RDEPEND=""

QA_WX_LOAD="
	usr/bin/qemu-static-ppc64abi32-binfmt
	usr/bin/qemu-static-ppc64
	usr/bin/qemu-static-x86_64-binfmt
	usr/bin/qemu-static-x86_64
	usr/bin/qemu-static-unicore32-binfmt
	usr/bin/qemu-static-m68k-binfmt
	usr/bin/qemu-static-ppc-binfmt
	usr/bin/qemu-static-alpha-binfmt
	usr/bin/qemu-static-microblazeel-binfmt
	usr/bin/qemu-static-sparc-binfmt
	usr/bin/qemu-static-sparc32plus-binfmt
	usr/bin/qemu-static-ppc
	usr/bin/qemu-static-mipsn32el-binfmt
	usr/bin/qemu-static-sh4eb-binfmt
	usr/bin/qemu-static-ppc64abi32
	usr/bin/qemu-static-ppc64-binfmt
	usr/bin/qemu-static-armeb-binfmt
	usr/bin/qemu-static-microblaze-binfmt
	usr/bin/qemu-static-mips-binfmt
	usr/bin/qemu-static-mipsel-binfmt
	usr/bin/qemu-static-sh4-binfmt
	usr/bin/qemu-static-s390x-binfmt
	usr/bin/qemu-static-i386-binfmt
	usr/bin/qemu-static-cris-binfmt
	usr/bin/qemu-static-arm-binfmt
	usr/bin/qemu-static-sparc64-binfmt
	usr/bin/qemu-static-mipsn32-binfmt
"

S="${WORKDIR}/${MY_P}"

src_prepare() {
	# prevent docs to get automatically installed
	sed -i '/$(DESTDIR)$(docdir)/d' Makefile || die
	# Alter target makefiles to accept CFLAGS set via flag-o
	sed -i 's/^\(C\|OP_C\|HELPER_C\)FLAGS=/\1FLAGS+=/' \
		Makefile Makefile.target || die

	EPATCH_SOURCE="${WORKDIR}/patches" EPATCH_SUFFIX="patch" \
	EPATCH_FORCE="yes" epatch
}

src_configure() {
	filter-flags -fpie -fstack-protector

	local conf_opts user_targets

	for target in ${IUSE_USER_TARGETS} ; do
		use "qemu_user_targets_${target}" && \
		user_targets="${user_targets} ${target}-linux-user"
	done

	conf_opts="--enable-linux-user --disable-strip"
	conf_opts+=" --disable-darwin-user --disable-bsd-user"
	conf_opts+=" --disable-system"
	conf_opts+=" --disable-vnc-tls"
	conf_opts+=" --disable-curses"
	conf_opts+=" --disable-sdl"
	conf_opts+=" --disable-vde"
	conf_opts+=" --prefix=/usr --disable-bluez --disable-kvm"
	conf_opts+=" --cc=$(tc-getCC) --host-cc=$(tc-getBUILD_CC)"
	conf_opts+=" --disable-smartcard --disable-smartcard-nss"
	conf_opts+=" --extra-ldflags=-Wl,-z,execheap"
	conf_opts+=" --disable-strip --disable-werror"
	conf_opts+=" --static"

	./configure ${conf_opts} --target-list="${user_targets}" || die "econf failed"
}

src_compile() {
	# enable verbose build, bug #444346
	emake V=1
}

src_install() {
	emake DESTDIR="${ED}" install

	# fixup to avoid collisions with qemu
	base_dir="${ED}/usr/bin"
	for qemu_bin in "${base_dir}"/qemu-*; do
		qemu_bin_name=$(basename "${qemu_bin}")
		mv "${qemu_bin}" "${base_dir}"/"${qemu_bin_name/qemu-/qemu-static-}" || die
	done

	pax-mark r "${ED}"/usr/bin/qemu-static-*
	rm -fr "${ED}/usr/share"
	dohtml qemu-doc.html qemu-tech.html
	newinitd "${FILESDIR}/qemu-binfmt.initd" qemu-binfmt
}
