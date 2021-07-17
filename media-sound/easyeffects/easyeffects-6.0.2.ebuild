# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit gnome2-utils meson

DESCRIPTION="Limiter, auto volume and many other plugins for PipeWire applications"
HOMEPAGE="https://github.com/wwmm/easyeffects"

if [[ ${PV} == *9999 ]];then
	inherit git-r3
	SRC_URI=""
	EGIT_REPO_URI="https://github.com/wwmm/easyeffects"
else
	SRC_URI="https://github.com/wwmm/easyeffects/archive/v${PV}.tar.gz -> ${P}.tar.gz"
	KEYWORDS="~amd64 ~arm ~arm64 ~ppc ~ppc64 ~x86"
fi

LICENSE="GPL-3"
SLOT="0"
IUSE=""

#TODO: optional : lilv, zam-plugins (check from archlinux pkg)
RDEPEND="!media-sound/pulseeffects
	>=dev-cpp/glibmm-2.68.0
	>=dev-cpp/gtkmm-4.2.0
	>=dev-libs/glib-2.56:2
	>=dev-libs/libsigc++-2.10:2
	gui-libs/gtk
	>=media-libs/gstreamer-1.12.0:1.0
	>=media-libs/lilv-0.24.2-r1
	media-libs/libebur128
	media-libs/libbs2b
	media-libs/speexdsp
	media-libs/rnnoise
	media-libs/rubberband
	>=media-libs/zita-convolver-3.0.0
	>=media-video/pipewire-0.3.24[gstreamer]
	sys-apps/dbus"
# see 47a950b00c6db383ad07502a8fc396ecca98c1ce for dev-libs/appstream-glib
# and sys-devel/gettext depends reasoning
DEPEND="${RDEPEND}
	dev-libs/appstream-glib
	sys-devel/gettext"
BDEPEND="dev-util/itstool
	media-libs/libsamplerate
	virtual/pkgconfig"

pkg_postinst() {
	gnome2_gconf_install
	gnome2_schemas_update
	xdg_icon_cache_update
}

pkg_postrm() {
	gnome2_gconf_uninstall
	gnome2_schemas_update
	xdg_icon_cache_update
}
