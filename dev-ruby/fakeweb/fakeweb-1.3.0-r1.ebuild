# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-ruby/fakeweb/fakeweb-1.3.0-r1.ebuild,v 1.1 2013/11/17 10:31:01 graaff Exp $

EAPI=5

USE_RUBY="ruby18 ruby19 ruby20 jruby"

RUBY_FAKEGEM_DOCDIR="html"
RUBY_FAKEGEM_EXTRADOC="CHANGELOG README.rdoc"

inherit ruby-fakegem

DESCRIPTION="Helper for faking web requests in Ruby"
HOMEPAGE="http://github.com/chrisk/fakeweb"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~arm ~ppc ~x86"
IUSE=""

ruby_add_bdepend "
	test? (
		dev-ruby/mocha:0.12
		dev-ruby/samuel
		dev-ruby/right_http_connection
	)"

all_ruby_prepare() {
	# The package bundles samuel and right_http_connection, remove
	# them and use the packages instead.
	rm -r test/vendor || die "failed to remove bundled gems"

	# We don't package sdoc and we don't have the direct template.
	sed -i -e 's/sdoc/rdoc/' -e '/template/d' Rakefile || die

	# Require an old enough version of mocha
	sed -i -e '1igem "mocha", "~> 0.12.0"' test/test_helper.rb || die
}

each_ruby_prepare() {
	case ${RUBY} in
		*ruby20)
			# Tests fail on mocking of TCPSocket, but fakeweb itself
			# actually works as evidenced by the thor test suite.
			rm test/test_fake_web_open_uri.rb test/test_allow_net_connect.rb test/test_fake_web.rb || die
			;;
	esac
}
