EAPI=8

inherit meson xdg

DESCRIPTION="Modular status panel for X11 and Wayland"
HOMEPAGE="https://codeberg.org/dnkl/yambar"

SRC_URI="https://codeberg.org/dnkl/${PN}/archive/${PV}.tar.gz -> ${P}.tar.gz"

KEYWORDS="~amd64"

LICENSE="MIT"
SLOT=0

IUSE="alsa +json mpd +pipewire pulseaudio static-libs +wayland X"

S="${WORKDIR}/${PN}"

RDEPEND="app-alternatives/sh
	json? ( dev-libs/json-c )
	dev-libs/libyaml
	dev-libs/tllist
	alsa? ( media-libs/alsa-lib )
	media-libs/fcft
	pulseaudio? ( media-libs/libpulse )
	pipewire? ( media-video/pipewire )
	mpd? ( media-libs/libmpdclient )
	sys-apps/coreutils
	virtual/udev
	wayland? (
		dev-libs/wayland
		dev-libs/wayland-protocols
		dev-util/wayland-scanner
	)
	x11-libs/pixman
	x11-libs/libxcb[xkb]
	X? (
		x11-libs/xcb-util
		x11-libs/xcb-util-cursor
		x11-libs/xcb-util-errors
		x11-libs/xcb-util-renderutil
		x11-libs/xcb-util-wm
	)"

BDEPEND="${RDEPEND}
	sys-devel/bison
	app-text/scdoc
	sys-devel/flex
	virtual/pkgconfig
	wayland? (
		dev-util/wayland-scanner
	)"

src_prepare() {
	if use pipewire && ! use json; then
		eerror "'pipewire' module requires USE flag 'json' to be enabled."
		return 1
	fi

	default
}

src_configure() {
	local emesonargs=(
		$(meson_feature wayland backend-wayland)
		$(meson_feature X backend-x11)
		$(meson_use !static-libs core-plugins-as-shared-libraries)
		$(meson_feature alsa plugin-alsa)
		$(meson_feature mpd plugin-mpd)
		$(meson_feature json plugin-i3)
		$(meson_feature pipewire plugin-pipewire)
		$(meson_feature pulseaudio plugin-pulse)
		$(meson_feature wayland plugin-river)
		$(meson_feaature json plugin-sway-xkb)
		$(meson_feature X plugin-xkb)
		$(meson_feature X plugin-xwindow)
	)

	for plugin in {backlight,battery,clock,cpu,disk-io,dwl,foreign-toplevel,mem,label,network,removables,script}; do
		emesonargs+=( -Dplugin-${plugin}=enabled )
	done

	meson_src_configure
}
