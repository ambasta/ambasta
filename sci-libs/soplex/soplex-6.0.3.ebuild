# Copyright 2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit cmake

DESCRIPTION=" Sequential object-oriented simPlex "
HOMEPAGE="https://scipopt.org/"
SRC_URI="https://github.com/scipopt/${PN}/archive/release-${PV//./}.tar.gz -> ${P}.tar.gz"

LICENSE="zuse"
SLOT="0"
KEYWORDS="~amd64"

IUSE='boost gmp mpfr papilo zlib'

DEPEND="boost? ( dev-libs/boost )
	gmp? ( dev-libs/gmp )
	mpfr? ( dev-libs/mpfr )
	zlib? ( sys-libs/zlib )"
RDEPEND="${DEPEND}"
BDEPEND=""

S="${WORKDIR}/${PN}-release-${PV//./}"

PATCHES=(
	"${FILESDIR}/Don-t-hardcode-installation-directories.patch"
	"${FILESDIR}/C-23-fixes.patch"
)

src_configure() {
	local mycmakeargs=(
		-DCMAKE_INSTALL_LIBDIR="$(get_libdir)"
		-DBOOST=$(usex boost)
		-DGMP=$(usex gmp)
		-DMPFR=$(usex mpfr)
		-DPAPILO=$(usex papilo)
		-DZLIB=$(usex zlib)
	)
	cmake_src_configure
}
