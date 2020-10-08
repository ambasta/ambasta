# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit cmake-utils

DESCRIPTION="Google's Operations Research tools"
HOMEPAGE="https://developers.google.com/optimization/"
SRC_URI="https://github.com/google/or-tools/archive/v${PV}.tar.gz"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="coinor examples static-libs"

DEPEND="dev-libs/protobuf
	dev-cpp/glog[gflags]
	coinor? (
		sci-libs/coinor-cbc
	)"
RDEPEND="${DEPEND}"

PATCHES=(
    "${FILESDIR}/0001-Abseil-C-17-uses-invoke_result_t-do-not-link-with-SC.patch"
)


src_configure() {
	local mycmakeargs=(
		-DBUILD_CXX=ON
		-DBUILD_SAMPLES=$(usex examples)
		-DBUILD_EXAMPLES=$(usex examples)
		-DBUILD_SHARED=$(usex static-libs OFF ON)
		-DUSE_COINOR=$(usex coinor)
		-DUSE_SCIP=OFF
	)

	cmake-utils_src_configure
}
