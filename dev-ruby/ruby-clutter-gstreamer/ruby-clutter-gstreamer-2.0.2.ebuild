# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-ruby/ruby-clutter-gstreamer/ruby-clutter-gstreamer-2.0.2.ebuild,v 1.1 2013/12/05 11:23:21 naota Exp $

EAPI=5
USE_RUBY="ruby19 ruby20"

inherit ruby-ng-gnome2

DESCRIPTION="Ruby Clutter bindings"
KEYWORDS="~amd64"
IUSE=""

RUBY_S=ruby-gnome2-all-${PV}/clutter-gstreamer

DEPEND="${DEPEND} media-libs/clutter-gst"
RDEPEND="${RDEPEND} media-libs/clutter-gst"

ruby_add_rdepend ">=dev-ruby/ruby-clutter-${PV}
	>=dev-ruby/ruby-gstreamer-${PV}"

each_ruby_configure() {
	:
}

each_ruby_compile() {
	:
}

each_ruby_install() {
	each_fakegem_install
}
