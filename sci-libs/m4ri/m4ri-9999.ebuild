# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6

inherit autotools flag-o-matic toolchain-funcs git-r3

DESCRIPTION="Method of four russian for inversion (M4RI)"
HOMEPAGE="https://bitbucket.org/malb/m4ri/"
EGIT_REPO_URI="https://bitbucket.org/malb/m4ri.git"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~ppc64 ~x86 ~amd64-linux ~x86-linux ~ppc-macos ~x86-macos ~x64-macos"
IUSE="debug openmp static-libs"

DEPEND="media-libs/libpng:=
	virtual/pkgconfig"
RDEPEND="media-libs/libpng:="

src_configure() {
	eautoreconf

	econf \
		$(use_enable debug) \
		$(use_enable openmp) \
		$(use_enable static-libs static)
}
