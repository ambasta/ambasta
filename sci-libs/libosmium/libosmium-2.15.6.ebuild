# Copyright 2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit cmake-utils

DESCRIPTION="A fast and flexible C++ library for working with OpenStreetMap data."
HOMEPAGE="https://osmcode.org/libosmium/"
SRC_URI="https://github.com/osmcode/${PN}/archive/v${PV}.tar.gz -> ${P}.tar.gz"
IUSE="examples"

LICENSE="Boost"
SLOT="0"
KEYWORDS="~amd64 ~x86"

DEPEND="
	app-arch/bzip2
	dev-cpp/sparsehash
	dev-libs/boost
	dev-libs/expat
	dev-libs/protozero
	sci-libs/gdal
	sci-libs/geos
	sci-libs/proj
	sys-libs/zlib"
RDEPEND="${DEPEND}"
BDEPEND="${DEPEND}"

PATCHES=(
	"${FILESDIR}/${P}-cmake-rework.patch"
)

src_configure() {
	local mycmakeargs=(
		-DBUILD_EXAMPLES=$(usex examples)
		-DBUILD_TESTING=OFF
	)
	cmake-utils_src_configure
}
