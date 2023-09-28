# Copyright 2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit cmake

DESCRIPTION="General-purpose cryptographic library for AWS"
HOMEPAGE="https://github.com/aws/aws-lc"
SRC_URI="https://github.com/aws/${PN}/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="Apache-2.0 ISC"
SLOT="0"
KEYWORDS="~amd64"

IUSE="go perl system-ssl static-libs tests unwind"

DEPEND="perl? ( dev-lang/perl )
	go? ( dev-lang/go )
	unwind? (
		|| (
			sys-libs/libunwind
			sys-libs/llvm-libunwind
		)
	)"
RDEPEND="${DEPEND}"
BDEPEND=""

src_configure() {
	local mycmakeargs=(
		-DBUILD_LIBSSL=$(usex !system-ssl)
		-DBUILD_TOOL=ON
		-DENABLE_DILITHIUM=OFF
		-DBUILD_SHARED_LIBS=$(usex !static-libs)
		-DDISABLE_PERL=$(usex !perl)
		-DDISABLE_GO=$(usex !go)
		-DBUILD_TESTING=$(usex tests)
	)
	cmake_src_configure
}
