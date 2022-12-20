# Copyright 2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit cmake

PYTHON_COMPAT=( python3_{8..11} )

DESCRIPTION="High performance, scalable, production quality, NoSQL platform"
HOMEPAGE="https://source.wiredtiger.com/"
SRC_URI="https://github.com/${PN}/${PN}/archive/refs/tags/${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="SSPL-1"
SLOT="0"
KEYWORDS="~amd64"

IUSE="debug libsodium lz4 pic python snappy static-libs tests zlib zstd"

DEPEND="
	libsodium? ( dev-libs/libsodium )
	lz4? ( app-arch/lz4 )
	python? ( dev-lang/python )
	snappy? ( app-arch/snappy )
	zlib? ( sys-libs/zlib )
	zstd? ( app-arch/zstd )
"
RDEPEND="${DEPEND}"
BDEPEND="dev-lang/swig"


src_configure() {
	local mycmakeargs=(
		-DBUILD_SHARED_LIBS=$(usex !static-libs)
		-DBUILD_TESTING=$(usex tests)
		-DWITH_PIC=$(usex pic)
		-DNENABLE_PYTHON=$(usex python)
		-DENABLE_LZ4=$(usex lz4)
		-DENABLE_SNAPPY=$(usex snappy)
		-DENABLE_ZLIB=$(usex zlib)
		-DENABLE_ZSTD=$(usex zstd)
		-DENABLE_SODIUM=$(usex libsodium)
		-DENABLE_TCMALLOC=OFF
		-DENABLE_CPPSUITE=ON
		-DENABLE_DEBUG_INFO=$(usex debug)
	)
	cmake_src_configure
}

src_install() {
	cmake_src_install
}
