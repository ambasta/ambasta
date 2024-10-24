EAPI=8

inherit cmake

DESCRIPTION="high performance software for linear optimization"
HOMEPAGE="https://highs.dev/"
SRC_URI="https://github.com/ERGO-Code/${PN}/archive/refs/tags/v${PV}.tar.gz -> ${P}.tar.gz"
LICENSE="MIT"

KEYWORDS="~amd64"
IUSE="cxx fortran python zlib static-libs threads test"

SLOT="0"

BDEPEND="
	fortran? ( virtual/fortran )
	python? ( dev-lang/python )
	zlib? ( sys-libs/zlib )"

DEPEND="${BDEPEND}"

src_configure() {
	local -a mycmakeargs=(
		-DFAST_BUILD=ON
		-DBUILD_TESTING=$(usex test)
		-DFORTRAN=$(usex fortran)
		-DPYTHON_BUILD_SETUP=$(usex python)
		-DZIB=$(usex zlib)
		-DEMSCRIPTEN_HTML=OFF
		-DBUILD_SHARED_LIBS=$(usex !static-libs)
	)
	cmake_src_configure
}
