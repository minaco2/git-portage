# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-ruby/ruby-hmac/ruby-hmac-0.4.0-r1.ebuild,v 1.1 2013/10/30 04:34:21 mrueg Exp $

EAPI=5
USE_RUBY="ruby18 ruby19 ruby20 jruby"

RUBY_FAKEGEM_TASK_DOC="docs"
RUBY_FAKEGEM_EXTRADOC="History.txt README.txt"

inherit ruby-fakegem

DESCRIPTION="A common interface to HMAC functionality as documented in RFC2104."
HOMEPAGE="http://ruby-hmac.rubyforge.org/"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

ruby_add_bdepend "
	doc? ( >=dev-ruby/hoe-2.5.0 )
	test? ( >=dev-ruby/hoe-2.5.0 )"
