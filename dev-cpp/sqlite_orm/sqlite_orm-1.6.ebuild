# Copyright 2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit cmake-utils

DESCRIPTION="SQLite ORM light header only library for modern C++"
HOMEPAGE="https://github.com/fnc12/sqlite_orm"
SRC_URI="https://github.com/fnc12/${PN}/archive/refs/tags/${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~amd64 ~x86"

IUSE="examples test"

DEPEND="
	dev-db/sqlite
"
RDEPEND="${DEPEND}"

PATCHES=("${FILESDIR}/system-catch2.patch")

src_configure() {
	local mycmakeargs=(
		-DSQLITE_ORM_ENABLE_CXX_17=ON
		-DBUILD_TESTING=$(usex test)
		-DBUILD_EXAMPLES=$(usex examples)
	)
	cmake-utils_src_configure
}
