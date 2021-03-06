# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-ruby/mecab-ruby/mecab-ruby-0.991.ebuild,v 1.3 2013/07/16 11:37:01 naota Exp $

EAPI=4
# jruby: failed
USE_RUBY="ruby18 ruby19 ree18 rbx"

inherit ruby-ng toolchain-funcs

IUSE=""

DESCRIPTION="Ruby binding for MeCab"
HOMEPAGE="http://mecab.sourceforge.net/"
SRC_URI="http://mecab.googlecode.com/files/${P}.tar.gz"

LICENSE="|| ( BSD LGPL-2.1 GPL-2 )"
KEYWORDS="~amd64 ~ppc ~ppc64 ~x86"
SLOT="0"

DEPEND=">=app-text/mecab-${PV}"
RDEPEND="${DEPEND}"

each_ruby_configure() {
	${RUBY} extconf.rb || die
}

each_ruby_compile() {
	tc-export CXX
	emake || die
}

each_ruby_install() {
	emake install DESTDIR="${D}" || die
}

all_ruby_install() {
	dodoc AUTHORS README test.rb || die
	dohtml bindings.html || die
}
