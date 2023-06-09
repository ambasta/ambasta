# Copyright 2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit cmake

DESCRIPTION="SCIP - Solving Constraint Integer Programs"
HOMEPAGE="https://scipopt.org/"
SRC_URI="https://github.com/scipopt/${PN}/archive/v${PV//./}.tar.gz -> ${P}.tar.gz"

LICENSE=""
SLOT="0"
KEYWORDS="~amd64"

IUSE='ampl ipopt papilo gmp readline static-libs worhp zimpl zlib'

DEPEND="gmp? ( dev-libs/gmp )
	ipopt? ( sci-libs/ipopt )
	readline? ( sys-libs/readline )
	zlib? ( sys-libs/zlib )"
RDEPEND="${DEPEND}"
BDEPEND=""

S="${WORKDIR}/${PN}-${PV//./}"

src_configure() {
	local mycmakeargs=(
		-DAUTOBUILD=OFF
		-DBUILD_SHARED=$(usex static-libs OFF ON)
		-DZLIB=$(usex zlib)
		-DREADLINE=$(usex readline)
		-DGMP=$(usex gmp)
		-DPAPILO=$(usex papilo)
		-DZIMPL=$(usex zimpl)
		-DAMPL=$(usex ampl)
		-DIPOPT=$(usex ipopt)
		-DWORHP=$(usex worhp)
	)
	cmake_src_configure
}
