# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-ruby/sprockets/sprockets-2.10.1.ebuild,v 1.1 2013/11/25 01:44:06 mrueg Exp $

EAPI=5
USE_RUBY="ruby19"

RUBY_FAKEGEM_TASK_DOC=""
RUBY_FAKEGEM_EXTRADOC="README.md"

RUBY_FAKEGEM_GEMSPEC="sprockets.gemspec"

inherit ruby-fakegem versionator

DESCRIPTION="Ruby library for compiling and serving web assets."
HOMEPAGE="https://github.com/sstephenson/sprockets"
SRC_URI="https://github.com/sstephenson/sprockets/archive/v${PV}.tar.gz -> ${P}-git.tgz"

LICENSE="MIT"
SLOT="$(get_version_component_range 1)"
KEYWORDS="~amd64 ~arm ~x86 ~amd64-linux ~x86-linux ~ppc-macos ~x64-macos ~x86-macos ~sparc-solaris ~sparc64-solaris ~x64-solaris ~x86-solaris"

IUSE=""

ruby_add_rdepend "
	=dev-ruby/hike-1* >=dev-ruby/hike-1.2
	=dev-ruby/multi_json-1*
	=dev-ruby/rack-1*
	=dev-ruby/tilt-1* >=dev-ruby/tilt-1.3.1
	!!<dev-ruby/sprockets-2.2.2-r1:2.2"

ruby_add_bdepend "test? (
		dev-ruby/json
		dev-ruby/rack-test
		=dev-ruby/coffee-script-2*
		=dev-ruby/execjs-1*
	)"

all_ruby_prepare() {
	# Avoid tests for template types that we currently don't package:
	# eco and ejs.
	sed -i -e '/eco templates/,/end/ s:^:#:' \
		-e '/ejs templates/,/end/ s:^:#:' test/test_environment.rb || die
}
