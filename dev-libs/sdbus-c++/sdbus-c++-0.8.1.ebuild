# Copyright 2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit cmake

DESCRIPTION="High-level C++ D-Bus library for Linux designed to provide easy-to-use yet powerful API in modern C++"
HOMEPAGE="https://github.com/Kistler-Group/sdbus-cpp"
SRC_URI="https://github.com/Kistler-Group/sdbus-cpp/archive/v${PV}.tar.gz"

LICENSE="LGPL-2.1"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="doc systemd test"

DEPEND="
	systemd? ( sys-apps/systemd )
"
RDEPEND="${DEPEND}"
BDEPEND=""

S="${WORKDIR}/sdbus-cpp-${PV}"

src_configure() {
	local mycmakeargs=(
		-DBUILD_CODE_GEN=ON
		-DBUILD_DOC=$(usex doc)
		-DBUILD_LIBSYSTEMD=$(usex !systemd)
		-DBUILD_TESTS=$(usex test)
	)
	cmake_src_configure
}
