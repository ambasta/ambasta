# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit meson

DESCRIPTION="A modular Wayland compositor library"
HOMEPAGE="http://swaywm.org"
LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="logind elogind pcap rootston systemd xwayland X"
SRC_URI="https://github.com/swaywm/wlroots/archive/$(ver_cut 0-2).tar.gz -> ${P}.tar.gz"

REQUIRED_USE="^^ ( elogind systemd )"
DEPEND="
	>=dev-libs/wayland-1.15
	media-libs/mesa[egl,gbm,gles2]
	x11-libs/libdrm
	>=x11-drivers/xf86-input-libinput-0.17.1
	x11-libs/libxkbcommon
	virtual/udev
	x11-libs/pixman
	pcap? ( net-libs/libpcap )
	elogind? ( sys-auth/elogind )
	systemd? ( sys-apps/systemd )
	xwayland? (
		x11-base/xorg-server[wayland]
		x11-libs/libxcb
		x11-libs/libxkbcommon
		x11-libs/xcb-util
		x11-libs/xcb-util-image
		x11-libs/xcb-util-renderutil )
	X? (
		x11-libs/libxcb
		x11-libs/libxkbcommon
		x11-libs/xcb-util
		x11-libs/xcb-util-image
		x11-libs/xcb-util-renderutil ) "
RDEPEND="${DEPEND}"

src_configure() {
	local emesonargs=(
		-Dlibcap=$(usex pcap enabled disabled)
		-Dlogind=$(usex logind enabled disabled)
		-Dlogind-provider=$(usex systemd systemd elogind)
		-Dxwayland=$(usex xwayland enabled disabled)
		-Dx11-backend=$(usex X enabled disabled)
		-Drootston=$(usex rootston true false)
		-Dexamples=false
		-Dxcb-xkb=$(usex xwayland enabled $(usex X enabled disabled) )
	)
	meson_src_configure
}
