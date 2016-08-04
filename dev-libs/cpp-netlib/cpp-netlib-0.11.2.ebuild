# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

inherit cmake-utils

DESCRIPTION="A collection of open-source libraries for high level network programming.."
HOMEPAGE="http://cpp-netlib.github.com/"
SRC_URI="http://downloads.cpp-netlib.org/${PV}/${P}-final.tar.bz2"

LICENSE="Boost-1.0"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="examples test"

DEPEND="dev-libs/boost"
RDEPEND="${DEPEND}"

S="${WORKDIR}/${P}-final"

src_configure() {
	local mycmakeargs=(
		-DBUILD_SHARED_LIBS=ON
		 $(cmake-utils_use test CPP-NETLIB_BUILD_TESTS )
		 $(cmake-utils_use examples CPP-NETLIB_BUILD_EXAMPLES )

	)
	cmake-utils_src_configure
}
