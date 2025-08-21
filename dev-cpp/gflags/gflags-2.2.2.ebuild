# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit cmake-multilib flag-o-matic

SRC_URI="https://github.com/gflags/gflags/archive/v${PV}.tar.gz -> ${P}.tar.gz"
KEYWORDS="~alpha amd64 arm arm64 ~hppa ~ia64 ~m68k ~mips ppc ppc64 ~s390 ~sparc x86 ~amd64-linux ~x86-linux"

DESCRIPTION="Google's C++ argument parsing library"
HOMEPAGE="http://gflags.github.io/gflags/"

LICENSE="BSD"
SLOT="0/2.2"
IUSE="debug static-libs test"
RESTRICT="!test? ( test )"

# AUTHORS.txt only links the google group
DOCS=(ChangeLog.txt README.md)

src_configure() {
	append-cppflags -D_DEFAULT_SOURCE # usleep() in tests
	use debug || append-cppflags -DFAUDIO_DISABLE_DEBUGCONFIGURATION

	local mycmakeargs=(
		-DBUILD_STATIC_LIBS=$(usex static-libs)
		-DBUILD_TESTING=$(usex test)
		-DREGISTER_INSTALL_PREFIX=OFF
	)

	cmake-multilib_src_configure
}
