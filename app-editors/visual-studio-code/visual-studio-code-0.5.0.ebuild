# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=5

inherit eutils

DESCRIPTION="Multiplatform Visual Studio Code from Microsoft"
HOMEPAGE="https://code.visualstudio.com"
SRC_URI="
	amd64? ( https://az764295.vo.msecnd.net/public/${PV}/VSCode-linux-x64.zip )
	"
LICENSE="Microsoft"
SLOT="0"
KEYWORDS="~amd64"
IUSE=""

DEPEND="
	>=media-libs/libpng-1.2.46
	>=x11-libs/gtk+-2.24.8-r1:2
	"
RDEPEND="${DEPEND}"

S="${WORKDIR}/VSCode-linux-x64"

ARCH="$(uname -m)"

pkg_pretend(){
	if [[ $ARCH != "x86_64" ]];then
		eerror "This package is ONLY for 64-bit architecure."
		eerror "So if you don't it, you can't install it."
	fi
	return
}

src_install(){
	insinto "/opt/${PN}"
	doins -r *
	dosym "/opt/${PN}/Code" "/usr/bin/visual-studio-code"
	insinto "/usr/share/applications"
	insinto "/usr/share/pixmaps"
	fperms +x "/opt/${PN}/Code"
	fperms +x "/opt/${PN}/libffmpegsumo.so"
}

pkg_postinst(){
	elog "You may install some additional utils, so check them in:"
	elog "https://code.visualstudio.com/Docs/setup#_additional-tools"
}
