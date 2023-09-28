# Copyright 2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit cmake

DESCRIPTION="AWS C99 Compression Algorithms"
HOMEPAGE="https://github.com/awslabs/aws-c-compression"
SRC_URI="https://github.com/awslabs/${PN}/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="~amd64"

IUSE="huffman static-libs tests"

DEPEND="dev-libs/aws-c-common"
RDEPEND="${DEPEND}"
BDEPEND=""

src_configure() {
	local mycmakeargs=(
		-DBUILD_HUFFMAN_GENERATOR=$(usex huffman)
		-DBUILD_SHARED_LIBS=$(usex !static-libs)
		-DBUILD_TESTING=$(usex tests)
	)
	cmake_src_configure
}
