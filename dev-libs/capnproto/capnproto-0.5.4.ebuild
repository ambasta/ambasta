# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

inherit autotools

DESCRIPTION="RPC/Serialization system with capabilities support"
HOMEPAGE="http://capnproto.org"
SRC_URI="http://127.0.0.1:8000/capnproto-0.5.4.tar.bz2 -> ${P}.tar.bz2"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~arm"
IUSE="static-libs test"

RDEPEND=""
DEPEND="test? ( dev-cpp/gtest )"

S=${WORKDIR}/${P}/c++

src_prepare() {
	sed -e 's/ldconfig/true/' -i Makefile.am || die
	sed -e 's#gtest/lib/libgtest.la gtest/lib/libgtest_main.la#-lgtest -lgtest_main#' -i Makefile.am || die
	eautoreconf
}

src_configure() {
	econf \
		$(use_enable static-libs static)
}

src_install() {
	default
	find "${ED}" -name '*.la' -delete
}
