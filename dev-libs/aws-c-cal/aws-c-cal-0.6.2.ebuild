# Copyright 2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit cmake

DESCRIPTION="AWS Crypto Abstraction Layer"
HOMEPAGE="https://github.com/awslabs/aws-c-cal"
SRC_URI="https://github.com/awslabs/${PN}/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="~amd64"

IUSE="ssl static-libs tests"

DEPEND="dev-libs/aws-c-common
	ssl? ( dev-libs/openssl )
	!ssl? ( dev-libs/aws-lc )"
RDEPEND="${DEPEND}"
BDEPEND=""

src_configure() {
	local mycmakeargs=(
		-DBYO_CRYPTO=$(usex !ssl)
		-DUSE_OPENSSL=$(usex ssl)
		-DBUILD_SHARED_LIBS=$(usex !static-libs)
		-DBUILD_TESTING=$(usex tests)
	)
	cmake_src_configure
}
