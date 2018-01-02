# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit cmake-multilib versionator

MY_PN="${PN,,}"
MY_PV="$(get_version_component_range 2)"

DESCRIPTION="Implementation of the C++ standard library algorithms with support for execution policies"
HOMEPAGE="https://github.com/intel/parallelstl"
SRC_URI="https://github.com/ambasta/${MY_PN}/archive/${MY_PV}.tar.gz -> ${P}.tar.gz"
LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~arm ~arm64 ~hppa ~ia64 ~ppc ~ppc64 ~sparc ~x86 ~amd64-fbsd ~amd64-linux ~x86-linux"
IUSE="static-libs"

DEPEND=">=dev-cpp/tbb-2018.20181130"
RDEPEND="${DEPEND}"
S="${WORKDIR}/${MY_PN}-${MY_PV}"

multilib_src_configure() {
	local mycmakeargs=(
        -DLINKAGE=$(usex !static-libs)
    )
    cmake-utils_src_configure
}
