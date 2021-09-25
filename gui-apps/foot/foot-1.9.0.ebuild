# Copyright 2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit meson

DESCRIPTION="A fast, lightweight and minimalistic Wayland terminal emulator"
HOMEPAGE="https://codeberg.org/dnkl/foot"
SRC_URI="https://codeberg.org/dnkl/${PN}/archive/${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="+completion docs grapheme-clustering ime +notify pgo +terminfo xdg"

DEPEND="
	media-libs/fcft
	dev-libs/wayland
	media-libs/fontconfig
	media-libs/freetype
	x11-libs/pixman
	x11-libs/libxkbcommon
	completion? ( app-shells/bash-completion )
	grapheme-clustering? ( dev-libs/libutf8proc )
	notify? ( x11-libs/libnotify )
	xdg? ( x11-misc/xdg-utils )
"
RDEPEND="${DEPEND}"
BDEPEND="
	dev-libs/tllist
	dev-util/ninja
	dev-util/meson
	dev-libs/wayland-protocols
	docs? ( app-text/scdoc )
	terminfo? ( sys-libs/ncurses )"

S="${WORKDIR}/${PN}"

src_configure() {
	local emesonargs=(
		$(meson_feature docs)
		$(meson_use ime)
		$(meson_feature terminfo)
		$(meson_feature grapheme-clustering)
	)
	meson_src_configure
}

src_install() {
	meson_src_install

	if use docs; then
		mv "${D}/usr/share/doc/${PN}" "${D}/usr/share/doc/${PF}" || die
	fi
}

pkg_postinst() {
	xdg_icon_cache_update
}

pkg_postrm() {
	xdg_icon_cache_update
}
