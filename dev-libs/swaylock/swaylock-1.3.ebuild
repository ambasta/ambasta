# Copyright 1999-2018 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

SRC_URI="https://github.com/swaywm/swaylock/archive/${PV}.tar.gz -> ${P}.tar.gz"
KEYWORDS="~amd64 ~x86"

inherit eutils fcaps meson

DESCRIPTION="i3-compatible Wayland window manager"
HOMEPAGE="https://swaywm.org"

LICENSE="MIT"
SLOT="0"
IUSE="doc fish-completion +pam zsh-completion"

RDEPEND="dev-libs/wayland
	>=dev-libs/wayland-protocols-1.14
	x11-libs/cairo
	x11-libs/libxkbcommon
	x11-libs/gdk-pixbuf:2[jpeg]
	pam? ( virtual/pam )"
DEPEND="${RDEPEND}"
BDEPEND="app-text/scdoc
	virtual/pkgconfig"

FILECAPS=( cap_sys_admin usr/bin/sway )

src_configure() {
	local emesonargs=(
		"-Dswaylock-version=${PV}"
		$(meson_use zsh-completion zsh-completions)
		$(meson_use fish-completion fish-completions)
		"-Dpam=enabled"
		"-Dbash-completions=true"
		"-Dwerror=false"
		"-Dman-pages=disabled"
	)

	meson_src_configure
}

pkg_postinst() {
	if ! use pam; then
		fcaps cap_sys_admin usr/bin/swaylock
	fi
}
