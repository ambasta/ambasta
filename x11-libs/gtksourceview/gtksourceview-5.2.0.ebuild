# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit gnome.org meson vala virtualx xdg

DESCRIPTION="A text widget implementing syntax highlighting and other features"
HOMEPAGE="https://wiki.gnome.org/Projects/GtkSourceView"

LICENSE="LGPL-2.1+"
SLOT="4"

IUSE="gtk-doc +introspection profiler +vala"
REQUIRED_USE="vala? ( introspection )"

KEYWORDS="~alpha amd64 arm arm64 ~ia64 ~mips ppc ppc64 ~riscv sparc x86 ~amd64-linux ~x86-linux ~ppc-macos ~x86-solaris"

RDEPEND="
	>=dev-libs/glib-2.48:2
	>=x11-libs/gtk+-3.24:3[introspection?]
	>=dev-libs/libxml2-2.6:2
	profiler? ( dev-util/sysprof )
	introspection? ( >=dev-libs/gobject-introspection-1.42.0:= )
	>=dev-libs/fribidi-0.19.7
"
DEPEND="${RDEPEND}"
BDEPEND="
	dev-util/glib-utils
	gtk-doc? (
		>=dev-util/gtk-doc-1.25
		app-text/docbook-xml-dtd:4.3
	)
	>=sys-devel/gettext-0.19.8
	virtual/pkgconfig
	vala? ( $(vala_depend) )
"

src_prepare() {
	use vala && vala_src_prepare
	xdg_src_prepare
}

src_configure() {
	local emesonargs=(
		-Dinstall_tests=false
		$(meson_use profiler sysprof)
		$(meson_feature introspection)
		$(meson_use vala vapi)
		$(meson_use gtk-doc gtk_doc)
	)
	meson_src_configure
}

src_test() {
	virtx meson_src_test
}
