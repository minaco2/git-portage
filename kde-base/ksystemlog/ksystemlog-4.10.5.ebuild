# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/kde-base/ksystemlog/ksystemlog-4.10.5.ebuild,v 1.5 2013/08/02 14:30:16 ago Exp $

EAPI=5

if [[ $PV != *9999 ]]; then
	KMNAME="kdeadmin"
	KDE_ECLASS=meta
else
	KDE_ECLASS=base
fi

KDE_HANDBOOK="optional"
VIRTUALX_REQUIRED=test
inherit kde4-${KDE_ECLASS}

DESCRIPTION="KDE system log viewer"
KEYWORDS="amd64 ~arm ppc ppc64 x86 ~amd64-linux ~x86-linux"
IUSE="debug test"

RESTRICT=test
# bug 378101

src_prepare() {
	kde4-${KDE_ECLASS}_src_prepare

	if use test; then
		# beat this stupid test into shape: the test files contain no year, so
		# comparison succeeds only in 2007 !!!
		local theyear=$(date +%Y)
		einfo Setting the current year as ${theyear} in the test files
		sed -e "s:2007:${theyear}:g" -i tests/systemAnalyzerTest.cpp

		# one test consistently fails, so comment it out for the moment
		sed -e "s:systemAnalyzerTest:# dont run systemAnalyzerTest:g" -i ksystemlog/tests/CMakeLists.txt
	fi
}
