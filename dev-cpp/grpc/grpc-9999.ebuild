# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

inherit toolchain-funcs git-r3

DESCRIPTION="The C based gRPC"
HOMEPAGE="http://www.grpc.io/"
EGIT_REPO_URI='https://github.com/grpc/grpc.git'

LICENSE="Google-TOS"
SLOT=0

KEYWORDS="amd64"
IUSE="static-libs -minimal"
DEPEND="dev-libs/protobuf"

EGIT_CLONE_TYPE=single
EGIT_SUBMODULES=('third_party/nanopb')

src_prepare() {
	epatch "${FILESDIR}/fix-makefile.patch"
}

src_compile() {
	emake shared
	use static-libs && emake static
	use minimal || emake plugins
}

src_install() {
	emake install
}
