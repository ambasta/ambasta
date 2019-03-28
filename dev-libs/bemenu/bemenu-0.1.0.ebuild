# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7
inherit cmake-utils

DESCRIPTION="Dynamic menu library and client program inspired by dmenu"
HOMEPAGE="https://github.com/Cloudef/bemenu"
SRC_URI="https://github.com/Cloudef/${PN}/archive/${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="GPL-v3"
SLOT="0"
KEYWORDS="~amd64 ~arm ~hppa ~ppc ~ppc64 ~x86 ~x86-fbsd"
IUSE="doc ncurses wayland X"

RDEPEND="
	ncurses? ( sys-libs/ncurses )
	wayland? (
		dev-libs/wayland
		x11-libs/libxkbcommon
		x11-libs/cairo
		x11-libs/pango )
	X? (
		x11-libs/libxcb
		x11-libs/libXext
		x11-libs/libX11
		x11-libs/cairo[X]
		x11-libs/pango[X] )
"
RDEPEND="${DEPEND}"
BDEPEND="doc? ( app-doc/doxygen )"

src_configure() {
	local mycmakeargs=(
		-DCURSES_LIBRARY=/usr/$(get_libdir)/libncursesw.so
		-DBEMENU_CURSES_RENDERER=$(usex ncurses ON OFF)
		-DBEMENU_WAYLAND_RENDERER=$(usex wayland ON OFF)
		-DBEMENU_X11_RENDERER=$(usex X ON OFF)
	)
	cmake-utils_src_configure
}
