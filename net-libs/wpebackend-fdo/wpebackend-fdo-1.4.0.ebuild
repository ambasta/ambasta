# Copyright 2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7
CMAKE_MAKEFILE_GENERATOR="ninja"

inherit cmake-utils

DESCRIPTION="FreeDesktop.Org backend for WPE WebKit"
HOMEPAGE="https://wpewebkit.org/"
SRC_URI="https://wpewebkit.org/releases/${P}.tar.xz"

LICENSE="BSD-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

DEPEND="
	media-libs/mesa[egl]
	dev-libs/glib:=
	>=dev-libs/wayland-1.10:=
	net-libs/libwpe:="
RDEPEND="${DEPEND}"
