# Copyright 2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DESCRIPTION="Just launches sway"
HOMEPAGE="https://ambasta.in"
SRC_URI=""

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64"

DEPEND=""
RDEPEND="${DEPEND}"
BDEPEND=""

pkg_postinst() {
	# Launch sway, print the WAYLAND_DISPLAY environment variable, and then shutdown sway
	sway && echo "WAYLAND_DISPLAY=$WAYLAND_DISPLAY" && sway --kill
}
