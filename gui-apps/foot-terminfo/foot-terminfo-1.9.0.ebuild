# Copyright 2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

MY_PN="foot"

DESCRIPTION="Terminfo for foot, a fast, lightweight and minimalistic Wayland terminal emulator"
HOMEPAGE="https://codeberg.org/dnkl/foot"
SRC_URI="https://codeberg.org/dnkl/${MY_PN}/archive/${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="+completion docs grapheme-clustering ime +notify pgo +terminfo xdg"

DEPEND=""
RDEPEND="${DEPEND}"
BDEPEND="sys-libs/ncurses"

S="${WORKDIR}/${MY_PN}"

src_compile() {
	tic -x -o "${S}" -e foot,foot-direct "${S}/foot.info" || die "Failed to compile terminfo"
}

src_install() {
	dodir /usr/share/terminfo/f/
	cp "${S}/f/foot" "${D}/usr/share/terminfo/f/foot" || die
	cp "${S}/f/foot-direct" "${D}/usr/share/terminfo/f/foot-direct" || die
}
