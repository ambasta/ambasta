# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

inherit autotools
DESCRIPTION="the Paper theme official icons."
HOMEPAGE="https://github.com/snwh/${PN}"

inherit git-r3
EGIT_REPO_URI="https://github.com/snwh/${PN}.git"
KEYWORDS="~amd64 ~x86"

SLOT="0"

DEPEND=""
RDEPEND="${DEPEND}"

src_prepare() {
	eautoreconf
}

src_install() {
	emake DESTDIR="${D}" install
}
