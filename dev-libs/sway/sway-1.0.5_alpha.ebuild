# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit meson versionator

DESCRIPTION="i3-compatible Wayland window manager"
HOMEPAGE="http://swaywm.org/"
MY_PV_MAJOR=$(get_version_component_range 1-2)
MY_PV_MINOR=$(get_version_component_range 4)
MY_PV_PATCH=$(get_version_component_range 3)
MY_PV="${MY_PV_MAJOR}-${MY_PV_MINOR}.${MY_PV_PATCH}"
SRC_URI="https://github.com/swaywm/sway/archive/${MY_PV}.tar.gz -> ${P}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="gdk-pixbuf logind wallpapers xwayland zsh-completion"

DEPEND=">=dev-libs/json-c-0.13
	dev-libs/libinput
	dev-libs/libpcre
	dev-libs/wayland
	dev-libs/wlroots
	x11-libs/cairo
	logind? ( || (
		sys-auth/elogind
		sys-apps/systemd ) )
	sys-libs/libcap
	virtual/pam
	gdk-pixbuf? ( x11-libs/gdk-pixbuf[jpeg] )
	xwayland? ( x11-libs/libxcb )
	x11-libs/libxkbcommon
	x11-libs/pango
	x11-libs/pixman"
RDEPEND="${DEPEND}"

S="${WORKDIR}/${PN}-${MY_PV}"

src_configure() {
	local emesonargs=(
		-Denable-xwayland=$(usex xwayland true false)
		-Ddefault_wallpaper=$(usex wallpapers true false)
		-Dzsh_completions=$(usex zsh-completion true false)
	)
	meson_src_configure
}
