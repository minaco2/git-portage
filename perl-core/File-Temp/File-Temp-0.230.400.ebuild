# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/perl-core/File-Temp/File-Temp-0.230.400.ebuild,v 1.2 2013/12/05 12:42:33 haubi Exp $

EAPI=3

MODULE_AUTHOR=DAGOLDEN
MODULE_VERSION=0.2304
inherit perl-module

DESCRIPTION="File::Temp can be used to create and open temporary files in a safe way."

SLOT="0"
KEYWORDS="~alpha ~amd64 ~hppa ~ia64 ~mips ~ppc ~ppc64 ~s390 ~sparc ~x86 ~ppc-aix ~amd64-fbsd ~x86-fbsd ~x64-freebsd ~amd64-linux ~x86-linux ~ppc-macos ~x86-macos ~sparc-solaris ~x86-solaris"
IUSE=""

SRC_TEST="do"
