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
IUSE="examples test static-libs ssl"

DEPEND="dev-libs/boost
	ssl? ( dev-libs/openssl )"
RDEPEND="${DEPEND}"

S="${WORKDIR}/${P}-final"

src_configure() {
	local mycmakeargs=(
		-DCPP-NETLIB_BUILD_SHARED_LIBS=$(usex static-libs OFF ON)
		-DCPP-NETLIB_BUILD_TESTS=$(usex test ON OFF)
		-DCPP-NETLIB_BUILD_EXAMPLES=$(usex examples ON OFF)
		-DCPP-NETLIB_ENABLE_HTTPS=$(usex ssl ON OFF)
	)
	cmake-utils_src_configure
}
