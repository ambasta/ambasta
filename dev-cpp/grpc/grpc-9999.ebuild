# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

inherit toolchain-funcs git-r3

DESCRIPTION="Remote Procedure Call framework that puts mobile and HTTP/2 first"
HOMEPAGE="http://www.grpc.io/"
EGIT_REPO_URI='https://github.com/grpc/grpc.git'

LICENSE="BSD" # All implementations are 3-clause BSD. http://www.grpc.io/faq/
SLOT=0

KEYWORDS="~amd64 ~x86"
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
