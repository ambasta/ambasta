# Copyright 2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

CRATES="
ashpd-0.3.2
async-stream-0.3.3
futures-0.3.25
gettext-rs-0.7.0
gstreamer-0.19.5
gstreamer-base-0.19.3
gstreamer-video-0.19.5
gstreamer-player-0.19.4
gst-plugin-gtk4-0.9.4
gtk-macros-0.3.0
gtk4-0.5.5
image-0.24.5
html2pango-0.5.0
indexmap-1.9.2
libadwaita-0.2.1
libsecret-0.2.0
libshumate-0.2.0
log-0.4.17
matrix-sdk-0.6.2
mime-0.3.16
mime_guess-2.0.4
num_enum-0.5.7
once_cell-1.17.0
pulldown-cmark-0.9.2
qrcode-0.12.0
rand-0.8.5
regex-1.7.0
rqrr-0.6.0
ruma-0.7.4
secular-1.0.1
serde-1.0.152
serde_json-1.0.91
sourceview5-0.5.0
thiserror-1.0.38
tokio-1.23.1
tracing-subscriber-0.3.16
url-2.3.1
"

inherit gnome2-utils meson xdg-utils cargo

MY_PV=$(ver_rs 0-1 -)
MY_P=${PN}-$(ver_rs 0-1 -)

DESCRIPTION="Matrix messaging app for GNOME written in Rust"
HOMEPAGE="https://wiki.gnome.org/Apps/Fractal"
SRC_URI="
	https://gitlab.gnome.org/GNOME/${PN}/-/archive/${MY_PV}/${MY_P}.tar.bz2
	$(cargo_crate_uris ${CRATES})
"

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

PATCHES=(
	"${FILESDIR}/0001-Allow-overriding-cargo-home.patch"
)

src_configure() {
	local emesonargs=(
		-Dcargo_home=true
	)

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
