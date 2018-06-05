# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit flag-o-matic ltprune meson

DESCRIPTION="Basepack of plugins for gstreamer"
HOMEPAGE="https://gstreamer.freedesktop.org/"
SRC_URI="https://gstreamer.freedesktop.org/src/${PN}/${P}.tar.xz"

LICENSE="GPL-2+ LGPL-2+"
KEYWORDS="alpha amd64 arm ~arm64 ~hppa ia64 ~mips ppc ppc64 ~sh ~sparc x86 ~amd64-fbsd ~x86-fbsd ~amd64-linux ~x86-linux ~ppc-macos ~x64-macos ~x86-macos ~sparc-solaris ~x64-solaris ~x86-solaris"

IUSE="+orc v4l"
SLOT="1.0"

RDEPEND="
	>=dev-libs/glib-2.40.0:2
	>=media-libs/gst-plugins-base-${PV}:${SLOT}
	>=media-libs/gstreamer-${PV}:${SLOT}
	>=app-arch/bzip2-1.0.6-r4
	>=sys-libs/zlib-1.2.8-r1
	orc? ( >=dev-lang/orc-0.4.17 )
"
DEPEND="${RDEPEND}
	>=dev-util/gtk-doc-am-1.12
"

src_configure() {
	# filter-flags -mno-sse -mno-sse2 -mno-sse4.1 #610340
	local emesonargs=()

	emesonargs+=(
		-Ddisable_examples=true
 		-Ddisable_gst_debug=true
 		-Dlibrary_format=shared
		-Duse_orc=$(usex orc yes no)
		-Dwith-libv4l2=$(usex v4l true false)
 		-Dwith-package-name="GStreamer ebuild for Gentoo"
 		-Dwith-package-origin="https://packages.gentoo.org/package/media-libs/gstreamer"
 		-Dlibexecdir="${EPREFIX}"/usr/$(get_libdir)
 	)
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
