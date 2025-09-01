# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit cmake

DESCRIPTION="Minimalistic C client library for the Redis database"
HOMEPAGE="https://github.com/redis/hiredis"
SRC_URI="https://github.com/redis/${PN}/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="BSD"
# Always check "Upgrading from ..." in README
# e.g. https://github.com/redis/hiredis#upgrading-to-110
SLOT="0/$(ver_cut 1-2)"
KEYWORDS="~alpha amd64 arm arm64 ~hppa ~loong ppc ppc64 ~riscv ~s390 sparc x86 ~x64-solaris"
IUSE="examples ssl static-libs test"
RESTRICT="!test? ( test )"

DEPEND="ssl? ( dev-libs/openssl:= )"
RDEPEND="${DEPEND}"
BDEPEND="
	test? (
		dev-db/redis
		dev-libs/libevent
	)
"
PATCHES=(
	"${FILESDIR}/0001-test-allow-configuration-via-environment-variables.patch"
)

src_configure() {
	local mycmakeargs=(
		-DBUILD_SHARED_LIBS=$(usex !static-libs)
		-DENABLE_SSL=$(usex ssl)
		-DDISABLE_TESTS=$(usex !test)
		-DENABLE_SSL_TESTS=$(usex test "$(usex ssl)" OFF)
		-DENABLE_EXAMPLES=$(usex examples)
		-DENABLE_ASYNC_TESTS=$(usex test)
		-DENABLE_NUGET=OFF
	)
	cmake_src_configure
}

src_test() {
	export REDIS_SERVER="${EPREFIX}/usr/sbin/redis-server"
	export REDIS_PORT=${REDIS_PORT}
	export REDIS_SOCK=${REDIS_SOCK}

	CTEST_OUTPUT_ON_FAILURE=1 cmake_src_test -V --timeout 60
}
