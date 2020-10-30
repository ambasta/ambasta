# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit cmake-utils

DESCRIPTION="Geometry engine library for Geographic Information Systems"
HOMEPAGE="https://trac.osgeo.org/geos/"
SRC_URI="http://download.osgeo.org/geos/${PN}-${PV}.tar.bz2"

LICENSE="LGPL-2.1"
SLOT="0"
KEYWORDS="amd64 arm arm64 ~ia64 ppc ppc64 x86 ~amd64-linux ~x86-linux ~ppc-macos ~x64-macos ~x86-macos ~sparc-solaris ~sparc64-solaris ~x64-solaris"
IUSE="doc static-libs"

BDEPEND=""
RDEPEND=""
DEPEND="${RDEPEND}"

RESTRICT="test"

src_prepare() {
	default
	cmake-utils_src_prepare
}

src_configure() {
	local mycmakeargs=(
		-DBUILD_SHARED_LIBS=$(usex static-libs OFF ON)
		-DBUILD_DOCUMENTATION=$(usex doc ON OFF)
		-DDISABLE_GEOS_INLINE=$(usex arm ON OFF)
	)

	cmake-utils_src_configure
}
