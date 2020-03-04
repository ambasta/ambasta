# Copyright 2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit cmake-utils

DESCRIPTION="Modern C++ Apache Kafka client library (wrapper for librdkafka)"
HOMEPAGE="https://github.com/mfontanini/cppkafka"
MY_PV="7d097df34dd678c4dfdc1ad07027af13f5635863"
MY_P="${PN}-${MY_PV}"

SRC_URI="https://github.com/mfontanini/${PN}/archive/${MY_PV}.zip -> ${MY_P}.zip"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64 ~x86"

IUSE="boost examples tests static-libs"

DEPEND="
	>=dev-libs/librdkafka-0.11.4
	boost? ( dev-libs/boost )"
RDEPEND="${DEPEND}"
BDEPEND=""

S="${WORKDIR}/${MY_P}"

src_configure() {
	local mycmakeargs=(
		-DCPPKAFKA_DISABLE_TESTS=$(usex !tests)
		-DCPPKAFKA_DISABLE_EXAMPLES=$(usex !examples)
		-DCPPKAFKA_BUILD_SHARED=$(usex static-libs)
		-DCPPKAFKA_BOOST_USE_MULTITHREADED=$(usex boost)
	)
	cmake-utils_src_configure
}
