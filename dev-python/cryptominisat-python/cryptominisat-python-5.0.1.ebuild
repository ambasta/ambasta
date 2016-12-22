# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6

inherit cmake-utils python-r1

DESCRIPTION="An advanced SAT Solver"
HOMEPAGE="https://github.com/msoos/cryptominisat"
SRC_URI="https://github.com/msoos/${PN}/archive/${PV}.tar.gz"

KEYWORDS="~amd64"

LICENSE="MIT"
IUSE=""
SLOT=0

DEPEND="dev-util/xxd
	sci-libs/m4ri
	valgrind? ( dev-util/valgrind )
	dev-python/lit"

RDEPEND="${DEPEND}"

PATCHES=( "${FILESDIR}/${PN}-gnuinstalldirs.patch" )

src_configure() {
	local mycmakeargs=(
		-DENABLE_PYTHON_INTERFACE=ON
	)
	cmake-utils_src_configure
}
