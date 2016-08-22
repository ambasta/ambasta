# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6

inherit cmake-utils

DESCRIPTION="Remote Procedure Call framework that puts mobile and HTTP/2 first"
HOMEPAGE="http://www.grpc.io/"

if [[ ${PV} == 9999 ]]; then
	inherit git-r3
	EGIT_REPO_URI="https://github.com/ambasta/grpc.git"
else
	SRC_URI=""
	KEYWORDS="~amd64 ~x86"
fi

LICENSE="BSD" # All implementations are 3-clause BSD. http://www.grpc.io/faq/
SLOT=0

KEYWORDS="~amd64 ~x86"
IUSE="static-libs"
DEPEND=">=dev-libs/protobuf-3.0.0:0"

EGIT_CLONE_TYPE=single
EGIT_SUBMODULES=('third_party/nanopb')

src_configure() {
	local mycmakeargs=(
		-DBUILD_SHARED_LIBS=$(usex static-libs OFF ON)
		-DgRPC_ZLIB_PROVIDER=package
		-DgRPC_SSL_PROVIDER=package
		-DgRPC_PROTOBUF_PROVIDER=package
		-DgRPC_USE_PROTO_LITE=OFF
	)
	cmake-utils_src_configure
}
