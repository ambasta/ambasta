# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit cmake-utils multilib-minimal

DESCRIPTION="Google's C++ logging library"
HOMEPAGE="https://github.com/google/glog"
SRC_URI="https://github.com/google/${PN}/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="BSD"
SLOT="0"
# -sparc as libunwind is not ported on sparc
KEYWORDS="amd64 arm arm64 ~hppa ~ia64 ~mips ppc ppc64 ~s390 -sparc x86 ~amd64-linux ~x86-linux"
IUSE="gflags static-libs test"
RESTRICT="test"

RDEPEND="sys-libs/libunwind[${MULTILIB_USEDEP}]
	gflags? ( dev-cpp/gflags[${MULTILIB_USEDEP}] )"
DEPEND="${RDEPEND}
	test? ( >=dev-cpp/gtest-1.8.0[${MULTILIB_USEDEP}] )"

src_configure() {
	local mycmakeargs=(
		-DBUILD_SHARED_LIBS=$(usex static-libs OFF ON)
		-DWITH_GFLAGS=$(usex gflags)
	)

	multilib-minimal_src_configure
}
