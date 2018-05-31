# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit flag-o-matic ltprune meson

DESCRIPTION="Basepack of plugins for gstreamer"
HOMEPAGE="https://gstreamer.freedesktop.org/"
SRC_URI="https://gstreamer.freedesktop.org/src/${PN}/${P}.tar.xz"

LICENSE="GPL-2+ LGPL-2+"
KEYWORDS="alpha amd64 arm ~arm64 ~hppa ia64 ~mips ppc ppc64 ~sh ~sparc x86 ~amd64-fbsd ~x86-fbsd ~amd64-linux ~x86-linux ~ppc-macos ~x64-macos ~x86-macos ~sparc-solaris ~x64-solaris ~x86-solaris"

IUSE="alsa +introspection ivorbis +ogg +orc +pango theora +vorbis X +gles2 opengl +egl +wayland glx"
REQUIRED_USE="
	ivorbis? ( ogg )
	theora? ( ogg )
	vorbis? ( ogg )
"
SLOT="1.0"

RDEPEND="
	app-text/iso-codes
	>=dev-libs/glib-2.40.0:2
	>=media-libs/gstreamer-${PV}:1.0[introspection?]
	>=sys-libs/zlib-1.2.8-r1
	alsa? ( >=media-libs/alsa-lib-1.0.27.2 )
	introspection? ( >=dev-libs/gobject-introspection-1.31.1:= )
	ivorbis? ( >=media-libs/tremor-0_pre20130223 )
	ogg? ( >=media-libs/libogg-1.3.0 )
	orc? ( >=dev-lang/orc-0.4.24 )
	pango? ( >=x11-libs/pango-1.36.3 )
	theora? ( >=media-libs/libtheora-1.1.1[encode] )
	vorbis? ( >=media-libs/libvorbis-1.3.3-r1 )
	X? (
		>=x11-libs/libX11-1.6.2
		>=x11-libs/libXext-1.3.2
		>=x11-libs/libXv-1.0.10
	)
	!<media-libs/gst-plugins-bad-1.11.90:1.0
"
DEPEND="${RDEPEND}
	>=dev-util/gtk-doc-am-1.12
	X? ( x11-base/xorg-proto )
"

src_configure() {
	# filter-flags -mno-sse -mno-sse2 -mno-sse4.1 #610340
	local emesonargs=()

	emesonargs+=(
		-Ddisable_examples=true
 		-Ddisable_introspection=$(usex introspection false true)
		-Duse_orc=$(usex orc yes no)
 		-Dwith-package-name=\"GStreamer ebuild for Gentoo\"
 		-Dwith-package-origin="https://packages.gentoo.org/package/media-libs/gstreamer"
 		-Dlibexecdir="${EPREFIX}"/usr/$(get_libdir)
 	)

	if use gles2 || use opengl; then
		local api=()
		if use gles2; then
			api+="gles2,"
		fi

		if use opengl; then
			api+="opengl,"
		fi
		emesonargs+=( -Dwith_gl_api=${api%?} )
	fi

	if use glx || use egl; then
		local platform=""

		if use glx; then
			platform+="glx,"
		fi

		if use egl; then
			platform+="egl,"
		fi
		emesonargs+=( -Dwith_gl_platform=${platform%?} )
	fi

	if use wayland || use X; then
		local winsys=""

		if use wayland; then
			winsys+="wayland,"
		fi

		if use X; then
			winsys+="x11,"
		fi
		emesonargs+=( -Dwith_gl_winsys=${winsys%?} )
	fi

 	meson_src_configure
}

src_compile() {
	meson_src_compile
}

src_install() {
	DOCS="AUTHORS NEWS README RELEASE"
	einstalldocs
	prune_libtool_files --modules
}
