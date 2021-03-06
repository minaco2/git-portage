# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/sys-cluster/neutron/neutron-2012.2.4-r1.ebuild,v 1.5 2013/08/22 16:10:35 prometheanfire Exp $

EAPI=5
PYTHON_COMPAT=( python2_7 )

inherit distutils-r1

#restricted due to packages missing and bad depends in the test ==webob-1.0.8   
RESTRICT="test"
DESCRIPTION="Quantum is a virtual network service for Openstack."
HOMEPAGE="https://launchpad.net/neutron"
SRC_URI="http://launchpad.net/${PN}/folsom/${PV}/+download/quantum-${PV}.tar.gz"
S="${WORKDIR}/quantum-${PV}"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="test"

#the cliff dep is as below because it depends on pyparsing, which only has 2.7 OR 3.2, not both
DEPEND="dev-python/setuptools[${PYTHON_USEDEP}]
		test? ( dev-python/cliff[python_targets_python2_7]
				dev-python/configobj[${PYTHON_USEDEP}] )
				dev-python/coverage[${PYTHON_USEDEP}]
				>=dev-python/mock-1.0[${PYTHON_USEDEP}]
				=dev-python/mox-0.5.3-r1[${PYTHON_USEDEP}]
				dev-python/nose[${PYTHON_USEDEP}]
				dev-python/nosehtmloutput[${PYTHON_USEDEP}]
				dev-python/nosexcover
				dev-python/openstack-nose-plugin[${PYTHON_USEDEP}]
				=dev-python/pep8-1.3.3
				>=dev-python/sphinx-1.1.2[${PYTHON_USEDEP}]
				=dev-python/webtest-1.3.3
				virtual/python-unittest2[${PYTHON_USEDEP}]"
RDEPEND="=dev-python/pastedeploy-1.5.0-r1[${PYTHON_USEDEP}]
		>=dev-python/routes-1.12.3[${PYTHON_USEDEP}]
		=dev-python/amqplib-0.6.1
		=dev-python/anyjson-0.2.4[${PYTHON_USEDEP}]
		>=dev-python/eventlet-0.9.17[${PYTHON_USEDEP}]
		>=dev-python/greenlet-0.3.1[${PYTHON_USEDEP}]
		dev-python/httplib2[${PYTHON_USEDEP}]
		>=dev-python/iso8601-0.1.4[${PYTHON_USEDEP}]
		=dev-python/kombu-1.0.4-r1[${PYTHON_USEDEP}]
		dev-python/lxml[${PYTHON_USEDEP}]
		dev-python/netaddr
		>=dev-python/python-quantumclient-2.0[${PYTHON_USEDEP}]
		dev-python/pyudev
		>dev-python/sqlalchemy-0.6.4
		<=dev-python/sqlalchemy-0.7.9
		=dev-python/webob-1.0.8-r1[${PYTHON_USEDEP}]
		net-misc/openvswitch"

python_install() {
	distutils-r1_python_install
	keepdir /etc/quantum
	insinto /etc/quantum

	doins "etc/api-paste.ini"
	doins "etc/dhcp_agent.ini"
	doins "etc/l3_agent.ini"
	doins "etc/policy.json"
	doins "etc/quantum.conf"
	doins "etc/rootwrap.conf"
	insinto /etc
	doins -r "etc/quantum/"

	#remove the etc stuff from usr...
	rm -R "${D}/usr/etc/"
}
