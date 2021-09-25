# Copyright 2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit meson

DESCRIPTION="A simple library for font loading and glyph rasterization"
HOMEPAGE="https://codeberg.org/dnkl/fcft"
SRC_URI="https://codeberg.org/dnkl/${PN}/archive/${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="examples text-shaping"

DEPEND="
	media-libs/fontconfig
	media-libs/freetype
	x11-libs/pixman
	dev-libs/tllist
	text-shaping? ( media-libs/harfbuzz )
"
RDEPEND="${DEPEND}"
BDEPEND="
	dev-util/meson
"

S="${WORKDIR}/${PN}"

src_configure() {
	local emesonargs=(
		$(meson_use examples)
	)
	meson_src_configure
}

src_install() {
	meson_src_install

	if use docs; then
		mv "${D}/usr/share/doc/${PN}" "${D}/usr/share/doc/${PF}" || die
	fi
}
