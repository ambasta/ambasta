# Copyright 2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit cmake

DESCRIPTION="AWS C99 implementation of the MQTT 3.1.1 specification."
HOMEPAGE="https://github.com/awslabs/aws-c-mqtt"
SRC_URI="https://github.com/awslabs/${PN}/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE=""
SLOT="0"
KEYWORDS="~amd64"

IUSE="static-libs websockets tests"

DEPEND="dev-libs/aws-c-common
	dev-libs/aws-checksums
	dev-libs/aws-c-cal
	dev-libs/aws-c-io
	dev-libs/s2n-tls"
RDEPEND="${DEPEND}"
BDEPEND=""

src_configure() {
	local mycmakeargs=(
		-DMQTT_WITH_WEBSOCKETS=$(usex websockets)
		-DBUILD_SHARED_LIBS=$(usex !static-libs)
		-DBUILD_TESTING=$(usex tests)
	)
	cmake_src_configure
}
