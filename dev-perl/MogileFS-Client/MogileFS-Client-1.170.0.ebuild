# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-perl/MogileFS-Client/MogileFS-Client-1.170.0.ebuild,v 1.1 2013/08/19 18:27:25 robbat2 Exp $

EAPI=4

MODULE_AUTHOR=DORMANDO
MODULE_VERSION=${PV%0.0}
inherit perl-module

DESCRIPTION="Client library for the MogileFS distributed file system"

SLOT="0"
KEYWORDS="~amd64 ~ppc ~x86"
IUSE=""

RDEPEND=">=dev-perl/IO-stringy-2.110
	dev-perl/libwww-perl"
DEPEND="${RDEPEND}"

# Tests only available if you have a local mogilefsd on 127.0.0.1:7001
#SRC_TEST="do"
