# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit cmake-multilib

DESCRIPTION="Google's Operations Research tools"
HOMEPAGE="https://developers.google.com/optimization/"
SRC_URI="https://github.com/ambasta/or-tools/archive/v${PV}.tar.gz"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

DEPEND="dev-libs/protobuf
	dev-cpp/glog[gflags]
	sci-libs/coinor-cbc"
RDEPEND="${DEPEND}"
