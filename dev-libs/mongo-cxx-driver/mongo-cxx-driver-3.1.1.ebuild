# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6

inherit cmake-multilib

DESCRIPTION="Asynchronous Network Library"
HOMEPAGE="http://asio.sourceforge.net/"
SRC_URI="https://github.com/mongodb/mongo-cxx-driver/archive/r${PV}.tar.gz"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="~amd64"
IUSE="static-libs"

S="${WORKDIR}/${PN}-r${PV}"

DEPEND="
	>=dev-libs/mongo-c-driver-1.5.0
	dev-libs/boost"

PATCHES=(
	"${FILESDIR}"/mongo-cxx-driver-gnuinstalldirs.patch
)

multilib_src_configure() {
	local mycmakeargs=(
 		-DBUILD_SHARED_LIBS=$(usex !static-libs)
		-DBSONCXX_POLY_USE_BOOST=1
	)
	cmake-utils_src_configure
}