# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-leechcraft/lc-seekthru/lc-seekthru-0.5.97.ebuild,v 1.1 2013/06/11 17:42:40 maksbotan Exp $

EAPI="4"

inherit leechcraft

DESCRIPTION="OpenSearch support for LeechCraft"

SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="debug"

DEPEND="~app-leechcraft/lc-core-${PV}"
RDEPEND="${DEPEND}
		virtual/leechcraft-search-show
		virtual/leechcraft-downloader-http"