# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit cmake

MY_PN="redis-plus-plus"

DESCRIPTION="Redis client written in C++"
HOMEPAGE="https://github.com/sewenew/${MY_PN}"
SRC_URI="https://github.com/sewenew/${MY_PN}/archive/${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="Apache-2.0"
# Always check "Upgrading from ..." in README
# e.g. https://github.com/redis/hiredis#upgrading-to-110
SLOT="0/$(ver_cut 1-2)"
KEYWORDS="~alpha amd64 arm arm64 ~hppa ~loong ppc ppc64 ~riscv ~s390 sparc x86 ~x64-solaris"
IUSE="async ssl static-libs test"
RESTRICT="!test? ( test )"

DEPEND="ssl? ( dev-libs/openssl:= )"
RDEPEND="${DEPEND}"
BDEPEND="
	async? (
		dev-libs/libuv
	)
	test? (
		dev-db/redis
		dev-libs/libevent
	)
"

S="${WORKDIR}/${MY_PN}-${PV}"

src_configure() {
	local mycmakeargs=(
		-DREDIS_PLUS_PLUS_BUILD_ASYNC=$(usex async libuv OFF)
		-DREDIS_PLUS_PLUS_BUILD_STATIC=$(usex static-libs)
		-DREDIS_PLUS_PLUS_BUILD_SHARED=$(usex !static-libs)
		-DREDIS_PLUS_PLUS_USE_TLS=$(usex ssl)
		-DREDIS_PLUS_PLUS_BUILD_TEST=$(usex test)
		-DREDIS_PLUS_PLUS_BUILD_ASYNC_TEST=$(usex test "$(usex async)" OFF)
	)
	cmake_src_configure
}
