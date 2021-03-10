# Copyright 2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit cmake-utils

DESCRIPTION="An industrial-strength lock-free queue for C++"
HOMEPAGE="https://github.com/cameron314/concurrentqueue"
SRC_URI="https://github.com/cameron314/${PN}/archive/v${PV}.tar.gz"
LICENSE="BSD-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"

DEPEND=""
RDEPEND="${DEPEND}"
