# Copyright 2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit gnome2-utils meson xdg-utils

MY_PV=$(ver_rs 0-1 -)
MY_P=${PN}-$(ver_rs 0-1 -)

DESCRIPTION="Matrix messaging app for GNOME written in Rust"
HOMEPAGE="https://wiki.gnome.org/Apps/Fractal"
SRC_URI="https://gitlab.gnome.org/GNOME/${PN}/-/archive/${MY_PV}/${MY_P}.tar.bz2"

LICENSE="GPL-3+"
SLOT="0"
KEYWORDS="~amd64"

DEPEND="
	dev-libs/glib
	gui-libs/gtk
	gui-libs/gtksourceview
	gui-libs/libadwaita
	media-libs/gstreamer
	media-libs/gst-plugins-base
"
RDEPEND="${DEPEND}"
BDEPEND=""

S=${WORKDIR}/${MY_P}

src_configure() {
	meson_src_configure
}

pkg_postinst() {
	gnome2_schemas_update
	xdg_icon_cache_update
}

pkg_postrm() {
	gnome2_schemas_update
	xdg_icon_cache_update
}
