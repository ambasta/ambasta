# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit cmake-utils git-r3

DESCRIPTION="Zero whole machine memory copy async file i/o and filesystem library for the C++ standard"
HOMEPAGE="https://ned14.github.io/llfio/"

EGIT_REPO_URI="https://github.com/ned14/llfio"
EGIT_CLONE_TYPE="shallow"
EGIT_COMMIT="all_tests_passing_efe10b732d26cbaf840b04e955bb5f566cbd6555"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="amd64 x86 ~amd64-linux ~x86-linux"
IUSE="gflags static-libs test"
RESTRICT="test"

RDEPEND=""
DEPEND="${RDEPEND}"

src_configure() {
	local mycmakeargs=(
		-DBUILD_SHARED_LIBS=$(usex static-libs OFF ON)
		-DLLFIO_USE_EXPERIMENTAL_SG14_STATUS_CODE=ON
	)
	cmake-utils_src_configure
}
