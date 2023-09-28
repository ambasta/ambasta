# Copyright 2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit cmake

DESCRIPTION="AWS C99 library implementation of AWS client-side authentication"
HOMEPAGE="https://github.com/awslabs/aws-c-auth"
SRC_URI="https://github.com/awslabs/${PN}/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE=""
SLOT="0"
KEYWORDS="~amd64"

IUSE="static-libs tests"

DEPEND="dev-libs/aws-c-cal
	dev-libs/aws-c-common
	dev-libs/aws-c-compression
	dev-libs/aws-c-io
	dev-libs/aws-c-http
	dev-libs/aws-c-sdkutils
	dev-libs/s2n-tls"
RDEPEND="${DEPEND}"
BDEPEND=""

src_configure() {
	local mycmakeargs=(
		-DBUILD_SHARED_LIBS=$(usex !static-libs)
		-DBUILD_TESTING=$(usex tests)
	)
	cmake_src_configure
}
