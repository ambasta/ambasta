# Copyright 2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit cmake

DESCRIPTION="AWS C99 implementation of the HTTP/1.1 and HTTP/2 specifications"
HOMEPAGE="https://github.com/awslabs/aws-c-http"
SRC_URI="https://github.com/awslabs/${PN}/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="~amd64"

IUSE="ssl static-libs tests vsock"

DEPEND="dev-libs/aws-c-common
	dev-libs/aws-c-io
	dev-libs/aws-c-compression"
RDEPEND="${DEPEND}"
BDEPEND=""

src_configure() {
	local mycmakeargs=(
		-DBUILD_SHARED_LIBS=$(usex !static-libs)
		-DBUILD_TESTING=$(usex tests)
	)
	cmake_src_configure
}
