# Copyright 2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8
inherit font

DESCRIPTION="Microsoft's font family provided by font service"
HOMEPAGE="https://docs.microsoft.com/en-us/typography/font-list/"

COMMIT="d1145f400523de1d19a3a0092d2df21074da085a"
SRC_URI="https://github.com/ambasta/cleartype-collection/archive/${COMMIT}.tar.gz -> ${P}.tar.gz"

LICENSE="MSttfEULA"
SLOT="0"
KEYWORDS="~amd64"

DEPEND=""
RDEPEND=""

RESTRICT="binchecks strip"

S="${WORKDIR}/${PN}-${COMMIT}"

FONT_SUFFIX="ttf"

FONT_CONF=("${FILESDIR}/60-cleartype-collection.conf")

src_install() {
	mkdir install || die
	mv cleartype_collection*/*.ttf install/. || die

	FONT_S="${S}/install" font_src_install
}
