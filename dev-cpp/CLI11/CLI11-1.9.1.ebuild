# Copyright 2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit cmake-utils

DESCRIPTION="Command line parser for C++11"
HOMEPAGE="https://github.com/CLIUtils/CLI11"
SRC_URI="https://github.com/CLIUtils/${PN}/archive/v${PV}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~x86"

IUSE='cxx doc examples'

DEPEND="
	cxx? ( sys-libs/libcxx )
	doc? ( app-doc/doxygen )"
RDEPEND="${DEPEND}"


WORKDIR="${S}/${P}"

src_configure() {
	local mycmakeargs=(
		-DCLI11_BUILD_DOCS=$(usex doc)
		-DCLI11_BUILD_TESTS=OFF
		-DCLI11_BUILD_EXAMPLES=$(usex examples)
		-DCLI11_FORCE_LIBCXX=$(usex cxx)
	)
	cmake-utils_src_configure
}
