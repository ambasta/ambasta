# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=3

inherit multilib

DESCRIPTION="a library of Limited-memory Broyden-Fletcher-Goldfarb-Shanno (L-BFGS)"
HOMEPAGE="http://www.chokkan.org/software/liblbfgs/"
SRC_URI="http://www.chokkan.org/software/dist/${P}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~x86 ~amd64-linux ~x86-linux ~x64-macos ~x86-macos"
IUSE=""

DEPEND=""
RDEPEND="${DEPEND}"

src_install() {
	emake DESTDIR="${D}" install || die
}
