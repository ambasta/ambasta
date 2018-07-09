# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6

inherit cmake-utils

DESCRIPTION="A high-performance MongoDB driver for C"
HOMEPAGE="https://github.com/mongodb/mongo-c-driver/"
SRC_URI="https://github.com/mongodb/${PN}/releases/download/${PV}/${P}.tar.gz"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="~amd64"
IUSE="doc examples libressl man sasl ssl static-libs test zlib"
RDEPEND="!dev-libs/libbson
	sasl? ( dev-libs/cyrus-sasl )
	ssl? (
		!libressl? ( dev-libs/openssl:0= )
		libressl? ( dev-libs/libressl:0= )
	)
	zlib? ( sys-libs/zlib )"
DEPEND="${RDEPEND}
	test? ( dev-db/mongodb )"
REQUIRED_USE="test? ( static-libs )"

DOCS=( NEWS README.rst )

src_configure() {
	local mycmakeargs=(
		-DENABLE_STATIC=$(usex static-libs)
		-DENABLE_TESTS=$(usex test)
		-DENABLE_EXAMPLES=$(usex examples)
		-DENABLE_CRYPTO_SYSTEM_PROFILE=$(usex !libressl)
		-DENABLE_ZLIB=$(usex zlib)
		-DENABLE_MAN_PAGES=$(usex man)
		-DENABLE_HTML_DOCS=$(usex doc)
		-DENABLE_SASL=$(usex sasl)
		-DENABLE_SHM_COUNTERS=OFF
		-DENABLE_BSON=ON
		-DENABLE_SNAPPY=OFF
		-DENABLE_EXTRA_ALIGNMENT=ON
		-DENABLE_RDTSCP=ON
	)
	cmake-utils_src_configure
}
