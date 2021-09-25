# Copyright 2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit meson

DESCRIPTION="A C header file only implementation of a typed linked list."
HOMEPAGE="https://codeberg.org/dnkl/tllist"
SRC_URI="https://codeberg.org/dnkl/${PN}/archive/${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~x86"

BDEPEND="
	dev-util/meson
"

S="${WORKDIR}/${PN}"
