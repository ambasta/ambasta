# Copyright 2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit cmake

DESCRIPTION="A single-producer, single-consumer lock-free queue for C++"
HOMEPAGE="https://github.com/cameron314/readerwriterqueue"
SRC_URI="https://github.com/cameron314/${PN}/archive/v${PV}.tar.gz"
LICENSE="BSD-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"

DEPEND=""
RDEPEND="${DEPEND}"
