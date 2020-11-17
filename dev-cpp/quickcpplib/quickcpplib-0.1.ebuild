# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit cmake-utils git-r3

DESCRIPTION="Quick C++ Libraries"
HOMEPAGE="https://ned14.github.io/quickcpplib/"

EGIT_REPO_URI="https://github.com/ned14/${PN}"
EGIT_CLONE_TYPE="shallow"
EGIT_COMMIT="202ea39acacb0daf00c0629c8ed131764ec7c332"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="amd64 x86 ~amd64-linux ~x86-linux"
IUSE="static-libs test"
RESTRICT="test"

RDEPEND=""
DEPEND="${RDEPEND}"

src_configure() {
	local mycmakeargs=(
		-DBUILD_SHARED_LIBS=$(usex static-libs OFF ON)
	)
	cmake-utils_src_configure
}
