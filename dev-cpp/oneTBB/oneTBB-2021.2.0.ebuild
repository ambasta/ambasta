# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit cmake-utils

DESCRIPTION="High level abstract threading library"
HOMEPAGE="https://www.threadingbuildingblocks.org"
SRC_URI="https://github.com/oneapi-src/${PN}/archive/refs/tags/v${PV}.tar.gz -> ${P}.tar.gz"
LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="~alpha amd64 arm arm64 ~hppa ~ia64 ppc ppc64 ~sparc x86 ~amd64-linux ~x86-linux"
IUSE="static-libs examples"

DEPEND=""
RDEPEND="${DEPEND}"
# S="${WORKDIR}/oneTBB-${MY_PV}"

DOCS=( CHANGES README README.md doc/Release_Notes.txt )

PATCHES=( "${FILESDIR}"/${P}-mallinfo2.patch )

src_configure() {
	local mycmakeargs=(
		-DTBB_EXAMPLES=$(usex examples ON OFF)
		-DBUILD_SHARED_LIBS=$(usex static-libs OFF ON)
		-DCMAKE_CXX_STANDARD=20
	)
	cmake-utils_src_configure
}
