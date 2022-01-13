# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7
VALA_USE_DEPEND="vapigen"

inherit gnome.org meson vala virtualx xdg

DESCRIPTION="Building blocks for modern GNOME applications"
HOMEPAGE="https://gitlab.gnome.org/GNOME/libadwaita/"
SRC_URI="https://gitlab.gnome.org/GNOME/libadwaita/-/archive/${PV}/${P}.tar.bz2"

LICENSE="LGPL-2.1+"
SLOT="0"
KEYWORDS="amd64"

IUSE="examples gtk-doc +introspection test +vala"
REQUIRED_USE="vala? ( introspection )"
RESTRICT="!test? ( test )"

DEPEND="
	dev-libs/glib:2
	dev-libs/fribidi
	>=gui-libs/gtk-4.5.0
	introspection? ( >=dev-libs/gobject-introspection-1.54:= )
"
RDEPEND="${DEPEND}"
BDEPEND="
	gtk-doc? (
		dev-util/gtk-doc
		app-text/docbook-xml-dtd:4.3 )
	dev-util/meson
	dev-lang/sassc
	sys-apps/sed
	vala? ( $(vala_depend) )
"

src_configure() {
	local emesonargs=(
		-Dprofiling=false # -pg passing
		$(meson_feature introspection)
		$(meson_use vala vapi)
		$(meson_use gtk-doc gtk_doc)
		$(meson_use test tests)
		$(meson_use examples)
	)
	meson_src_configure
}
