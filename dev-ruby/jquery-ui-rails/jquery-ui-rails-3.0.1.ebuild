# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-ruby/jquery-ui-rails/jquery-ui-rails-3.0.1.ebuild,v 1.1 2013/10/25 12:46:38 graaff Exp $

EAPI=5
USE_RUBY="ruby18 ruby19"

RUBY_FAKEGEM_TASK_DOC=""
RUBY_FAKEGEM_TASK_TEST=""

RUBY_FAKEGEM_EXTRADOC="History.md README.md"

RUBY_FAKEGEM_EXTRAINSTALL="vendor"

inherit ruby-fakegem

DESCRIPTION="The jQuery UI assets for the Rails 3.1+ asset pipeline."
HOMEPAGE="http://www.rubyonrails.org"

LICENSE="MIT"
SLOT="3"
KEYWORDS="~amd64 ~arm ~x86 ~x64-macos"

IUSE=""

ruby_add_rdepend ">=dev-ruby/railties-3.1 dev-ruby/jquery-rails"
