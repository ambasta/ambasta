# Copyright 2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit meson

DESCRIPTION="Terminfo for foot, wayland terminal emulator"
HOMEPAGE="https://codeberg.org/dnkl/foot"
SRC_URI="https://codeberg.org/dnkl/foot/archive/${PV}.tar.gz -> ${P}.tar.gz"
S="${WORKDIR}/foot"

LICENSE="MIT"
SLOT="0"
KEYWORDS="amd64 x86"
RESTRICT="test" # intended to be ran on the full foot package

BDEPEND="sys-libs/ncurses"

src_compile() {
	local emesonargs=(
		-Dterminfo=disabled
		-Ddocs=disabled
		-Dime=false
		-Dgrapheme-clustering=disabled
		-Dterminfo=enabled
		-Ddefault-terminfo=foot
	)

	meson_src_configure
}

src_install() {
	dodir /usr/share/terminfo
	tic -xo "${ED}"/usr/share/terminfo ${BUILD_DIR}/foot.info.preprocessed || die
}
#
# src_compile() {
# 	tic -x -o "${S}" -e foot,foot-direct "${S}/foot.info" || die "Failed to compile terminfo"
# }
#
# src_install() {
# 	dodir /usr/share/terminfo/f/
# 	cp "${S}/f/foot" "${D}/usr/share/terminfo/f/foot" || die
# 	cp "${S}/f/foot-direct" "${D}/usr/share/terminfo/f/foot-direct" || die
# }
