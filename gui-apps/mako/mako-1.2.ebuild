# Copyright 2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit meson

DESCRIPTION="A lightweight Wayland notification daemon"
HOMEPAGE="https://github.com/emersion/mako"

SRC_URI="https://github.com/emersion/${PN}/archive/v${PV}.tar.gz -> ${P}.tar.gz"
KEYWORDS="~amd64 ~x86"

LICENSE="MIT"
SLOT="0"
IUSE="elogind icon systemd"
REQUIRED_USE="?? ( elogind systemd )"

DEPEND="
	x11-libs/cairo
	x11-libs/pango
	dev-libs/wayland
	elogind? ( sys-auth/elogind )
	systemd? ( sys-apps/systemd )
	icon? (
		x11-libs/gtk+:3
		x11-libs/gdk-pixbuf:2 )"

RDEPEND="${DEPEND}"
BDEPEND=""

src_configure() {
	local emesonargs=(
		-Dicons=$(usex icon enabled disabled)
	)
	meson_src_configure
}

