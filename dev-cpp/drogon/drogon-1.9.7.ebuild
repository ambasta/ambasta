EAPI=8

inherit cmake

DESCRIPTION="C++14/17 based HTTP web application framework"
HOMEPAGE="https://github.com/drogonframework/drogon"
SRC_URI="https://github.com/drogonframework/drogon/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64"
IUSE=""

RDEPEND="
	dev-cpp/trantor
	dev-libs/jsoncpp
	sys-libs/zlib
	app-arch/brotli
	sys-apps/util-linux
	dev-libs/spdlog
	dev-libs/libfmt
	dev-cpp/yaml-cpp"
DEPEND="${RDEPEND}"

src_configure() {
	local -a mycmakeargs=(
		-DBUILD_DOC=NO
		-DBUILD_EXAMPLES=NO
		-DBUILD_POSTGRESQL=NO
		-DBUILD_MYSQL=NO
		-DBUILD_SQLITE=NO
		-DBUILD_REDIS=NO
		-DBUILD_TESTING=NO
		-DBUILD_BROTLI=YES
		-DBUILD_YAML_CONFIG=YES
		-DUSE_SUBMODULE=NO
		-DUSE_SPDLOG=YES
	)

	cmake_src_configure
}
