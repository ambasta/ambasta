# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit meson pax-utils

DESCRIPTION="Open source multimedia framework"
HOMEPAGE="https://gstreamer.freedesktop.org/"
SRC_URI="https://${PN}.freedesktop.org/src/${PN}/${P}.tar.xz"

LICENSE="LGPL-2+"
SLOT="1.0"
KEYWORDS="alpha amd64 arm ~arm64 ~hppa ia64 ~mips ppc ppc64 ~sh ~sparc x86 ~amd64-fbsd ~x86-fbsd ~amd64-linux ~x86-linux ~ppc-macos ~x64-macos ~x86-macos ~sparc-solaris ~x64-solaris ~x86-solaris"
IUSE="+caps +introspection nls +orc test unwind"

RDEPEND="
	>=dev-libs/glib-2.40.0:2
	caps? ( sys-libs/libcap )
	introspection? ( >=dev-libs/gobject-introspection-1.31.1:= )
	unwind? (
		>=sys-libs/libunwind-1.2_rc1
		dev-libs/elfutils
	)
"
DEPEND="${RDEPEND}
	>=dev-util/gtk-doc-am-1.12
	sys-devel/bison
	sys-devel/flex
	>=virtual/pkgconfig-0-r1
	nls? ( sys-devel/gettext )
"
src_configure() {
 	local emesonargs=()
 
 	if [[ ${CHOST} == *-interix* ]] ; then
 		export ac_cv_lib_dl_dladdr=no
 		export ac_cv_func_poll=no
 	fi
 	if [[ ${CHOST} == powerpc-apple-darwin* ]] ; then
 		# GCC groks this, but then refers to an implementation (___multi3,
 		# ___udivti3) that don't exist (at least I can't find it), so force
 		# this one to be off, such that we use 2x64bit emulation code.
 		export gst_cv_uint128_t=no
 	fi
 
 	emesonargs+=(
 		-Dlibexecdir="${EPREFIX}"/usr/$(get_libdir)
 		-Ddisable_gst_debug=true
 		-Ddisable_examples=true
 		-Dlibrary_format=shared
 		-Ddisable_libunwind=$(usex unwind false true)
 		-Ddisable_introspection=$(usex introspection false true)
 		-Dwith-package-name="GStreamer ebuild for Gentoo"
 		-Dwith-package-origin="https://packages.gentoo.org/package/media-libs/gstreamer"
 	)
 
 	if use caps; then
 		emesonargs+=(
 			-Dwith-ptp-helper-permissions=capabilities
		)
 	else
 		emesonargs+=(
 			-Dwith-ptp-helper-permissions=setuid-root
 			-Dwith-ptp-helper-setuid-user=nobody
 			-Dwith-ptp-helper-setuid-group=nobody
 		)
 	fi
 	
 	meson_src_configure
}

src_compile() {
 	meson_src_compile
}

src_install() {
 	meson_src_install
 	DOCS="AUTHORS ChangeLog NEWS MAINTAINERS README RELEASE"
 	einstalldocs
 	prune_libtool_files --modules
 
 	# Needed for orc-using gst plugins on hardened/PaX systems, bug #421579
	use orc && pax-mark -m "${ED}usr/bin/gst-launch-${SLOT}"
}
