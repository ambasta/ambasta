# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6

PYTHON_COMPAT=( python2_7 )

inherit cmake-utils python-r1

DESCRIPTION="An advanced SAT Solver"
HOMEPAGE="https://github.com/msoos/cryptominisat"
SRC_URI="https://github.com/msoos/${PN}/archive/${PV}.tar.gz"

KEYWORDS="~amd64"

LICENSE="MIT"
IUSE="boost python test threads valgrind zlib"
SLOT=0

DEPEND="dev-util/xxd
	sci-libs/m4ri
	valgrind? ( dev-util/valgrind )
	python? ( dev-python/lit )
	${PYTHON_DEPS}"

RDEPEND="${DEPEND}"

PATCHES=( "${FILESDIR}/${PN}-gnuinstalldirs.patch" )

src_configure() {
	if use python; then
		python_setup
	fi

	local mycmakeargs=(
		-DONLY_SIMPLE=$(usex boost OFF ON)
		-DENABLE_PYTHON_INTERFACE=$(usex python ON OFF)
		-DUSE_PTHREADS=$(usex threads ON OFF)
		-DENABLE_TESTING=$(usex test ON OFF)
		-DNOZLIB=$(usex zlib OFF ON)
		-DNOVALGRIND=$(usex valgrind OFF ON)
	)
	cmake-utils_src_configure
}
