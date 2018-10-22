# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit meson

DESCRIPTION="i3-compatible Wayland window manager"
HOMEPAGE="http://swaywm.org/"
MY_PV_MAJOR=$(ver_cut 1-2)
MY_PV_MINOR=$(ver_cut 3)
MY_PV_PATCH=$(ver_cut 5)
MY_PV="${MY_PV_MAJOR}-${MY_PV_MINOR}.${MY_PV_PATCH}"
SRC_URI="https://github.com/swaywm/sway/archive/${MY_PV}.tar.gz -> ${P}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="gdk-pixbuf wallpapers xwayland"

DEPEND=">=dev-libs/json-c-0.13
	dev-libs/libinput
	dev-libs/libpcre
	dev-libs/wayland
	>=dev-libs/wayland-protocols-1.14
	>=dev-libs/wlroots-0.1
	x11-libs/cairo
	|| (
		sys-auth/elogind
		sys-apps/systemd )
	sys-libs/libcap
	virtual/pam
	gdk-pixbuf? ( >=x11-libs/gdk-pixbuf-2.0[jpeg] )
	xwayland? ( x11-libs/libxcb )
	x11-libs/libxkbcommon
	x11-libs/pango
	x11-libs/pixman"
RDEPEND="${DEPEND}"

S="${WORKDIR}/${PN}-${MY_PV}"

src_configure() {
	local emesonargs=(
		-Duse_rpath=false
		-Dzsh-completions=false
		-Dbash-completions=false
		-Dfish-completions=false
		-Ddefault-wallpaper=$(usex wallpapers true false)
		-Denable-xwayland=$(usex xwayland true false)
	)
	meson_src_configure
}
