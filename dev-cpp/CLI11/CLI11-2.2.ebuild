# Copyright 2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit cmake

DESCRIPTION="Command line parser for C++11"
HOMEPAGE="https://github.com/CLIUtils/CLI11"
MY_PV="34c4310d9907f6a6c2eb5322fa7472474800577c"
SRC_URI="https://github.com/CLIUtils/${PN}/archive/${MY_PV}.zip"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~x86"

IUSE='libcxx doc examples'

DEPEND="
	libcxx? ( sys-libs/libcxx )
	doc? ( app-doc/doxygen )"
RDEPEND="${DEPEND}"

S="${WORKDIR}/${PN}-${MY_PV}"

src_configure() {
	local mycmakeargs=(
		-DCLI11_BUILD_DOCS=$(usex doc)
		-DCLI11_BUILD_TESTS=OFF
		-DCLI11_BUILD_EXAMPLES_JSON=OFF
		-DCLI11_BUILD_EXAMPLES=$(usex examples)
		-DCLI11_FORCE_LIBCXX=$(usex libcxx)
	)
	cmake_src_configure
}
