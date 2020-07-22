# Copyright 2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

EGIT_REPO_URI="https://github.com/MaskRay/${PN}"

GIT_ECLASS="git-r3"

inherit cmake ${GIT_ECLASS}

DESCRIPTION="C/C++/ObjC language server"
HOMEPAGE="https://github.com/MaskRay/ccls"

SRC_URI=""
KEYWORDS="~amd64"

LICENSE="Apache-2.0"
SLOT="0"
IUSE=""

DEPEND="
	dev-libs/rapidjson
	sys-devel/clang:=
	sys-devel/llvm:=
"
RDEPEND="${DEPEND}"

src_configure() {
	local mycmakeargs=(
		-DUSE_SYSTEM_RAPIDJSON=ON
		-DCLANG_LINK_CLANG_DYLIB=ON
	)
	cmake_src_configure
}
