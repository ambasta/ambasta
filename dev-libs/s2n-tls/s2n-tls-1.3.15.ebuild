# Copyright 2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PYTHON_COMPAT=( python3_{7..10} )

inherit cmake python-single-r1

DESCRIPTION="AWS s2n-tls is a C99 implementation of the TLS/SSL protocols"
HOMEPAGE="https://github.com/aws/s2n-tls"
SRC_URI="https://github.com/aws/${PN}/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="~amd64"

IUSE="lto static-libs trace tests"

DEPEND="dev-libs/openssl[static-libs?]"
RDEPEND="${DEPEND}"
BDEPEND=""

src_configure() {
	# env S2N_LIBCRYPTO openssl-1.1.1
	# env TESTS integration
	local mycmakeargs=(
		-DS2N_LTO=$(usex lto)
		-DS2N_STACKTRACE=$(usex trace)
		-DBUILD_TESTING=$(usex tests)
		-DBUILD_SHARED_LIBS=$(usex !static-libs)
	)
	cmake_src_configure
}
