# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6

inherit cmake-utils

DESCRIPTION="Very fast, header only, C++ logging library."
HOMEPAGE="https://github.com/gabime/spdlog"
SRC_URI="https://github.com/gabime/spdlog/archive/v${PV}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64"
IUSE=""

DEPEND=""

RDEPEND="${DEPEND}"
